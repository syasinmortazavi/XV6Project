
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	8b 01                	mov    (%ecx),%eax
  15:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  for(i = 1; i < argc; i++)
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 3f                	jle    5c <main+0x5c>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	eb 18                	jmp    3d <main+0x3d>
  25:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  28:	68 78 07 00 00       	push   $0x778
  2d:	50                   	push   %eax
  2e:	68 7a 07 00 00       	push   $0x77a
  33:	6a 01                	push   $0x1
  35:	e8 e6 03 00 00       	call   420 <printf>
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	83 c3 04             	add    $0x4,%ebx
  40:	8b 43 fc             	mov    -0x4(%ebx),%eax
  43:	39 f3                	cmp    %esi,%ebx
  45:	75 e1                	jne    28 <main+0x28>
  47:	68 7f 07 00 00       	push   $0x77f
  4c:	50                   	push   %eax
  4d:	68 7a 07 00 00       	push   $0x77a
  52:	6a 01                	push   $0x1
  54:	e8 c7 03 00 00       	call   420 <printf>
  59:	83 c4 10             	add    $0x10,%esp
  exit();
  5c:	e8 61 02 00 00       	call   2c2 <exit>
  61:	66 90                	xchg   %ax,%ax
  63:	66 90                	xchg   %ax,%ax
  65:	66 90                	xchg   %ax,%ax
  67:	66 90                	xchg   %ax,%ax
  69:	66 90                	xchg   %ax,%ax
  6b:	66 90                	xchg   %ax,%ax
  6d:	66 90                	xchg   %ax,%ax
  6f:	90                   	nop

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	53                   	push   %ebx
  74:	8b 45 08             	mov    0x8(%ebp),%eax
  77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	89 c2                	mov    %eax,%edx
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  80:	83 c1 01             	add    $0x1,%ecx
  83:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  87:	83 c2 01             	add    $0x1,%edx
  8a:	84 db                	test   %bl,%bl
  8c:	88 5a ff             	mov    %bl,-0x1(%edx)
  8f:	75 ef                	jne    80 <strcpy+0x10>
    ;
  return os;
}
  91:	5b                   	pop    %ebx
  92:	5d                   	pop    %ebp
  93:	c3                   	ret    
  94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	53                   	push   %ebx
  a4:	8b 55 08             	mov    0x8(%ebp),%edx
  a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  aa:	0f b6 02             	movzbl (%edx),%eax
  ad:	0f b6 19             	movzbl (%ecx),%ebx
  b0:	84 c0                	test   %al,%al
  b2:	75 1c                	jne    d0 <strcmp+0x30>
  b4:	eb 2a                	jmp    e0 <strcmp+0x40>
  b6:	8d 76 00             	lea    0x0(%esi),%esi
  b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  c0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  c3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  c6:	83 c1 01             	add    $0x1,%ecx
  c9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
  cc:	84 c0                	test   %al,%al
  ce:	74 10                	je     e0 <strcmp+0x40>
  d0:	38 d8                	cmp    %bl,%al
  d2:	74 ec                	je     c0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  d4:	29 d8                	sub    %ebx,%eax
}
  d6:	5b                   	pop    %ebx
  d7:	5d                   	pop    %ebp
  d8:	c3                   	ret    
  d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  e0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  e2:	29 d8                	sub    %ebx,%eax
}
  e4:	5b                   	pop    %ebx
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    
  e7:	89 f6                	mov    %esi,%esi
  e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  f6:	80 39 00             	cmpb   $0x0,(%ecx)
  f9:	74 15                	je     110 <strlen+0x20>
  fb:	31 d2                	xor    %edx,%edx
  fd:	8d 76 00             	lea    0x0(%esi),%esi
 100:	83 c2 01             	add    $0x1,%edx
 103:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 107:	89 d0                	mov    %edx,%eax
 109:	75 f5                	jne    100 <strlen+0x10>
    ;
  return n;
}
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    
 10d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 110:	31 c0                	xor    %eax,%eax
}
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    
 114:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 11a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	57                   	push   %edi
 124:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 127:	8b 4d 10             	mov    0x10(%ebp),%ecx
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 d7                	mov    %edx,%edi
 12f:	fc                   	cld    
 130:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 132:	89 d0                	mov    %edx,%eax
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    
 137:	89 f6                	mov    %esi,%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000140 <strchr>:

char*
strchr(const char *s, char c)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	53                   	push   %ebx
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 14a:	0f b6 10             	movzbl (%eax),%edx
 14d:	84 d2                	test   %dl,%dl
 14f:	74 1d                	je     16e <strchr+0x2e>
    if(*s == c)
 151:	38 d3                	cmp    %dl,%bl
 153:	89 d9                	mov    %ebx,%ecx
 155:	75 0d                	jne    164 <strchr+0x24>
 157:	eb 17                	jmp    170 <strchr+0x30>
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 160:	38 ca                	cmp    %cl,%dl
 162:	74 0c                	je     170 <strchr+0x30>
  for(; *s; s++)
 164:	83 c0 01             	add    $0x1,%eax
 167:	0f b6 10             	movzbl (%eax),%edx
 16a:	84 d2                	test   %dl,%dl
 16c:	75 f2                	jne    160 <strchr+0x20>
      return (char*)s;
  return 0;
 16e:	31 c0                	xor    %eax,%eax
}
 170:	5b                   	pop    %ebx
 171:	5d                   	pop    %ebp
 172:	c3                   	ret    
 173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	56                   	push   %esi
 185:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	31 f6                	xor    %esi,%esi
 188:	89 f3                	mov    %esi,%ebx
{
 18a:	83 ec 1c             	sub    $0x1c,%esp
 18d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 190:	eb 2f                	jmp    1c1 <gets+0x41>
 192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 198:	8d 45 e7             	lea    -0x19(%ebp),%eax
 19b:	83 ec 04             	sub    $0x4,%esp
 19e:	6a 01                	push   $0x1
 1a0:	50                   	push   %eax
 1a1:	6a 00                	push   $0x0
 1a3:	e8 32 01 00 00       	call   2da <read>
    if(cc < 1)
 1a8:	83 c4 10             	add    $0x10,%esp
 1ab:	85 c0                	test   %eax,%eax
 1ad:	7e 1c                	jle    1cb <gets+0x4b>
      break;
    buf[i++] = c;
 1af:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1b3:	83 c7 01             	add    $0x1,%edi
 1b6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 1b9:	3c 0a                	cmp    $0xa,%al
 1bb:	74 23                	je     1e0 <gets+0x60>
 1bd:	3c 0d                	cmp    $0xd,%al
 1bf:	74 1f                	je     1e0 <gets+0x60>
  for(i=0; i+1 < max; ){
 1c1:	83 c3 01             	add    $0x1,%ebx
 1c4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1c7:	89 fe                	mov    %edi,%esi
 1c9:	7c cd                	jl     198 <gets+0x18>
 1cb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 1d0:	c6 03 00             	movb   $0x0,(%ebx)
}
 1d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1d6:	5b                   	pop    %ebx
 1d7:	5e                   	pop    %esi
 1d8:	5f                   	pop    %edi
 1d9:	5d                   	pop    %ebp
 1da:	c3                   	ret    
 1db:	90                   	nop
 1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e0:	8b 75 08             	mov    0x8(%ebp),%esi
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	01 de                	add    %ebx,%esi
 1e8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 1ea:	c6 03 00             	movb   $0x0,(%ebx)
}
 1ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1f0:	5b                   	pop    %ebx
 1f1:	5e                   	pop    %esi
 1f2:	5f                   	pop    %edi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    
 1f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000200 <stat>:

int
stat(const char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	56                   	push   %esi
 204:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 205:	83 ec 08             	sub    $0x8,%esp
 208:	6a 00                	push   $0x0
 20a:	ff 75 08             	pushl  0x8(%ebp)
 20d:	e8 f0 00 00 00       	call   302 <open>
  if(fd < 0)
 212:	83 c4 10             	add    $0x10,%esp
 215:	85 c0                	test   %eax,%eax
 217:	78 27                	js     240 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	ff 75 0c             	pushl  0xc(%ebp)
 21f:	89 c3                	mov    %eax,%ebx
 221:	50                   	push   %eax
 222:	e8 f3 00 00 00       	call   31a <fstat>
  close(fd);
 227:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 22a:	89 c6                	mov    %eax,%esi
  close(fd);
 22c:	e8 b9 00 00 00       	call   2ea <close>
  return r;
 231:	83 c4 10             	add    $0x10,%esp
}
 234:	8d 65 f8             	lea    -0x8(%ebp),%esp
 237:	89 f0                	mov    %esi,%eax
 239:	5b                   	pop    %ebx
 23a:	5e                   	pop    %esi
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
 23d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 240:	be ff ff ff ff       	mov    $0xffffffff,%esi
 245:	eb ed                	jmp    234 <stat+0x34>
 247:	89 f6                	mov    %esi,%esi
 249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000250 <atoi>:

