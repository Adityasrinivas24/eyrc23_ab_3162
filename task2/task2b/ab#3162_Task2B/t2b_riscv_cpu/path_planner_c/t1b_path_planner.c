#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

#define V 30
#define INF 0xf

#ifdef __linux__ // for host pc


    void _put_byte(char c) { putchar(c); }

    void _put_str(char *str) {
        while (*str) {
            _put_byte(*str++);
        }
    }

    void print_output(uint8_t num) {
        if (num == 0) {
            putchar('0'); // if the number is 0, directly print '0'
            _put_byte('\n');
            return;
        }

        if (num < 0) {
            putchar('-'); // print the negative sign for negative numbers
            num = -num;   // make the number positive for easier processing
        }

        // convert the integer to a string
        char buffer[20]; // assuming a 32-bit integer, the maximum number of digits is 10 (plus sign and null terminator)
        uint8_t index = 0;

        while (num > 0) {
            buffer[index++] = '0' + num % 10; // convert the last digit to its character representation
            num /= 10;                        // move to the next digit
        }

        // print the characters in reverse order (from right to left)
        while (index > 0) { putchar(buffer[--index]); }
        _put_byte('\n');
    }

    void _put_value(uint8_t val) { print_output(val); }

#else  // for the test device

    void _put_value(uint8_t val) { }
    void _put_str(char *str) { }

#endif

//to find the bit value at a particular position
int bitposition(uint32_t *n, uint8_t *i) {
    return ((*n >> (29-*i)) & 1);
}
//to set the bit value at a particular position
void bitload(uint32_t *n, uint8_t *i){
    *n |= 0x20000000 >> *i;
}

//to read the 4bit value at a particular position
uint8_t arrayindex(uint32_t *arr, uint8_t n) {
    return (arr[(n & 0xf8)>>3]&(0XF0000000>>((n&0x7)*4)))>>(~(n&0x7)*4); 
} 
//to read the byte value at a particular position 
uint8_t arrayindex8(uint32_t *arr, uint8_t n) {
    return (arr[(n & 0xfc)>>2]&(0XFF000000>>((n&0x3)*8)))>>(~(n&0x3)*8); 
} 

//to write the 4bit value at a particular position
void array_write(uint32_t *arr, uint8_t *n, uint8_t val) {
    arr[(*n & 0xf8)>>3] = (arr[(*n & 0xf8)>>3]&~(0XF0000000>>((*n&0x7)*4))) | (val << (~(*n&0x7)*4));
}
//to write the byte value at a particular position
void array_write8(uint32_t *arr, uint8_t *n, uint8_t val) {
    arr[(*n & 0xfc)>>2] = (arr[(*n & 0xfc)>>2]&~(0XFF000000>>((*n&0x3)*8))) | (val << (~(*n&0x3)*8));
}

// A utility function to find the vertex with minimum distance value from src and not in sptSet
uint8_t minDistance(uint32_t dist[], uint32_t *sptSet)
{
	int min = INF, min_index;

	for (uint8_t v = 0; v < V; v++)
		if (bitposition(sptSet,&v) == false && arrayindex (dist,v) <= min)
			min = arrayindex (dist,v), min_index = v;

	return min_index;
}


