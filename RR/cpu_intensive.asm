
_cpu_intensive:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char const* argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	bb 06 00 00 00       	mov    $0x6,%ebx
  15:	83 ec 0c             	sub    $0xc,%esp
    int id;
    int x;

for (int i=0 ; i < 6; i++)
    {
        id = fork();
  18:	e8 bd 02 00 00       	call   2da <fork>
        if (id < 0) {
  1d:	85 c0                	test   %eax,%eax
        id = fork();
  1f:	89 c6                	mov    %eax,%esi
        if (id < 0) {
  21:	78 35                	js     58 <main+0x58>
            printf(1, "%d failed in fork!\n", getpid());
        }
        if (id > 0)
  23:	74 4d                	je     72 <main+0x72>
  25:	8d 76 00             	lea    0x0(%esi),%esi
        {
            while (wait() <= 0);
  28:	e8 bd 02 00 00       	call   2ea <wait>
  2d:	85 c0                	test   %eax,%eax
  2f:	7e f7                	jle    28 <main+0x28>
            
            printf(1, "Parent %d creating child %d!\n", getpid(), id);
  31:	e8 2c 03 00 00       	call   362 <getpid>
  36:	56                   	push   %esi
  37:	50                   	push   %eax
  38:	68 ac 07 00 00       	push   $0x7ac
  3d:	6a 01                	push   $0x1
  3f:	e8 fc 03 00 00       	call   440 <printf>
  44:	83 c4 10             	add    $0x10,%esp
for (int i=0 ; i < 6; i++)
  47:	83 eb 01             	sub    $0x1,%ebx
  4a:	75 cc                	jne    18 <main+0x18>
                x = x * 0.1 * 0.2;
            }
            break;
        }
    }
    exit();
  4c:	e8 91 02 00 00       	call   2e2 <exit>
  51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(1, "%d failed in fork!\n", getpid());
  58:	e8 05 03 00 00       	call   362 <getpid>
  5d:	83 ec 04             	sub    $0x4,%esp
  60:	50                   	push   %eax
  61:	68 98 07 00 00       	push   $0x798
  66:	6a 01                	push   $0x1
  68:	e8 d3 03 00 00       	call   440 <printf>
  6d:	83 c4 10             	add    $0x10,%esp
  70:	eb d5                	jmp    47 <main+0x47>
            printf(1, "Child %d created\n", getpid());
  72:	e8 eb 02 00 00       	call   362 <getpid>
  77:	52                   	push   %edx
  78:	50                   	push   %eax
  79:	68 ca 07 00 00       	push   $0x7ca
  7e:	6a 01                	push   $0x1
  80:	e8 bb 03 00 00       	call   440 <printf>
  85:	83 c4 10             	add    $0x10,%esp
  88:	eb c2                	jmp    4c <main+0x4c>
  8a:	66 90                	xchg   %ax,%ax
  8c:	66 90                	xchg   %ax,%ax
  8e:	66 90                	xchg   %ax,%ax

00000090 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	53                   	push   %ebx
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9a:	89 c2                	mov    %eax,%edx
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  a0:	83 c1 01             	add    $0x1,%ecx
  a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  a7:	83 c2 01             	add    $0x1,%edx
  aa:	84 db                	test   %bl,%bl
  ac:	88 5a ff             	mov    %bl,-0x1(%edx)
  af:	75 ef                	jne    a0 <strcpy+0x10>
    ;
  return os;
}
  b1:	5b                   	pop    %ebx
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    
  b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	53                   	push   %ebx
  c4:	8b 55 08             	mov    0x8(%ebp),%edx
  c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ca:	0f b6 02             	movzbl (%edx),%eax
  cd:	0f b6 19             	movzbl (%ecx),%ebx
  d0:	84 c0                	test   %al,%al
  d2:	75 1c                	jne    f0 <strcmp+0x30>
  d4:	eb 2a                	jmp    100 <strcmp+0x40>
  d6:	8d 76 00             	lea    0x0(%esi),%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  e0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  e3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  e6:	83 c1 01             	add    $0x1,%ecx
  e9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
  ec:	84 c0                	test   %al,%al
  ee:	74 10                	je     100 <strcmp+0x40>
  f0:	38 d8                	cmp    %bl,%al
  f2:	74 ec                	je     e0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  f4:	29 d8                	sub    %ebx,%eax
}
  f6:	5b                   	pop    %ebx
  f7:	5d                   	pop    %ebp
  f8:	c3                   	ret    
  f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 100:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 102:	29 d8                	sub    %ebx,%eax
}
 104:	5b                   	pop    %ebx
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    
 107:	89 f6                	mov    %esi,%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000110 <strlen>:

uint
strlen(const char *s)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 116:	80 39 00             	cmpb   $0x0,(%ecx)
 119:	74 15                	je     130 <strlen+0x20>
 11b:	31 d2                	xor    %edx,%edx
 11d:	8d 76 00             	lea    0x0(%esi),%esi
 120:	83 c2 01             	add    $0x1,%edx
 123:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 127:	89 d0                	mov    %edx,%eax
 129:	75 f5                	jne    120 <strlen+0x10>
    ;
  return n;
}
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    
 12d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 130:	31 c0                	xor    %eax,%eax
}
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    
 134:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 13a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000140 <memset>:

void*
memset(void *dst, int c, uint n)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	57                   	push   %edi
 144:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 147:	8b 4d 10             	mov    0x10(%ebp),%ecx
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	89 d7                	mov    %edx,%edi
 14f:	fc                   	cld    
 150:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 152:	89 d0                	mov    %edx,%eax
 154:	5f                   	pop    %edi
 155:	5d                   	pop    %ebp
 156:	c3                   	ret    
 157:	89 f6                	mov    %esi,%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <strchr>:

char*
strchr(const char *s, char c)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	53                   	push   %ebx
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 16a:	0f b6 10             	movzbl (%eax),%edx
 16d:	84 d2                	test   %dl,%dl
 16f:	74 1d                	je     18e <strchr+0x2e>
    if(*s == c)
 171:	38 d3                	cmp    %dl,%bl
 173:	89 d9                	mov    %ebx,%ecx
 175:	75 0d                	jne    184 <strchr+0x24>
 177:	eb 17                	jmp    190 <strchr+0x30>
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 180:	38 ca                	cmp    %cl,%dl
 182:	74 0c                	je     190 <strchr+0x30>
  for(; *s; s++)
 184:	83 c0 01             	add    $0x1,%eax
 187:	0f b6 10             	movzbl (%eax),%edx
 18a:	84 d2                	test   %dl,%dl
 18c:	75 f2                	jne    180 <strchr+0x20>
      return (char*)s;
  return 0;
 18e:	31 c0                	xor    %eax,%eax
}
 190:	5b                   	pop    %ebx
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    
 193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001a0 <gets>:

char*
gets(char *buf, int max)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	56                   	push   %esi
 1a5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a6:	31 f6                	xor    %esi,%esi
 1a8:	89 f3                	mov    %esi,%ebx
{
 1aa:	83 ec 1c             	sub    $0x1c,%esp
 1ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 1b0:	eb 2f                	jmp    1e1 <gets+0x41>
 1b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 1b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1bb:	83 ec 04             	sub    $0x4,%esp
 1be:	6a 01                	push   $0x1
 1c0:	50                   	push   %eax
 1c1:	6a 00                	push   $0x0
 1c3:	e8 32 01 00 00       	call   2fa <read>
    if(cc < 1)
 1c8:	83 c4 10             	add    $0x10,%esp
 1cb:	85 c0                	test   %eax,%eax
 1cd:	7e 1c                	jle    1eb <gets+0x4b>
      break;
    buf[i++] = c;
 1cf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1d3:	83 c7 01             	add    $0x1,%edi
 1d6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 1d9:	3c 0a                	cmp    $0xa,%al
 1db:	74 23                	je     200 <gets+0x60>
 1dd:	3c 0d                	cmp    $0xd,%al
 1df:	74 1f                	je     200 <gets+0x60>
  for(i=0; i+1 < max; ){
 1e1:	83 c3 01             	add    $0x1,%ebx
 1e4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1e7:	89 fe                	mov    %edi,%esi
 1e9:	7c cd                	jl     1b8 <gets+0x18>
 1eb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 1f0:	c6 03 00             	movb   $0x0,(%ebx)
}
 1f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f6:	5b                   	pop    %ebx
 1f7:	5e                   	pop    %esi
 1f8:	5f                   	pop    %edi
 1f9:	5d                   	pop    %ebp
 1fa:	c3                   	ret    
 1fb:	90                   	nop
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 200:	8b 75 08             	mov    0x8(%ebp),%esi
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	01 de                	add    %ebx,%esi
 208:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 20a:	c6 03 00             	movb   $0x0,(%ebx)
}
 20d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 210:	5b                   	pop    %ebx
 211:	5e                   	pop    %esi
 212:	5f                   	pop    %edi
 213:	5d                   	pop    %ebp
 214:	c3                   	ret    
 215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <stat>:

int
stat(const char *n, struct stat *st)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 225:	83 ec 08             	sub    $0x8,%esp
 228:	6a 00                	push   $0x0
 22a:	ff 75 08             	pushl  0x8(%ebp)
 22d:	e8 f0 00 00 00       	call   322 <open>
  if(fd < 0)
 232:	83 c4 10             	add    $0x10,%esp
 235:	85 c0                	test   %eax,%eax
 237:	78 27                	js     260 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 239:	83 ec 08             	sub    $0x8,%esp
 23c:	ff 75 0c             	pushl  0xc(%ebp)
 23f:	89 c3                	mov    %eax,%ebx
 241:	50                   	push   %eax
 242:	e8 f3 00 00 00       	call   33a <fstat>
  close(fd);
 247:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 24a:	89 c6                	mov    %eax,%esi
  close(fd);
 24c:	e8 b9 00 00 00       	call   30a <close>
  return r;
 251:	83 c4 10             	add    $0x10,%esp
}
 254:	8d 65 f8             	lea    -0x8(%ebp),%esp
 257:	89 f0                	mov    %esi,%eax
 259:	5b                   	pop    %ebx
 25a:	5e                   	pop    %esi
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    
 25d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 260:	be ff ff ff ff       	mov    $0xffffffff,%esi
 265:	eb ed                	jmp    254 <stat+0x34>
 267:	89 f6                	mov    %esi,%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <atoi>:

int
atoi(const char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 277:	0f be 11             	movsbl (%ecx),%edx
 27a:	8d 42 d0             	lea    -0x30(%edx),%eax
 27d:	3c 09                	cmp    $0x9,%al
  n = 0;
 27f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 284:	77 1f                	ja     2a5 <atoi+0x35>
 286:	8d 76 00             	lea    0x0(%esi),%esi
 289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 290:	8d 04 80             	lea    (%eax,%eax,4),%eax
 293:	83 c1 01             	add    $0x1,%ecx
 296:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 29a:	0f be 11             	movsbl (%ecx),%edx
 29d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2a0:	80 fb 09             	cmp    $0x9,%bl
 2a3:	76 eb                	jbe    290 <atoi+0x20>
  return n;
}
 2a5:	5b                   	pop    %ebx
 2a6:	5d                   	pop    %ebp
 2a7:	c3                   	ret    
 2a8:	90                   	nop
 2a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	56                   	push   %esi
 2b4:	53                   	push   %ebx
 2b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2be:	85 db                	test   %ebx,%ebx
 2c0:	7e 14                	jle    2d6 <memmove+0x26>
 2c2:	31 d2                	xor    %edx,%edx
 2c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2cf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2d2:	39 d3                	cmp    %edx,%ebx
 2d4:	75 f2                	jne    2c8 <memmove+0x18>
  return vdst;
}
 2d6:	5b                   	pop    %ebx
 2d7:	5e                   	pop    %esi
 2d8:	5d                   	pop    %ebp
 2d9:	c3                   	ret    

