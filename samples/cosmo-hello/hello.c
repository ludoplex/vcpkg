/* Minimal sample program demonstrating vcpkg-built library (zlib) usage with Cosmopolitan */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <zlib.h>

int main(void) {
    const char *input = "Hello from Cosmopolitan + vcpkg-built zlib!";
    unsigned long input_len = strlen(input);
    
    /* Compress the string */
    unsigned long compressed_len = compressBound(input_len);
    unsigned char *compressed = (unsigned char *)malloc(compressed_len);
    if (!compressed) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }
    
    int result = compress(compressed, &compressed_len, (const unsigned char *)input, input_len);
    if (result != Z_OK) {
        fprintf(stderr, "Compression failed: %d\n", result);
        return 1;
    }
    
    printf("Original:   %s\n", input);
    printf("Original size:   %lu bytes\n", input_len);
    printf("Compressed size: %lu bytes\n", compressed_len);
    
    /* Decompress to verify */
    unsigned long decompressed_len = input_len;
    unsigned char *decompressed = (unsigned char *)malloc(decompressed_len + 1);
    if (!decompressed) {
        fprintf(stderr, "Memory allocation failed\n");
        free(compressed);
        return 1;
    }
    
    result = uncompress(decompressed, &decompressed_len, compressed, compressed_len);
    if (result != Z_OK) {
        fprintf(stderr, "Decompression failed: %d\n", result);
        free(compressed);
        free(decompressed);
        return 1;
    }
    
    decompressed[decompressed_len] = '\0';
    printf("Decompressed: %s\n", (char *)decompressed);
    
    /* Verify zlib version */
    printf("\nUsing zlib version: %s\n", zlibVersion());
    printf("Successfully linked vcpkg-built zlib with Cosmopolitan!\n");
    
    /* Clean up */
    free(compressed);
    free(decompressed);
    
    return 0;
}
