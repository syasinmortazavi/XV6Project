#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char const* argv[])
{
    int id;
    int x;

for (int i=0 ; i < 4; i++)
    {
        id = fork();
        if (id < 0) {
            printf(1, "%d Failed\n", getpid());
        }
        if (id > 0)
        {
            while (wait() <= 0);
            
            printf(1, "I'm Parent (%d) Of Child (%d)\n\n", getpid(), id);
            for (int j = 0; j < 100000; j++) 
            {
                x = x * 69 * 69;
            }
        } 
        if(id == 0) 
        {
            printf(1, "I'm Child (%d)\n", getpid());
            for (int j = 0; j < 100000; j++)
            {
                x = x * 0.1 * 0.2;
            }
            break;
        }
    }
    exit();
}