000002da <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2da:	b8 01 00 00 00       	mov    $0x1,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <exit>:
SYSCALL(exit)
 2e2:	b8 02 00 00 00       	mov    $0x2,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <wait>:
SYSCALL(wait)
 2ea:	b8 03 00 00 00       	mov    $0x3,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <pipe>:
SYSCALL(pipe)
 2f2:	b8 04 00 00 00       	mov    $0x4,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <read>:
SYSCALL(read)
 2fa:	b8 05 00 00 00       	mov    $0x5,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <write>:
SYSCALL(write)
 302:	b8 10 00 00 00       	mov    $0x10,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <close>:
SYSCALL(close)
 30a:	b8 15 00 00 00       	mov    $0x15,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <kill>:
SYSCALL(kill)
 312:	b8 06 00 00 00       	mov    $0x6,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <exec>:
SYSCALL(exec)
 31a:	b8 07 00 00 00       	mov    $0x7,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <open>:
SYSCALL(open)
 322:	b8 0f 00 00 00       	mov    $0xf,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <mknod>:
SYSCALL(mknod)
 32a:	b8 11 00 00 00       	mov    $0x11,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <unlink>:
SYSCALL(unlink)
 332:	b8 12 00 00 00       	mov    $0x12,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <fstat>:
SYSCALL(fstat)
 33a:	b8 08 00 00 00       	mov    $0x8,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <link>:
SYSCALL(link)
 342:	b8 13 00 00 00       	mov    $0x13,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <mkdir>:
SYSCALL(mkdir)
 34a:	b8 14 00 00 00       	mov    $0x14,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <chdir>:
SYSCALL(chdir)
 352:	b8 09 00 00 00       	mov    $0x9,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <dup>:
SYSCALL(dup)
 35a:	b8 0a 00 00 00       	mov    $0xa,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <getpid>:
SYSCALL(getpid)
 362:	b8 0b 00 00 00       	mov    $0xb,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <sbrk>:
SYSCALL(sbrk)
 36a:	b8 0c 00 00 00       	mov    $0xc,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <sleep>:
SYSCALL(sleep)
 372:	b8 0d 00 00 00       	mov    $0xd,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <uptime>:
SYSCALL(uptime)
 37a:	b8 0e 00 00 00       	mov    $0xe,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <invoked_syscalls>:
SYSCALL(invoked_syscalls)
 382:	b8 16 00 00 00       	mov    $0x16,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <log_syscalls>:
SYSCALL(log_syscalls)
 38a:	b8 17 00 00 00       	mov    $0x17,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    
 392:	66 90                	xchg   %ax,%ax
 394:	66 90                	xchg   %ax,%ax
 396:	66 90                	xchg   %ax,%ax
 398:	66 90                	xchg   %ax,%ax
 39a:	66 90                	xchg   %ax,%ax
 39c:	66 90                	xchg   %ax,%ax
 39e:	66 90                	xchg   %ax,%ax

