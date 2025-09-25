#include <stdio.h>
#include <stdlib.h>

extern void simd_main();

int main() {
	simd_main();

	FILE* f = fopen("lololo.txt", "w");
	fprintf(f, "F LOLOLO");
	fclose(f);

	return 0;
}
