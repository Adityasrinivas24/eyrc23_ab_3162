 
// Slow LED blinker (for hardware implementation)

// For definition of uint32_t
#include <stdint.h>

// Memory mapped address of LED peripheral
#define LED    (*(volatile uint32_t  *) 0x20000004)

int main() {
    // Set initial value for led
    LED = 0b01010101010101010101010101010101;
    
    // Toggle LED indefinitely with delay
    while(1) {
        LED = ~LED;
        
        // Delay loop
        for(int i=0; i<0x100000; i++)
            asm volatile("nop");
        
        // used assembly nop instruction to prevent
        // compiler from optimizing out our loop
    }
    
    // Won't reach here
    return 0;
}
