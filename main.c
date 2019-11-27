#include <stdio.h>
#include<string.h>
#include<stdlib.h>

char* join(char* sep, char** list, int n, char* buf);

int main()
{
	int n;
	int chars=0;
	printf("Podaj liczbe zdan:");
	scanf("%d", &n);
	char** list;
	list = (char**)malloc(sizeof(char*) * n);
	for (int i = 0; i < n; i++)
	{
		printf("Wpisz zadanie nr %d: \n", i + 1);
		list[i] = (char*)malloc(80);
		memset(list[i], 0, 80);
		chars += scanf("%s", list[i]);
	}
	
	char sep[] = ", ";
	char *buf = (char*)malloc(sizeof(char)*chars +10*n*2);
	memset(buf, 0, sizeof(char)*chars+ 10*n*2);
	char *c = join(sep, list, n, buf);
	printf(c);
	return 0;
}