int
atoi(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 257:	0f be 11             	movsbl (%ecx),%edx
 25a:	8d 42 d0             	lea    -0x30(%edx),%eax
 25d:	3c 09                	cmp    $0x9,%al
  n = 0;
 25f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 264:	77 1f                	ja     285 <atoi+0x35>
 266:	8d 76 00             	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 270:	8d 04 80             	lea    (%eax,%eax,4),%eax
 273:	83 c1 01             	add    $0x1,%ecx
 276:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 27a:	0f be 11             	movsbl (%ecx),%edx
 27d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 280:	80 fb 09             	cmp    $0x9,%bl
 283:	76 eb                	jbe    270 <atoi+0x20>
  return n;
}
 285:	5b                   	pop    %ebx
 286:	5d                   	pop    %ebp
 287:	c3                   	ret    
 288:	90                   	nop
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	56                   	push   %esi
 294:	53                   	push   %ebx
 295:	8b 5d 10             	mov    0x10(%ebp),%ebx
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 db                	test   %ebx,%ebx
 2a0:	7e 14                	jle    2b6 <memmove+0x26>
 2a2:	31 d2                	xor    %edx,%edx
 2a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2a8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2af:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2b2:	39 d3                	cmp    %edx,%ebx
 2b4:	75 f2                	jne    2a8 <memmove+0x18>
  return vdst;
}
 2b6:	5b                   	pop    %ebx
 2b7:	5e                   	pop    %esi
 2b8:	5d                   	pop    %ebp
 2b9:	c3                   	ret    

000002ba <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ba:	b8 01 00 00 00       	mov    $0x1,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <exit>:
SYSCALL(exit)
 2c2:	b8 02 00 00 00       	mov    $0x2,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <wait>:
SYSCALL(wait)
 2ca:	b8 03 00 00 00       	mov    $0x3,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <pipe>:
SYSCALL(pipe)
 2d2:	b8 04 00 00 00       	mov    $0x4,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <read>:
SYSCALL(read)
 2da:	b8 05 00 00 00       	mov    $0x5,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <write>:
SYSCALL(write)
 2e2:	b8 10 00 00 00       	mov    $0x10,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <close>:
SYSCALL(close)
 2ea:	b8 15 00 00 00       	mov    $0x15,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <kill>:
SYSCALL(kill)
 2f2:	b8 06 00 00 00       	mov    $0x6,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <exec>:
SYSCALL(exec)
 2fa:	b8 07 00 00 00       	mov    $0x7,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <open>:
SYSCALL(open)
 302:	b8 0f 00 00 00       	mov    $0xf,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <mknod>:
SYSCALL(mknod)
 30a:	b8 11 00 00 00       	mov    $0x11,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <unlink>:
SYSCALL(unlink)
 312:	b8 12 00 00 00       	mov    $0x12,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <fstat>:
SYSCALL(fstat)
 31a:	b8 08 00 00 00       	mov    $0x8,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <link>:
SYSCALL(link)
 322:	b8 13 00 00 00       	mov    $0x13,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <mkdir>:
SYSCALL(mkdir)
 32a:	b8 14 00 00 00       	mov    $0x14,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <chdir>:
SYSCALL(chdir)
 332:	b8 09 00 00 00       	mov    $0x9,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <dup>:
SYSCALL(dup)
 33a:	b8 0a 00 00 00       	mov    $0xa,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <getpid>:
SYSCALL(getpid)
 342:	b8 0b 00 00 00       	mov    $0xb,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <sbrk>:
SYSCALL(sbrk)
 34a:	b8 0c 00 00 00       	mov    $0xc,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <sleep>:
SYSCALL(sleep)
 352:	b8 0d 00 00 00       	mov    $0xd,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <uptime>:
SYSCALL(uptime)
 35a:	b8 0e 00 00 00       	mov    $0xe,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <invoked_syscalls>:
SYSCALL(invoked_syscalls)
 362:	b8 16 00 00 00       	mov    $0x16,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <log_syscalls>:
SYSCALL(log_syscalls)
 36a:	b8 17 00 00 00       	mov    $0x17,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    
 372:	66 90                	xchg   %ax,%ax
 374:	66 90                	xchg   %ax,%ax
 376:	66 90                	xchg   %ax,%ax
 378:	66 90                	xchg   %ax,%ax
 37a:	66 90                	xchg   %ax,%ax
 37c:	66 90                	xchg   %ax,%ax
 37e:	66 90                	xchg   %ax,%ax

00000380 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
 386:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 389:	85 d2                	test   %edx,%edx
{
 38b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 38e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 390:	79 76                	jns    408 <printint+0x88>
 392:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 396:	74 70                	je     408 <printint+0x88>
    x = -xx;
 398:	f7 d8                	neg    %eax
    neg = 1;
 39a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3a1:	31 f6                	xor    %esi,%esi
 3a3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3a6:	eb 0a                	jmp    3b2 <printint+0x32>
 3a8:	90                   	nop
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 3b0:	89 fe                	mov    %edi,%esi
 3b2:	31 d2                	xor    %edx,%edx
 3b4:	8d 7e 01             	lea    0x1(%esi),%edi
 3b7:	f7 f1                	div    %ecx
 3b9:	0f b6 92 88 07 00 00 	movzbl 0x788(%edx),%edx
  }while((x /= base) != 0);
 3c0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 3c2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 3c5:	75 e9                	jne    3b0 <printint+0x30>
  if(neg)
 3c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3ca:	85 c0                	test   %eax,%eax
 3cc:	74 08                	je     3d6 <printint+0x56>
    buf[i++] = '-';
 3ce:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 3d3:	8d 7e 02             	lea    0x2(%esi),%edi
 3d6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 3da:	8b 7d c0             	mov    -0x40(%ebp),%edi
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
 3e0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 3e3:	83 ec 04             	sub    $0x4,%esp
 3e6:	83 ee 01             	sub    $0x1,%esi
 3e9:	6a 01                	push   $0x1
 3eb:	53                   	push   %ebx
 3ec:	57                   	push   %edi
 3ed:	88 45 d7             	mov    %al,-0x29(%ebp)
 3f0:	e8 ed fe ff ff       	call   2e2 <write>

  while(--i >= 0)
 3f5:	83 c4 10             	add    $0x10,%esp
 3f8:	39 de                	cmp    %ebx,%esi
 3fa:	75 e4                	jne    3e0 <printint+0x60>
    putc(fd, buf[i]);
}
 3fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ff:	5b                   	pop    %ebx
 400:	5e                   	pop    %esi
 401:	5f                   	pop    %edi
 402:	5d                   	pop    %ebp
 403:	c3                   	ret    
 404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 408:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 40f:	eb 90                	jmp    3a1 <printint+0x21>
 411:	eb 0d                	jmp    420 <printf>
 413:	90                   	nop
 414:	90                   	nop
 415:	90                   	nop
 416:	90                   	nop
 417:	90                   	nop
 418:	90                   	nop
 419:	90                   	nop
 41a:	90                   	nop
 41b:	90                   	nop
 41c:	90                   	nop
 41d:	90                   	nop
 41e:	90                   	nop
 41f:	90                   	nop