000003a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
 3a6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a9:	85 d2                	test   %edx,%edx
{
 3ab:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 3ae:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 3b0:	79 76                	jns    428 <printint+0x88>
 3b2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3b6:	74 70                	je     428 <printint+0x88>
    x = -xx;
 3b8:	f7 d8                	neg    %eax
    neg = 1;
 3ba:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3c1:	31 f6                	xor    %esi,%esi
 3c3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3c6:	eb 0a                	jmp    3d2 <printint+0x32>
 3c8:	90                   	nop
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 3d0:	89 fe                	mov    %edi,%esi
 3d2:	31 d2                	xor    %edx,%edx
 3d4:	8d 7e 01             	lea    0x1(%esi),%edi
 3d7:	f7 f1                	div    %ecx
 3d9:	0f b6 92 e4 07 00 00 	movzbl 0x7e4(%edx),%edx
  }while((x /= base) != 0);
 3e0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 3e2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 3e5:	75 e9                	jne    3d0 <printint+0x30>
  if(neg)
 3e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3ea:	85 c0                	test   %eax,%eax
 3ec:	74 08                	je     3f6 <printint+0x56>
    buf[i++] = '-';
 3ee:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 3f3:	8d 7e 02             	lea    0x2(%esi),%edi
 3f6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 3fa:	8b 7d c0             	mov    -0x40(%ebp),%edi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
 400:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 403:	83 ec 04             	sub    $0x4,%esp
 406:	83 ee 01             	sub    $0x1,%esi
 409:	6a 01                	push   $0x1
 40b:	53                   	push   %ebx
 40c:	57                   	push   %edi
 40d:	88 45 d7             	mov    %al,-0x29(%ebp)
 410:	e8 ed fe ff ff       	call   302 <write>

  while(--i >= 0)
 415:	83 c4 10             	add    $0x10,%esp
 418:	39 de                	cmp    %ebx,%esi
 41a:	75 e4                	jne    400 <printint+0x60>
    putc(fd, buf[i]);
}
 41c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41f:	5b                   	pop    %ebx
 420:	5e                   	pop    %esi
 421:	5f                   	pop    %edi
 422:	5d                   	pop    %ebp
 423:	c3                   	ret    
 424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 428:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 42f:	eb 90                	jmp    3c1 <printint+0x21>
 431:	eb 0d                	jmp    440 <printf>
 433:	90                   	nop
 434:	90                   	nop
 435:	90                   	nop
 436:	90                   	nop
 437:	90                   	nop
 438:	90                   	nop
 439:	90                   	nop
 43a:	90                   	nop
 43b:	90                   	nop
 43c:	90                   	nop
 43d:	90                   	nop
 43e:	90                   	nop
 43f:	90                   	nop