// main function
int main(int argc, char const *argv[]) {

    #ifdef __linux__

        const uint8_t START_POINT   = atoi(argv[1]);
        const uint8_t END_POINT     = atoi(argv[2]);
        uint8_t NODE_POINT          = 0;
        uint8_t CPU_DONE            = 0;

    #else
        // Address value of variables are updated for RISC-V Implementation
        #define START_POINT         (* (volatile uint8_t * ) 0x02000000)
        #define END_POINT           (* (volatile uint8_t * ) 0x02000004)
        #define NODE_POINT          (* (volatile uint8_t * ) 0x02000008)
        #define CPU_DONE            (* (volatile uint8_t * ) 0x0200000c)

    #endif


    // index to keep track of the path_planned array
    uint8_t idx = 0;


    // ############# Add your code here #############
    
    // check if the start and end points are valid
    if(!(30>START_POINT && START_POINT>=0 && 30>END_POINT && END_POINT>=0)) return 0;

    uint32_t visited = 0x0; // visited vertices represented as a bit vector

    #ifdef __linux__    // for host pc
        uint32_t prev[8]; // array to store the parent of each vertex, each 32 bit integer stores 8 vertices
        uint32_t dist[4]; // array to store the distance of each vertex, each 32 bit integer stores 4 vertices
        uint32_t path_planned[30]; // array to store the planned path and adjacency matrix of the graph
    #else
        uint32_t *path_planned =0x02000040;      
        uint32_t *prev = 0x02000020; 
        uint32_t *dist = 0x02000010;
    #endif

    // adjacency matrix of the graph
    path_planned[0] = 0b010000000000000000000000000000;
    path_planned[1] = 0b101000000000000000000000000001;
    path_planned[2] = 0b010100001000000000000000000000;
    path_planned[3] = 0b001010000000000000000000000010;
    path_planned[4] = 0b000101100000000000000000000000;
    path_planned[5] = 0b000010000000000000000000000000;
    path_planned[6] = 0b000010010000000000000000000000;
    path_planned[7] = 0b000000101000000000000000000000;
    path_planned[8] = 0b001000010100100000000000000000;
    path_planned[9] = 0b000000001011000000000000000000;
    path_planned[10] = 0b000000000100000000000000000000;
    path_planned[11] = 0b000000000100000000000000000000;
    path_planned[12] = 0b000000001000010000010000000000;
    path_planned[13] = 0b000000000000101000000000000000;
    path_planned[14] = 0b000000000000000110000000000000;
    path_planned[15] = 0b000000000000001000000000000000;
    path_planned[16] = 0b000000000000001001100000000000;
    path_planned[17] = 0b000000000000000010000000000000;
    path_planned[18] = 0b000000000000000010010000000000;
    path_planned[19] = 0b000000000000100000101000000000;
    path_planned[20] = 0b000000000000000000010100100001;
    path_planned[21] = 0b000000000000000000001011000000;
    path_planned[22] = 0b000000000000000000000100000000;
    path_planned[23] = 0b000000000000000000000100000000;
    path_planned[24] = 0b000000000000000000001000010000;
    path_planned[25] = 0b000000000000000000000000101000;
    path_planned[26] = 0b000000000000000000000000010110;
    path_planned[27] = 0b000000000000000000000000001000;
    path_planned[28] = 0b000100000000000000000000001001;
    path_planned[29] = 0b010000000000000000001000000010;

    // initialize the distance of all vertices to infinity
    for (uint8_t i = 0; i < 4; i++) {
        dist[i] = 0xffffffff;
    }

    // initialize the distance of the start vertex to 0
    array_write(dist, &START_POINT, 0);
    // initialize the parent of the start vertex to 0xff
    array_write8(prev, &START_POINT, 0xff);



    for (uint8_t i = 0; i < V - 1; i++) {
        // pick the vertex with the minimum distance from the set of unvisited vertices
		uint8_t u = minDistance(dist, &visited);

        //break if the destination is reached
        if (u == END_POINT) break;

        //mark the vertex as visited
		bitload(&visited,&u);

        // updating the distance of the adjacent unvisited vertices
		for (uint8_t v = 0; v < V; v++)
			if (!bitposition (&visited,&v) && bitposition (&path_planned[u],&v)   
                                // if the vertex is not visited (value of current v has never been the value of u) 
                                //and there is an edge between u and v
				&& arrayindex(dist,u) != INF  
                                // if the distance of u is not infinity
				&& arrayindex(dist,u) + bitposition (&path_planned[u],&v) < arrayindex(dist,v)) 
                                // sum of distance to u and edge weight of v-u is 
                                //less than the distance to v (v is not visited)
                {
                    array_write(dist,&v,arrayindex(dist,u) + bitposition (&path_planned[u],&v)); //update the distance of v     
                    array_write8(prev,&v, u); //update the parent of v
                }
	}

    // backtracking the path from the destination to the start
    uint8_t currentVertex = END_POINT;

    path_planned[(idx)++] = currentVertex;
    while (currentVertex != START_POINT) {
        path_planned[(idx)++]= currentVertex = arrayindex8(prev,currentVertex);
    }

    // ##############################################

    // the node values are written into data memory sequentially.
    for (int i = --idx; i >=0; i--) {
        NODE_POINT = path_planned[i];
    }

    // Path Planning Computation Done Flag
    CPU_DONE = 1;

    #ifdef __linux__    // for host pc

        _put_str("######### Planned Path #########\n");
        for (int i = idx; i >=0; i--) {
            _put_value(path_planned[i]);
        }
        _put_str("################################\n");

    #endif

    return 0;
}
