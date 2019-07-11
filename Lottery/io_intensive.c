#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"


int main(int argc, char const *argv[])
{
    int id;

    for (int i=0; i < 4; i++) {
        id = fork();
        if (id < 0)
        {
            printf(1, "failed in fork!\n");
        }
        else if (id > 0) 
        {
            printf(1, "I'm Parent (%d) Of Child (%d)\n\n", getpid(), id);
            while (wait() <= 0);
        }
        else 
        { 
            printf(1, "I'm Child (%d)\n", getpid());
            int fd;
            char *buffer = "1234567890123456";
            for (int i=0; i < 100; i++) 
            {
                char* file_name = (char*)malloc(20 * sizeof(char));
                file_name[0] = id;
                fd = open(file_name, O_WRONLY);
                write (fd, buffer, 16);
                close (fd);
            }
            break;
        }
    }
    
    exit();
}
