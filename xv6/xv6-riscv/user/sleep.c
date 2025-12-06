#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    if(argc <2){
        printf("Usage:sleep <ticks>\n")
        exit(1);
    }
    int ticks = atoi(argv[1]);
    for(int i=0;i<ticks;i++){
        pause();
        
    }
    exit(0);
}