00000420 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
 426:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 429:	8b 75 0c             	mov    0xc(%ebp),%esi
 42c:	0f b6 1e             	movzbl (%esi),%ebx
 42f:	84 db                	test   %bl,%bl
 431:	0f 84 b3 00 00 00    	je     4ea <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 437:	8d 45 10             	lea    0x10(%ebp),%eax
 43a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 43d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 43f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 442:	eb 2f                	jmp    473 <printf+0x53>
 444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 448:	83 f8 25             	cmp    $0x25,%eax
 44b:	0f 84 a7 00 00 00    	je     4f8 <printf+0xd8>
  write(fd, &c, 1);
 451:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 454:	83 ec 04             	sub    $0x4,%esp
 457:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 45a:	6a 01                	push   $0x1
 45c:	50                   	push   %eax
 45d:	ff 75 08             	pushl  0x8(%ebp)
 460:	e8 7d fe ff ff       	call   2e2 <write>
 465:	83 c4 10             	add    $0x10,%esp
 468:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 46b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 46f:	84 db                	test   %bl,%bl
 471:	74 77                	je     4ea <printf+0xca>
    if(state == 0){
 473:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 475:	0f be cb             	movsbl %bl,%ecx
 478:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 47b:	74 cb                	je     448 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 47d:	83 ff 25             	cmp    $0x25,%edi
 480:	75 e6                	jne    468 <printf+0x48>
      if(c == 'd'){
 482:	83 f8 64             	cmp    $0x64,%eax
 485:	0f 84 05 01 00 00    	je     590 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 48b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 491:	83 f9 70             	cmp    $0x70,%ecx
 494:	74 72                	je     508 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 496:	83 f8 73             	cmp    $0x73,%eax
 499:	0f 84 99 00 00 00    	je     538 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 49f:	83 f8 63             	cmp    $0x63,%eax
 4a2:	0f 84 08 01 00 00    	je     5b0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4a8:	83 f8 25             	cmp    $0x25,%eax
 4ab:	0f 84 ef 00 00 00    	je     5a0 <printf+0x180>
  write(fd, &c, 1);
 4b1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4b4:	83 ec 04             	sub    $0x4,%esp
 4b7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4bb:	6a 01                	push   $0x1
 4bd:	50                   	push   %eax
 4be:	ff 75 08             	pushl  0x8(%ebp)
 4c1:	e8 1c fe ff ff       	call   2e2 <write>
 4c6:	83 c4 0c             	add    $0xc,%esp
 4c9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4cc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4cf:	6a 01                	push   $0x1
 4d1:	50                   	push   %eax
 4d2:	ff 75 08             	pushl  0x8(%ebp)
 4d5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4d8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 4da:	e8 03 fe ff ff       	call   2e2 <write>
  for(i = 0; fmt[i]; i++){
 4df:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 4e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4e6:	84 db                	test   %bl,%bl
 4e8:	75 89                	jne    473 <printf+0x53>
    }
  }
}
 4ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ed:	5b                   	pop    %ebx
 4ee:	5e                   	pop    %esi
 4ef:	5f                   	pop    %edi
 4f0:	5d                   	pop    %ebp
 4f1:	c3                   	ret    
 4f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 4f8:	bf 25 00 00 00       	mov    $0x25,%edi
 4fd:	e9 66 ff ff ff       	jmp    468 <printf+0x48>
 502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 508:	83 ec 0c             	sub    $0xc,%esp
 50b:	b9 10 00 00 00       	mov    $0x10,%ecx
 510:	6a 00                	push   $0x0
 512:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 515:	8b 45 08             	mov    0x8(%ebp),%eax
 518:	8b 17                	mov    (%edi),%edx
 51a:	e8 61 fe ff ff       	call   380 <printint>
        ap++;
 51f:	89 f8                	mov    %edi,%eax
 521:	83 c4 10             	add    $0x10,%esp
      state = 0;
 524:	31 ff                	xor    %edi,%edi
        ap++;
 526:	83 c0 04             	add    $0x4,%eax
 529:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 52c:	e9 37 ff ff ff       	jmp    468 <printf+0x48>
 531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 538:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 53b:	8b 08                	mov    (%eax),%ecx
        ap++;
 53d:	83 c0 04             	add    $0x4,%eax
 540:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 543:	85 c9                	test   %ecx,%ecx
 545:	0f 84 8e 00 00 00    	je     5d9 <printf+0x1b9>
        while(*s != 0){
 54b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 54e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 550:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 552:	84 c0                	test   %al,%al
 554:	0f 84 0e ff ff ff    	je     468 <printf+0x48>
 55a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 55d:	89 de                	mov    %ebx,%esi
 55f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 562:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 565:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 568:	83 ec 04             	sub    $0x4,%esp
          s++;
 56b:	83 c6 01             	add    $0x1,%esi
 56e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 571:	6a 01                	push   $0x1
 573:	57                   	push   %edi
 574:	53                   	push   %ebx
 575:	e8 68 fd ff ff       	call   2e2 <write>
        while(*s != 0){
 57a:	0f b6 06             	movzbl (%esi),%eax
 57d:	83 c4 10             	add    $0x10,%esp
 580:	84 c0                	test   %al,%al
 582:	75 e4                	jne    568 <printf+0x148>
 584:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 587:	31 ff                	xor    %edi,%edi
 589:	e9 da fe ff ff       	jmp    468 <printf+0x48>
 58e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 590:	83 ec 0c             	sub    $0xc,%esp
 593:	b9 0a 00 00 00       	mov    $0xa,%ecx
 598:	6a 01                	push   $0x1
 59a:	e9 73 ff ff ff       	jmp    512 <printf+0xf2>
 59f:	90                   	nop
  write(fd, &c, 1);
 5a0:	83 ec 04             	sub    $0x4,%esp
 5a3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 5a6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5a9:	6a 01                	push   $0x1
 5ab:	e9 21 ff ff ff       	jmp    4d1 <printf+0xb1>
        putc(fd, *ap);
 5b0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 5b3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5b6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 5b8:	6a 01                	push   $0x1
        ap++;
 5ba:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 5bd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5c0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 5c3:	50                   	push   %eax
 5c4:	ff 75 08             	pushl  0x8(%ebp)
 5c7:	e8 16 fd ff ff       	call   2e2 <write>
        ap++;
 5cc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5cf:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5d2:	31 ff                	xor    %edi,%edi
 5d4:	e9 8f fe ff ff       	jmp    468 <printf+0x48>
          s = "(null)";
 5d9:	bb 81 07 00 00       	mov    $0x781,%ebx
        while(*s != 0){
 5de:	b8 28 00 00 00       	mov    $0x28,%eax
 5e3:	e9 72 ff ff ff       	jmp    55a <printf+0x13a>
 5e8:	66 90                	xchg   %ax,%ax
 5ea:	66 90                	xchg   %ax,%ax
 5ec:	66 90                	xchg   %ax,%ax
 5ee:	66 90                	xchg   %ax,%ax

000005f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f1:	a1 34 0a 00 00       	mov    0xa34,%eax
{
 5f6:	89 e5                	mov    %esp,%ebp
 5f8:	57                   	push   %edi
 5f9:	56                   	push   %esi
 5fa:	53                   	push   %ebx
 5fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5fe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 608:	39 c8                	cmp    %ecx,%eax
 60a:	8b 10                	mov    (%eax),%edx
 60c:	73 32                	jae    640 <free+0x50>
 60e:	39 d1                	cmp    %edx,%ecx
 610:	72 04                	jb     616 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 612:	39 d0                	cmp    %edx,%eax
 614:	72 32                	jb     648 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 616:	8b 73 fc             	mov    -0x4(%ebx),%esi
 619:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 61c:	39 fa                	cmp    %edi,%edx
 61e:	74 30                	je     650 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 620:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 623:	8b 50 04             	mov    0x4(%eax),%edx
 626:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 629:	39 f1                	cmp    %esi,%ecx
 62b:	74 3a                	je     667 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 62d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 62f:	a3 34 0a 00 00       	mov    %eax,0xa34
}
 634:	5b                   	pop    %ebx
 635:	5e                   	pop    %esi
 636:	5f                   	pop    %edi
 637:	5d                   	pop    %ebp
 638:	c3                   	ret    
 639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 640:	39 d0                	cmp    %edx,%eax
 642:	72 04                	jb     648 <free+0x58>
 644:	39 d1                	cmp    %edx,%ecx
 646:	72 ce                	jb     616 <free+0x26>
{
 648:	89 d0                	mov    %edx,%eax
 64a:	eb bc                	jmp    608 <free+0x18>
 64c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 650:	03 72 04             	add    0x4(%edx),%esi
 653:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 656:	8b 10                	mov    (%eax),%edx
 658:	8b 12                	mov    (%edx),%edx
 65a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 65d:	8b 50 04             	mov    0x4(%eax),%edx
 660:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 663:	39 f1                	cmp    %esi,%ecx
 665:	75 c6                	jne    62d <free+0x3d>
    p->s.size += bp->s.size;
 667:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 66a:	a3 34 0a 00 00       	mov    %eax,0xa34
    p->s.size += bp->s.size;
 66f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 672:	8b 53 f8             	mov    -0x8(%ebx),%edx
 675:	89 10                	mov    %edx,(%eax)
}
 677:	5b                   	pop    %ebx
 678:	5e                   	pop    %esi
 679:	5f                   	pop    %edi
 67a:	5d                   	pop    %ebp
 67b:	c3                   	ret    
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000680 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	57                   	push   %edi
 684:	56                   	push   %esi
 685:	53                   	push   %ebx
 686:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 689:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 68c:	8b 15 34 0a 00 00    	mov    0xa34,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 692:	8d 78 07             	lea    0x7(%eax),%edi
 695:	c1 ef 03             	shr    $0x3,%edi
 698:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 69b:	85 d2                	test   %edx,%edx
 69d:	0f 84 9d 00 00 00    	je     740 <malloc+0xc0>
 6a3:	8b 02                	mov    (%edx),%eax
 6a5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6a8:	39 cf                	cmp    %ecx,%edi
 6aa:	76 6c                	jbe    718 <malloc+0x98>
 6ac:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 6b2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6b7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 6ba:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 6c1:	eb 0e                	jmp    6d1 <malloc+0x51>
 6c3:	90                   	nop
 6c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6ca:	8b 48 04             	mov    0x4(%eax),%ecx
 6cd:	39 f9                	cmp    %edi,%ecx
 6cf:	73 47                	jae    718 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6d1:	39 05 34 0a 00 00    	cmp    %eax,0xa34
 6d7:	89 c2                	mov    %eax,%edx
 6d9:	75 ed                	jne    6c8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 6db:	83 ec 0c             	sub    $0xc,%esp
 6de:	56                   	push   %esi
 6df:	e8 66 fc ff ff       	call   34a <sbrk>
  if(p == (char*)-1)
 6e4:	83 c4 10             	add    $0x10,%esp
 6e7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ea:	74 1c                	je     708 <malloc+0x88>
  hp->s.size = nu;
 6ec:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6ef:	83 ec 0c             	sub    $0xc,%esp
 6f2:	83 c0 08             	add    $0x8,%eax
 6f5:	50                   	push   %eax
 6f6:	e8 f5 fe ff ff       	call   5f0 <free>
  return freep;
 6fb:	8b 15 34 0a 00 00    	mov    0xa34,%edx
      if((p = morecore(nunits)) == 0)
 701:	83 c4 10             	add    $0x10,%esp
 704:	85 d2                	test   %edx,%edx
 706:	75 c0                	jne    6c8 <malloc+0x48>
        return 0;
  }
}
 708:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 70b:	31 c0                	xor    %eax,%eax
}
 70d:	5b                   	pop    %ebx
 70e:	5e                   	pop    %esi
 70f:	5f                   	pop    %edi
 710:	5d                   	pop    %ebp
 711:	c3                   	ret    
 712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 718:	39 cf                	cmp    %ecx,%edi
 71a:	74 54                	je     770 <malloc+0xf0>
        p->s.size -= nunits;
 71c:	29 f9                	sub    %edi,%ecx
 71e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 721:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 724:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 727:	89 15 34 0a 00 00    	mov    %edx,0xa34
}
 72d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 730:	83 c0 08             	add    $0x8,%eax
}
 733:	5b                   	pop    %ebx
 734:	5e                   	pop    %esi
 735:	5f                   	pop    %edi
 736:	5d                   	pop    %ebp
 737:	c3                   	ret    
 738:	90                   	nop
 739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 740:	c7 05 34 0a 00 00 38 	movl   $0xa38,0xa34
 747:	0a 00 00 
 74a:	c7 05 38 0a 00 00 38 	movl   $0xa38,0xa38
 751:	0a 00 00 
    base.s.size = 0;
 754:	b8 38 0a 00 00       	mov    $0xa38,%eax
 759:	c7 05 3c 0a 00 00 00 	movl   $0x0,0xa3c
 760:	00 00 00 
 763:	e9 44 ff ff ff       	jmp    6ac <malloc+0x2c>
 768:	90                   	nop
 769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 770:	8b 08                	mov    (%eax),%ecx
 772:	89 0a                	mov    %ecx,(%edx)
 774:	eb b1                	jmp    727 <malloc+0xa7>
