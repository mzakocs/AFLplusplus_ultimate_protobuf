#include <fcntl.h>
#include <stdint.h>

#include "example.pb.h"
#include "google/protobuf/io/zero_copy_stream_impl.h"
#include "google/protobuf/text_format.h"

static void target_function(uint8_t *buf, uint32_t size) {
    // Example mega-buggy packet parser
    uint8_t contents[0xFF];
    uint8_t *current = buf;
    while (current < (buf + size)) {
        uint32_t packet_size = *(uint32_t *)current;
        current += sizeof(uint32_t);
        memcpy(contents, current, packet_size);
        printf((char *)contents);
        current += packet_size;
    }
}

static uint32_t proto_to_bytes(char *protobuf_path, uint8_t **out_buf) {
    // Open File
    int fd = open(protobuf_path, O_RDONLY);
    google::protobuf::io::FileInputStream file_input(fd);
    file_input.SetCloseOnDelete(true);
    // Parse protobuf
    FuzzInput input;
    google::protobuf::TextFormat::Parse(&file_input, &input);
    // Calculate total size
    uint32_t total_size = sizeof(uint32_t) * input.packets().size();  // pre-allocate size integers per packet
    for (const Packet &packet : input.packets()) {
        total_size += packet.buf().size();  // pre-allocate actual size of packet
    }
    // Allocate buffer
    uint8_t *buf = new uint8_t[total_size];
    uint8_t *current_buf = buf;
    // Build packets from protobuf
    for (const Packet &packet : input.packets()) {
        // Put size integer
        uint32_t size = packet.buf().size();
        memcpy(current_buf, &size, sizeof(uint32_t));
        current_buf += sizeof(uint32_t);
        // Put buf
        memcpy(current_buf, packet.buf().c_str(), packet.buf().size());
        current_buf += packet.buf().size();
    }
    // Return buffer and size
    *out_buf = buf;
    return total_size;
}

int main(int argc, char **argv) {
    // Read in protobuf and convert to bytes
    uint8_t *buffer;
    uint32_t size = proto_to_bytes(argv[1], &buffer);
    // Feed bytes to target function
    target_function(buffer, size);
    // Cleanup
    delete[] buffer;
    return 0;
}