/*
 * Util like 'basename', but works with prefixes.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define VERSION "v1.0"

#define BUFFER_SIZE 2048

int main(int argc,unsigned char **argv){

	unsigned char *name=NULL,*prefix=NULL,*printable;
	int l;
	
	if(argc>1){
		
		if(strcmp(argv[1],"--help")==0){
			printf("Usage: pbasename PATH [PREFIX]\n"
					 "  or:  pbasename OPTION\n\n"
					 "  --help      display this help and exit\n"
					 "  --version   output version information and exit\n");
			exit(0);
		}
		else if (strcmp(argv[1],"--version")==0){
			printf("pbasename "VERSION"\n");
			exit(0);
		}
		else
		  name=strdup(argv[1]);
		
		if(argc>2)
		  prefix=strdup(argv[2]);
		
		if(name){
			if(strlen(name)>0){
				printable=name;
				/* Find location of first character after last '/'*/
				for(l=strlen(name)-1;(name[l]!='/')&&(l>0);l--);
				if(name[l]=='/')
				  l++;
				printable+=l;
				/* Check out whether prefix matches.
				 * If it does, print name without it.
				 * Otherwise just print the name.*/
				if(prefix){
					if(strncmp(printable,prefix,strlen(prefix))==0)
					  printable+=strlen(prefix);
				}
				puts(printable);
			}
			free(name);
			free(prefix);
		}
	}
	else
	  printf("pbasename: too few arguments\n"
				"Try pbasename --help' for more information.\n");
	
	exit(0);
}
