
#include "syscall.h"

char* getName(int num)
{
  switch (num) {
      case SYS_fork:
        return("fork");
        break;
      case SYS_exit:
        return("exit");
        break;
      case SYS_wait:
        return("wait");
        break;
      case SYS_pipe:
        return("pipe");
        break;
      case SYS_read:
        return("read");
        break;
      case SYS_kill:
        return("kill");
        break;
      case SYS_exec:
        return("exec");
        break;
      case SYS_fstat:
        return("fstat");
        break;
      case SYS_chdir:
        return("chdir");
        break;
      case SYS_dup:
        return("dup");
        break;
      case SYS_getpid:
        return("getpid");
        break;
      case SYS_sbrk:
        return("sbrk");
        break;
      case SYS_sleep:
        return("sleep");
        break;
      case SYS_uptime:
        return("uptime");
        break;
      case SYS_open:
        return("open");
        break;
      case SYS_write:
        return("write");
        break;
      case SYS_mknod:
        return("mknod");
        break;
      case SYS_unlink:
        return("unlink");
        break;
      case SYS_link:
        return("link");
        break;
      case SYS_mkdir:
        return("mkdir");
        break;
      case SYS_close:
        return("close");
        break;
      case SYS_invoked_syscalls:
        return("invoked_syscalls");
        break;
      case SYS_log_syscalls:
        return("log_syscalls");
        break;
      default:
      {
        panic("should never get here\n");
        return "";
      }
    }
}