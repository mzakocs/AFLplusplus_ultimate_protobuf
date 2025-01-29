#pragma once

#include "src/mutator.h"

class MyMutator : public protobuf_mutator::Mutator {};

typedef struct custom_mutator {
    MyMutator *mutator;
    unsigned int seed;
    uint8_t *mutated_out_buf;
    size_t mutated_out_buf_size;
} custom_mutator_t;

#define INITIAL_OUT_BUF_SIZE 128 

uint8_t dummy[INITIAL_OUT_BUF_SIZE] = {}; 

#define DEFINE_PROTO_MUTATOR_CUSTOM_INIT \
    extern "C" custom_mutator_t *afl_custom_init(void *afl, unsigned int seed) { \
        /* Initialize custom mutator arg structure */ \
        custom_mutator_t *data = (custom_mutator_t *)malloc(sizeof(custom_mutator_t)); \
        if (!data) { \
            perror("[mutator] [afl_custom_init] custom_mutator alloc failed"); \
            return NULL; \
        } \
        /* Initialize rand seed */ \
        data->seed = seed; \
        srand(seed); \
        /* Initialize mutated output buffer & size */ \
        data->mutated_out_buf = (uint8_t*)malloc(INITIAL_OUT_BUF_SIZE); \
        data->mutated_out_buf_size = INITIAL_OUT_BUF_SIZE; \
        /* Initialize protobuf mutator */ \
        data->mutator = new MyMutator(); \
        return data; \
    } 

#define DEFINE_PROTO_MUTATOR_CUSTOM_FUZZ(ProtoType) \
    extern "C" size_t afl_custom_fuzz(custom_mutator_t *data, \
                        uint8_t *buf, size_t buf_size, \
                        uint8_t **out_buf, \
                        uint8_t *add_buf, size_t add_buf_size,  \
                        size_t max_size) { \
        /* Parse the text protobuf */ \
        ProtoType input; \
        std::string text_proto((const char*)buf, buf_size); \
        bool parse_ok = google::protobuf::TextFormat::ParseFromString(text_proto, &input); \
        if(!parse_ok) { \
            *out_buf = dummy; \
            return 0; \
        } \
        /* Mutate the protobuf */ \
        data->mutator->Mutate(&input, max_size); \
        /* Convert protobuf to raw data */ \
        std::string raw;  \
        google::protobuf::TextFormat::PrintToString(input, &raw);  \
        /* Reallocate mutated_out buffer if needed */ \
        size_t mutated_size = raw.size() <= max_size ? raw.size() : max_size; /* check if raw data's size is larger than max_size */ \
        if(data->mutated_out_buf_size < mutated_size) { \
            data->mutated_out_buf = (uint8_t*)realloc(data->mutated_out_buf, mutated_size); \
            data->mutated_out_buf_size = mutated_size; \
        } \
        /* Copy the raw data to output buffer */ \
        memcpy(data->mutated_out_buf, raw.c_str(), mutated_size); \
        *out_buf = data->mutated_out_buf; \
        return mutated_size; \
    } 

#define DEFINE_PROTO_MUTATOR_CUSTOM_DEINIT \
    extern "C" void afl_custom_deinit(custom_mutator_t *data) { \
        /* Free all allocated buffers */ \
        delete data->mutator; \
        free(data->mutated_out_buf); \
        free(data); \
        return; \
    }

#define DEFINE_PROTO_MUTATOR(ProtoType) \
    DEFINE_PROTO_MUTATOR_CUSTOM_INIT \
    DEFINE_PROTO_MUTATOR_CUSTOM_FUZZ(ProtoType) \
    DEFINE_PROTO_MUTATOR_CUSTOM_DEINIT 