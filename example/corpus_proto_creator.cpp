#include <fstream>

#include <google/protobuf/text_format.h>

#include "example/example.pb.h"

int main(int argc, char** argv) {
    GOOGLE_PROTOBUF_VERIFY_VERSION;
    // Make protobuf obj
    FuzzInput *input = new FuzzInput();
    input->add_packets();
    Packet *packet = input->mutable_packets(0);
    packet->mutable_buf()->assign("Lol\n");
    packet->mutable_buf()->append(1, '\x00');
    // Write text output to stdout 
    std::string buffer; 
    google::protobuf::TextFormat::PrintToString(*input, &buffer);
    std::cout << buffer;  
    return 0;
}