00000440 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	56                   	push   %esi
 445:	53                   	push   %ebx
 446:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 449:	8b 75 0c             	mov    0xc(%ebp),%esi
 44c:	0f b6 1e             	movzbl (%esi),%ebx
 44f:	84 db                	test   %bl,%bl
 451:	0f 84 b3 00 00 00    	je     50a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 457:	8d 45 10             	lea    0x10(%ebp),%eax
 45a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 45d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 45f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 462:	eb 2f                	jmp    493 <printf+0x53>
 464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 468:	83 f8 25             	cmp    $0x25,%eax
 46b:	0f 84 a7 00 00 00    	je     518 <printf+0xd8>
  write(fd, &c, 1);
 471:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 474:	83 ec 04             	sub    $0x4,%esp
 477:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 47a:	6a 01                	push   $0x1
 47c:	50                   	push   %eax
 47d:	ff 75 08             	pushl  0x8(%ebp)
 480:	e8 7d fe ff ff       	call   302 <write>
 485:	83 c4 10             	add    $0x10,%esp
 488:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 48b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 48f:	84 db                	test   %bl,%bl
 491:	74 77                	je     50a <printf+0xca>
    if(state == 0){
 493:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 495:	0f be cb             	movsbl %bl,%ecx
 498:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 49b:	74 cb                	je     468 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 49d:	83 ff 25             	cmp    $0x25,%edi
 4a0:	75 e6                	jne    488 <printf+0x48>
      if(c == 'd'){
 4a2:	83 f8 64             	cmp    $0x64,%eax
 4a5:	0f 84 05 01 00 00    	je     5b0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4ab:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 4b1:	83 f9 70             	cmp    $0x70,%ecx
 4b4:	74 72                	je     528 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4b6:	83 f8 73             	cmp    $0x73,%eax
 4b9:	0f 84 99 00 00 00    	je     558 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4bf:	83 f8 63             	cmp    $0x63,%eax
 4c2:	0f 84 08 01 00 00    	je     5d0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4c8:	83 f8 25             	cmp    $0x25,%eax
 4cb:	0f 84 ef 00 00 00    	je     5c0 <printf+0x180>
  write(fd, &c, 1);
 4d1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4d4:	83 ec 04             	sub    $0x4,%esp
 4d7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4db:	6a 01                	push   $0x1
 4dd:	50                   	push   %eax
 4de:	ff 75 08             	pushl  0x8(%ebp)
 4e1:	e8 1c fe ff ff       	call   302 <write>
 4e6:	83 c4 0c             	add    $0xc,%esp
 4e9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4ec:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4ef:	6a 01                	push   $0x1
 4f1:	50                   	push   %eax
 4f2:	ff 75 08             	pushl  0x8(%ebp)
 4f5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 4fa:	e8 03 fe ff ff       	call   302 <write>
  for(i = 0; fmt[i]; i++){
 4ff:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 503:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 506:	84 db                	test   %bl,%bl
 508:	75 89                	jne    493 <printf+0x53>
    }
  }
}
 50a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 50d:	5b                   	pop    %ebx
 50e:	5e                   	pop    %esi
 50f:	5f                   	pop    %edi
 510:	5d                   	pop    %ebp
 511:	c3                   	ret    
 512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 518:	bf 25 00 00 00       	mov    $0x25,%edi
 51d:	e9 66 ff ff ff       	jmp    488 <printf+0x48>
 522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 528:	83 ec 0c             	sub    $0xc,%esp
 52b:	b9 10 00 00 00       	mov    $0x10,%ecx
 530:	6a 00                	push   $0x0
 532:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 535:	8b 45 08             	mov    0x8(%ebp),%eax
 538:	8b 17                	mov    (%edi),%edx
 53a:	e8 61 fe ff ff       	call   3a0 <printint>
        ap++;
 53f:	89 f8                	mov    %edi,%eax
 541:	83 c4 10             	add    $0x10,%esp
      state = 0;
 544:	31 ff                	xor    %edi,%edi
        ap++;
 546:	83 c0 04             	add    $0x4,%eax
 549:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 54c:	e9 37 ff ff ff       	jmp    488 <printf+0x48>
 551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 558:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 55b:	8b 08                	mov    (%eax),%ecx
        ap++;
 55d:	83 c0 04             	add    $0x4,%eax
 560:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 563:	85 c9                	test   %ecx,%ecx
 565:	0f 84 8e 00 00 00    	je     5f9 <printf+0x1b9>
        while(*s != 0){
 56b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 56e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 570:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 572:	84 c0                	test   %al,%al
 574:	0f 84 0e ff ff ff    	je     488 <printf+0x48>
 57a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 57d:	89 de                	mov    %ebx,%esi
 57f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 582:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 585:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 588:	83 ec 04             	sub    $0x4,%esp
          s++;
 58b:	83 c6 01             	add    $0x1,%esi
 58e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 591:	6a 01                	push   $0x1
 593:	57                   	push   %edi
 594:	53                   	push   %ebx
 595:	e8 68 fd ff ff       	call   302 <write>
        while(*s != 0){
 59a:	0f b6 06             	movzbl (%esi),%eax
 59d:	83 c4 10             	add    $0x10,%esp
 5a0:	84 c0                	test   %al,%al
 5a2:	75 e4                	jne    588 <printf+0x148>
 5a4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 5a7:	31 ff                	xor    %edi,%edi
 5a9:	e9 da fe ff ff       	jmp    488 <printf+0x48>
 5ae:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 5b0:	83 ec 0c             	sub    $0xc,%esp
 5b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5b8:	6a 01                	push   $0x1
 5ba:	e9 73 ff ff ff       	jmp    532 <printf+0xf2>
 5bf:	90                   	nop
  write(fd, &c, 1);
 5c0:	83 ec 04             	sub    $0x4,%esp
 5c3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5c6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5c9:	6a 01                	push   $0x1
 5cb:	e9 21 ff ff ff       	jmp    4f1 <printf+0xb1>
        putc(fd, *ap);
 5d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 5d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5d6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 5d8:	6a 01                	push   $0x1
        ap++;
 5da:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 5dd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5e3:	50                   	push   %eax
 5e4:	ff 75 08             	pushl  0x8(%ebp)
 5e7:	e8 16 fd ff ff       	call   302 <write>
        ap++;
 5ec:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5ef:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5f2:	31 ff                	xor    %edi,%edi
 5f4:	e9 8f fe ff ff       	jmp    488 <printf+0x48>
          s = "(null)";
 5f9:	bb dc 07 00 00       	mov    $0x7dc,%ebx
        while(*s != 0){
 5fe:	b8 28 00 00 00       	mov    $0x28,%eax
 603:	e9 72 ff ff ff       	jmp    57a <printf+0x13a>
 608:	66 90                	xchg   %ax,%ax
 60a:	66 90                	xchg   %ax,%ax
 60c:	66 90                	xchg   %ax,%ax
 60e:	66 90                	xchg   %ax,%ax

00000610 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 610:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 611:	a1 90 0a 00 00       	mov    0xa90,%eax
{
 616:	89 e5                	mov    %esp,%ebp
 618:	57                   	push   %edi
 619:	56                   	push   %esi
 61a:	53                   	push   %ebx
 61b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 61e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 628:	39 c8                	cmp    %ecx,%eax
 62a:	8b 10                	mov    (%eax),%edx
 62c:	73 32                	jae    660 <free+0x50>
 62e:	39 d1                	cmp    %edx,%ecx
 630:	72 04                	jb     636 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 632:	39 d0                	cmp    %edx,%eax
 634:	72 32                	jb     668 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 636:	8b 73 fc             	mov    -0x4(%ebx),%esi
 639:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 63c:	39 fa                	cmp    %edi,%edx
 63e:	74 30                	je     670 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 640:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 643:	8b 50 04             	mov    0x4(%eax),%edx
 646:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 649:	39 f1                	cmp    %esi,%ecx
 64b:	74 3a                	je     687 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 64d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 64f:	a3 90 0a 00 00       	mov    %eax,0xa90
}
 654:	5b                   	pop    %ebx
 655:	5e                   	pop    %esi
 656:	5f                   	pop    %edi
 657:	5d                   	pop    %ebp
 658:	c3                   	ret    
 659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 660:	39 d0                	cmp    %edx,%eax
 662:	72 04                	jb     668 <free+0x58>
 664:	39 d1                	cmp    %edx,%ecx
 666:	72 ce                	jb     636 <free+0x26>
{
 668:	89 d0                	mov    %edx,%eax
 66a:	eb bc                	jmp    628 <free+0x18>
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 670:	03 72 04             	add    0x4(%edx),%esi
 673:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 676:	8b 10                	mov    (%eax),%edx
 678:	8b 12                	mov    (%edx),%edx
 67a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 67d:	8b 50 04             	mov    0x4(%eax),%edx
 680:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 683:	39 f1                	cmp    %esi,%ecx
 685:	75 c6                	jne    64d <free+0x3d>
    p->s.size += bp->s.size;
 687:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 68a:	a3 90 0a 00 00       	mov    %eax,0xa90
    p->s.size += bp->s.size;
 68f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 692:	8b 53 f8             	mov    -0x8(%ebx),%edx
 695:	89 10                	mov    %edx,(%eax)
}
 697:	5b                   	pop    %ebx
 698:	5e                   	pop    %esi
 699:	5f                   	pop    %edi
 69a:	5d                   	pop    %ebp
 69b:	c3                   	ret    
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000006a0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
 6a6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6ac:	8b 15 90 0a 00 00    	mov    0xa90,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b2:	8d 78 07             	lea    0x7(%eax),%edi
 6b5:	c1 ef 03             	shr    $0x3,%edi
 6b8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6bb:	85 d2                	test   %edx,%edx
 6bd:	0f 84 9d 00 00 00    	je     760 <malloc+0xc0>
 6c3:	8b 02                	mov    (%edx),%eax
 6c5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6c8:	39 cf                	cmp    %ecx,%edi
 6ca:	76 6c                	jbe    738 <malloc+0x98>
 6cc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6d2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6d7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6da:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6e1:	eb 0e                	jmp    6f1 <malloc+0x51>
 6e3:	90                   	nop
 6e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6ea:	8b 48 04             	mov    0x4(%eax),%ecx
 6ed:	39 f9                	cmp    %edi,%ecx
 6ef:	73 47                	jae    738 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6f1:	39 05 90 0a 00 00    	cmp    %eax,0xa90
 6f7:	89 c2                	mov    %eax,%edx
 6f9:	75 ed                	jne    6e8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6fb:	83 ec 0c             	sub    $0xc,%esp
 6fe:	56                   	push   %esi
 6ff:	e8 66 fc ff ff       	call   36a <sbrk>
  if(p == (char*)-1)
 704:	83 c4 10             	add    $0x10,%esp
 707:	83 f8 ff             	cmp    $0xffffffff,%eax
 70a:	74 1c                	je     728 <malloc+0x88>
  hp->s.size = nu;
 70c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 70f:	83 ec 0c             	sub    $0xc,%esp
 712:	83 c0 08             	add    $0x8,%eax
 715:	50                   	push   %eax
 716:	e8 f5 fe ff ff       	call   610 <free>
  return freep;
 71b:	8b 15 90 0a 00 00    	mov    0xa90,%edx
      if((p = morecore(nunits)) == 0)
 721:	83 c4 10             	add    $0x10,%esp
 724:	85 d2                	test   %edx,%edx
 726:	75 c0                	jne    6e8 <malloc+0x48>
        return 0;
  }
}
 728:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 72b:	31 c0                	xor    %eax,%eax
}
 72d:	5b                   	pop    %ebx
 72e:	5e                   	pop    %esi
 72f:	5f                   	pop    %edi
 730:	5d                   	pop    %ebp
 731:	c3                   	ret    
 732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 738:	39 cf                	cmp    %ecx,%edi
 73a:	74 54                	je     790 <malloc+0xf0>
        p->s.size -= nunits;
 73c:	29 f9                	sub    %edi,%ecx
 73e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 741:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 744:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 747:	89 15 90 0a 00 00    	mov    %edx,0xa90
}
 74d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 750:	83 c0 08             	add    $0x8,%eax
}
 753:	5b                   	pop    %ebx
 754:	5e                   	pop    %esi
 755:	5f                   	pop    %edi
 756:	5d                   	pop    %ebp
 757:	c3                   	ret    
 758:	90                   	nop
 759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 760:	c7 05 90 0a 00 00 94 	movl   $0xa94,0xa90
 767:	0a 00 00 
 76a:	c7 05 94 0a 00 00 94 	movl   $0xa94,0xa94
 771:	0a 00 00 
    base.s.size = 0;
 774:	b8 94 0a 00 00       	mov    $0xa94,%eax
 779:	c7 05 98 0a 00 00 00 	movl   $0x0,0xa98
 780:	00 00 00 
 783:	e9 44 ff ff ff       	jmp    6cc <malloc+0x2c>
 788:	90                   	nop
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 790:	8b 08                	mov    (%eax),%ecx
 792:	89 0a                	mov    %ecx,(%edx)
 794:	eb b1                	jmp    747 <malloc+0xa7>
