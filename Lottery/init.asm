
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 f8 07 00 00       	push   $0x7f8
  19:	e8 64 03 00 00       	call   382 <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	0f 88 9f 00 00 00    	js     c8 <main+0xc8>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	6a 00                	push   $0x0
  2e:	e8 87 03 00 00       	call   3ba <dup>
  dup(0);  // stderr
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 7b 03 00 00       	call   3ba <dup>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(;;){
    printf(1, "init: starting sh\n");
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	68 00 08 00 00       	push   $0x800
  50:	6a 01                	push   $0x1
  52:	e8 49 04 00 00       	call   4a0 <printf>
    pid = fork();
  57:	e8 de 02 00 00       	call   33a <fork>
    if(pid < 0){
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	85 c0                	test   %eax,%eax
    pid = fork();
  61:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  63:	78 2c                	js     91 <main+0x91>
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
  65:	74 3d                	je     a4 <main+0xa4>
  67:	89 f6                	mov    %esi,%esi
  69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  70:	e8 d5 02 00 00       	call   34a <wait>
  75:	85 c0                	test   %eax,%eax
  77:	78 cf                	js     48 <main+0x48>
  79:	39 c3                	cmp    %eax,%ebx
  7b:	74 cb                	je     48 <main+0x48>
      printf(1, "zombie!\n");
  7d:	83 ec 08             	sub    $0x8,%esp
  80:	68 3f 08 00 00       	push   $0x83f
  85:	6a 01                	push   $0x1
  87:	e8 14 04 00 00       	call   4a0 <printf>
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	eb df                	jmp    70 <main+0x70>
      printf(1, "init: fork failed\n");
  91:	53                   	push   %ebx
  92:	53                   	push   %ebx
  93:	68 13 08 00 00       	push   $0x813
  98:	6a 01                	push   $0x1
  9a:	e8 01 04 00 00       	call   4a0 <printf>
      exit();
  9f:	e8 9e 02 00 00       	call   342 <exit>
      exec("sh", argv);
  a4:	50                   	push   %eax
  a5:	50                   	push   %eax
  a6:	68 f8 0a 00 00       	push   $0xaf8
  ab:	68 26 08 00 00       	push   $0x826
  b0:	e8 c5 02 00 00       	call   37a <exec>
      printf(1, "init: exec sh failed\n");
  b5:	5a                   	pop    %edx
  b6:	59                   	pop    %ecx
  b7:	68 29 08 00 00       	push   $0x829
  bc:	6a 01                	push   $0x1
  be:	e8 dd 03 00 00       	call   4a0 <printf>
      exit();
  c3:	e8 7a 02 00 00       	call   342 <exit>
    mknod("console", 1, 1);
  c8:	50                   	push   %eax
  c9:	6a 01                	push   $0x1
  cb:	6a 01                	push   $0x1
  cd:	68 f8 07 00 00       	push   $0x7f8
  d2:	e8 b3 02 00 00       	call   38a <mknod>
    open("console", O_RDWR);
  d7:	58                   	pop    %eax
  d8:	5a                   	pop    %edx
  d9:	6a 02                	push   $0x2
  db:	68 f8 07 00 00       	push   $0x7f8
  e0:	e8 9d 02 00 00       	call   382 <open>
  e5:	83 c4 10             	add    $0x10,%esp
  e8:	e9 3c ff ff ff       	jmp    29 <main+0x29>
  ed:	66 90                	xchg   %ax,%ax
  ef:	90                   	nop

000000f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	53                   	push   %ebx
  f4:	8b 45 08             	mov    0x8(%ebp),%eax
  f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fa:	89 c2                	mov    %eax,%edx
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 100:	83 c1 01             	add    $0x1,%ecx
 103:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 107:	83 c2 01             	add    $0x1,%edx
 10a:	84 db                	test   %bl,%bl
 10c:	88 5a ff             	mov    %bl,-0x1(%edx)
 10f:	75 ef                	jne    100 <strcpy+0x10>
    ;
  return os;
}
 111:	5b                   	pop    %ebx
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    
 114:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 11a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000120 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	53                   	push   %ebx
 124:	8b 55 08             	mov    0x8(%ebp),%edx
 127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 12a:	0f b6 02             	movzbl (%edx),%eax
 12d:	0f b6 19             	movzbl (%ecx),%ebx
 130:	84 c0                	test   %al,%al
 132:	75 1c                	jne    150 <strcmp+0x30>
 134:	eb 2a                	jmp    160 <strcmp+0x40>
 136:	8d 76 00             	lea    0x0(%esi),%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 140:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 143:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 146:	83 c1 01             	add    $0x1,%ecx
 149:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 14c:	84 c0                	test   %al,%al
 14e:	74 10                	je     160 <strcmp+0x40>
 150:	38 d8                	cmp    %bl,%al
 152:	74 ec                	je     140 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 154:	29 d8                	sub    %ebx,%eax
}
 156:	5b                   	pop    %ebx
 157:	5d                   	pop    %ebp
 158:	c3                   	ret    
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 160:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 162:	29 d8                	sub    %ebx,%eax
}
 164:	5b                   	pop    %ebx
 165:	5d                   	pop    %ebp
 166:	c3                   	ret    
 167:	89 f6                	mov    %esi,%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000170 <strlen>:

uint
strlen(const char *s)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 176:	80 39 00             	cmpb   $0x0,(%ecx)
 179:	74 15                	je     190 <strlen+0x20>
 17b:	31 d2                	xor    %edx,%edx
 17d:	8d 76 00             	lea    0x0(%esi),%esi
 180:	83 c2 01             	add    $0x1,%edx
 183:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 187:	89 d0                	mov    %edx,%eax
 189:	75 f5                	jne    180 <strlen+0x10>
    ;
  return n;
}
 18b:	5d                   	pop    %ebp
 18c:	c3                   	ret    
 18d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 190:	31 c0                	xor    %eax,%eax
}
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    
 194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 19a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	57                   	push   %edi
 1a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ad:	89 d7                	mov    %edx,%edi
 1af:	fc                   	cld    
 1b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1b2:	89 d0                	mov    %edx,%eax
 1b4:	5f                   	pop    %edi
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
 1b7:	89 f6                	mov    %esi,%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <strchr>:

char*
strchr(const char *s, char c)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	53                   	push   %ebx
 1c4:	8b 45 08             	mov    0x8(%ebp),%eax
 1c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1ca:	0f b6 10             	movzbl (%eax),%edx
 1cd:	84 d2                	test   %dl,%dl
 1cf:	74 1d                	je     1ee <strchr+0x2e>
    if(*s == c)
 1d1:	38 d3                	cmp    %dl,%bl
 1d3:	89 d9                	mov    %ebx,%ecx
 1d5:	75 0d                	jne    1e4 <strchr+0x24>
 1d7:	eb 17                	jmp    1f0 <strchr+0x30>
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1e0:	38 ca                	cmp    %cl,%dl
 1e2:	74 0c                	je     1f0 <strchr+0x30>
  for(; *s; s++)
 1e4:	83 c0 01             	add    $0x1,%eax
 1e7:	0f b6 10             	movzbl (%eax),%edx
 1ea:	84 d2                	test   %dl,%dl
 1ec:	75 f2                	jne    1e0 <strchr+0x20>
      return (char*)s;
  return 0;
 1ee:	31 c0                	xor    %eax,%eax
}
 1f0:	5b                   	pop    %ebx
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    
 1f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000200 <gets>:

char*
gets(char *buf, int max)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	57                   	push   %edi
 204:	56                   	push   %esi
 205:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 206:	31 f6                	xor    %esi,%esi
 208:	89 f3                	mov    %esi,%ebx
{
 20a:	83 ec 1c             	sub    $0x1c,%esp
 20d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 210:	eb 2f                	jmp    241 <gets+0x41>
 212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 218:	8d 45 e7             	lea    -0x19(%ebp),%eax
 21b:	83 ec 04             	sub    $0x4,%esp
 21e:	6a 01                	push   $0x1
 220:	50                   	push   %eax
 221:	6a 00                	push   $0x0
 223:	e8 32 01 00 00       	call   35a <read>
    if(cc < 1)
 228:	83 c4 10             	add    $0x10,%esp
 22b:	85 c0                	test   %eax,%eax
 22d:	7e 1c                	jle    24b <gets+0x4b>
      break;
    buf[i++] = c;
 22f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 233:	83 c7 01             	add    $0x1,%edi
 236:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 239:	3c 0a                	cmp    $0xa,%al
 23b:	74 23                	je     260 <gets+0x60>
 23d:	3c 0d                	cmp    $0xd,%al
 23f:	74 1f                	je     260 <gets+0x60>
  for(i=0; i+1 < max; ){
 241:	83 c3 01             	add    $0x1,%ebx
 244:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 247:	89 fe                	mov    %edi,%esi
 249:	7c cd                	jl     218 <gets+0x18>
 24b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 250:	c6 03 00             	movb   $0x0,(%ebx)
}
 253:	8d 65 f4             	lea    -0xc(%ebp),%esp
 256:	5b                   	pop    %ebx
 257:	5e                   	pop    %esi
 258:	5f                   	pop    %edi
 259:	5d                   	pop    %ebp
 25a:	c3                   	ret    
 25b:	90                   	nop
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 260:	8b 75 08             	mov    0x8(%ebp),%esi
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	01 de                	add    %ebx,%esi
 268:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 26a:	c6 03 00             	movb   $0x0,(%ebx)
}
 26d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 270:	5b                   	pop    %ebx
 271:	5e                   	pop    %esi
 272:	5f                   	pop    %edi
 273:	5d                   	pop    %ebp
 274:	c3                   	ret    
 275:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000280 <stat>:

int
stat(const char *n, struct stat *st)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 285:	83 ec 08             	sub    $0x8,%esp
 288:	6a 00                	push   $0x0
 28a:	ff 75 08             	pushl  0x8(%ebp)
 28d:	e8 f0 00 00 00       	call   382 <open>
  if(fd < 0)
 292:	83 c4 10             	add    $0x10,%esp
 295:	85 c0                	test   %eax,%eax
 297:	78 27                	js     2c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 299:	83 ec 08             	sub    $0x8,%esp
 29c:	ff 75 0c             	pushl  0xc(%ebp)
 29f:	89 c3                	mov    %eax,%ebx
 2a1:	50                   	push   %eax
 2a2:	e8 f3 00 00 00       	call   39a <fstat>
  close(fd);
 2a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 2aa:	89 c6                	mov    %eax,%esi
  close(fd);
 2ac:	e8 b9 00 00 00       	call   36a <close>
  return r;
 2b1:	83 c4 10             	add    $0x10,%esp
}
 2b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b7:	89 f0                	mov    %esi,%eax
 2b9:	5b                   	pop    %ebx
 2ba:	5e                   	pop    %esi
 2bb:	5d                   	pop    %ebp
 2bc:	c3                   	ret    
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2c5:	eb ed                	jmp    2b4 <stat+0x34>
 2c7:	89 f6                	mov    %esi,%esi
 2c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d7:	0f be 11             	movsbl (%ecx),%edx
 2da:	8d 42 d0             	lea    -0x30(%edx),%eax
 2dd:	3c 09                	cmp    $0x9,%al
  n = 0;
 2df:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2e4:	77 1f                	ja     305 <atoi+0x35>
 2e6:	8d 76 00             	lea    0x0(%esi),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 2f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2f3:	83 c1 01             	add    $0x1,%ecx
 2f6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2fa:	0f be 11             	movsbl (%ecx),%edx
 2fd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 300:	80 fb 09             	cmp    $0x9,%bl
 303:	76 eb                	jbe    2f0 <atoi+0x20>
  return n;
}
 305:	5b                   	pop    %ebx
 306:	5d                   	pop    %ebp
 307:	c3                   	ret    
 308:	90                   	nop
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000310 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	56                   	push   %esi
 314:	53                   	push   %ebx
 315:	8b 5d 10             	mov    0x10(%ebp),%ebx
 318:	8b 45 08             	mov    0x8(%ebp),%eax
 31b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 31e:	85 db                	test   %ebx,%ebx
 320:	7e 14                	jle    336 <memmove+0x26>
 322:	31 d2                	xor    %edx,%edx
 324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 328:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 32c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 32f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 332:	39 d3                	cmp    %edx,%ebx
 334:	75 f2                	jne    328 <memmove+0x18>
  return vdst;
}
 336:	5b                   	pop    %ebx
 337:	5e                   	pop    %esi
 338:	5d                   	pop    %ebp
 339:	c3                   	ret    

0000033a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33a:	b8 01 00 00 00       	mov    $0x1,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <exit>:
SYSCALL(exit)
 342:	b8 02 00 00 00       	mov    $0x2,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <wait>:
SYSCALL(wait)
 34a:	b8 03 00 00 00       	mov    $0x3,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <pipe>:
SYSCALL(pipe)
 352:	b8 04 00 00 00       	mov    $0x4,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <read>:
SYSCALL(read)
 35a:	b8 05 00 00 00       	mov    $0x5,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <write>:
SYSCALL(write)
 362:	b8 10 00 00 00       	mov    $0x10,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <close>:
SYSCALL(close)
 36a:	b8 15 00 00 00       	mov    $0x15,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <kill>:
SYSCALL(kill)
 372:	b8 06 00 00 00       	mov    $0x6,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <exec>:
SYSCALL(exec)
 37a:	b8 07 00 00 00       	mov    $0x7,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <open>:
SYSCALL(open)
 382:	b8 0f 00 00 00       	mov    $0xf,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <mknod>:
SYSCALL(mknod)
 38a:	b8 11 00 00 00       	mov    $0x11,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <unlink>:
SYSCALL(unlink)
 392:	b8 12 00 00 00       	mov    $0x12,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <fstat>:
SYSCALL(fstat)
 39a:	b8 08 00 00 00       	mov    $0x8,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <link>:
SYSCALL(link)
 3a2:	b8 13 00 00 00       	mov    $0x13,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <mkdir>:
SYSCALL(mkdir)
 3aa:	b8 14 00 00 00       	mov    $0x14,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <chdir>:
SYSCALL(chdir)
 3b2:	b8 09 00 00 00       	mov    $0x9,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <dup>:
SYSCALL(dup)
 3ba:	b8 0a 00 00 00       	mov    $0xa,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <getpid>:
SYSCALL(getpid)
 3c2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <sbrk>:
SYSCALL(sbrk)
 3ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <sleep>:
SYSCALL(sleep)
 3d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <uptime>:
SYSCALL(uptime)
 3da:	b8 0e 00 00 00       	mov    $0xe,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <invoked_syscalls>:
SYSCALL(invoked_syscalls)
 3e2:	b8 16 00 00 00       	mov    $0x16,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <log_syscalls>:
SYSCALL(log_syscalls)
 3ea:	b8 17 00 00 00       	mov    $0x17,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    
 3f2:	66 90                	xchg   %ax,%ax
 3f4:	66 90                	xchg   %ax,%ax
 3f6:	66 90                	xchg   %ax,%ax
 3f8:	66 90                	xchg   %ax,%ax
 3fa:	66 90                	xchg   %ax,%ax
 3fc:	66 90                	xchg   %ax,%ax
 3fe:	66 90                	xchg   %ax,%ax

00000400 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 409:	85 d2                	test   %edx,%edx
{
 40b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 40e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 410:	79 76                	jns    488 <printint+0x88>
 412:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 416:	74 70                	je     488 <printint+0x88>
    x = -xx;
 418:	f7 d8                	neg    %eax
    neg = 1;
 41a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 421:	31 f6                	xor    %esi,%esi
 423:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 426:	eb 0a                	jmp    432 <printint+0x32>
 428:	90                   	nop
 429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 430:	89 fe                	mov    %edi,%esi
 432:	31 d2                	xor    %edx,%edx
 434:	8d 7e 01             	lea    0x1(%esi),%edi
 437:	f7 f1                	div    %ecx
 439:	0f b6 92 50 08 00 00 	movzbl 0x850(%edx),%edx
  }while((x /= base) != 0);
 440:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 442:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 445:	75 e9                	jne    430 <printint+0x30>
  if(neg)
 447:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 44a:	85 c0                	test   %eax,%eax
 44c:	74 08                	je     456 <printint+0x56>
    buf[i++] = '-';
 44e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 453:	8d 7e 02             	lea    0x2(%esi),%edi
 456:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 45a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 45d:	8d 76 00             	lea    0x0(%esi),%esi
 460:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 463:	83 ec 04             	sub    $0x4,%esp
 466:	83 ee 01             	sub    $0x1,%esi
 469:	6a 01                	push   $0x1
 46b:	53                   	push   %ebx
 46c:	57                   	push   %edi
 46d:	88 45 d7             	mov    %al,-0x29(%ebp)
 470:	e8 ed fe ff ff       	call   362 <write>

  while(--i >= 0)
 475:	83 c4 10             	add    $0x10,%esp
 478:	39 de                	cmp    %ebx,%esi
 47a:	75 e4                	jne    460 <printint+0x60>
    putc(fd, buf[i]);
}
 47c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47f:	5b                   	pop    %ebx
 480:	5e                   	pop    %esi
 481:	5f                   	pop    %edi
 482:	5d                   	pop    %ebp
 483:	c3                   	ret    
 484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 488:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 48f:	eb 90                	jmp    421 <printint+0x21>
 491:	eb 0d                	jmp    4a0 <printf>
 493:	90                   	nop
 494:	90                   	nop
 495:	90                   	nop
 496:	90                   	nop
 497:	90                   	nop
 498:	90                   	nop
 499:	90                   	nop
 49a:	90                   	nop
 49b:	90                   	nop
 49c:	90                   	nop
 49d:	90                   	nop
 49e:	90                   	nop
 49f:	90                   	nop

000004a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a9:	8b 75 0c             	mov    0xc(%ebp),%esi
 4ac:	0f b6 1e             	movzbl (%esi),%ebx
 4af:	84 db                	test   %bl,%bl
 4b1:	0f 84 b3 00 00 00    	je     56a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 4b7:	8d 45 10             	lea    0x10(%ebp),%eax
 4ba:	83 c6 01             	add    $0x1,%esi
  state = 0;
 4bd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 4bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4c2:	eb 2f                	jmp    4f3 <printf+0x53>
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4c8:	83 f8 25             	cmp    $0x25,%eax
 4cb:	0f 84 a7 00 00 00    	je     578 <printf+0xd8>
  write(fd, &c, 1);
 4d1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4d4:	83 ec 04             	sub    $0x4,%esp
 4d7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 4da:	6a 01                	push   $0x1
 4dc:	50                   	push   %eax
 4dd:	ff 75 08             	pushl  0x8(%ebp)
 4e0:	e8 7d fe ff ff       	call   362 <write>
 4e5:	83 c4 10             	add    $0x10,%esp
 4e8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4eb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4ef:	84 db                	test   %bl,%bl
 4f1:	74 77                	je     56a <printf+0xca>
    if(state == 0){
 4f3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 4f5:	0f be cb             	movsbl %bl,%ecx
 4f8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4fb:	74 cb                	je     4c8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4fd:	83 ff 25             	cmp    $0x25,%edi
 500:	75 e6                	jne    4e8 <printf+0x48>
      if(c == 'd'){
 502:	83 f8 64             	cmp    $0x64,%eax
 505:	0f 84 05 01 00 00    	je     610 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 50b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 511:	83 f9 70             	cmp    $0x70,%ecx
 514:	74 72                	je     588 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 516:	83 f8 73             	cmp    $0x73,%eax
 519:	0f 84 99 00 00 00    	je     5b8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51f:	83 f8 63             	cmp    $0x63,%eax
 522:	0f 84 08 01 00 00    	je     630 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 528:	83 f8 25             	cmp    $0x25,%eax
 52b:	0f 84 ef 00 00 00    	je     620 <printf+0x180>
  write(fd, &c, 1);
 531:	8d 45 e7             	lea    -0x19(%ebp),%eax
 534:	83 ec 04             	sub    $0x4,%esp
 537:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 53b:	6a 01                	push   $0x1
 53d:	50                   	push   %eax
 53e:	ff 75 08             	pushl  0x8(%ebp)
 541:	e8 1c fe ff ff       	call   362 <write>
 546:	83 c4 0c             	add    $0xc,%esp
 549:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 54c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 54f:	6a 01                	push   $0x1
 551:	50                   	push   %eax
 552:	ff 75 08             	pushl  0x8(%ebp)
 555:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 558:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 55a:	e8 03 fe ff ff       	call   362 <write>
  for(i = 0; fmt[i]; i++){
 55f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 563:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 566:	84 db                	test   %bl,%bl
 568:	75 89                	jne    4f3 <printf+0x53>
    }
  }
}
 56a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 56d:	5b                   	pop    %ebx
 56e:	5e                   	pop    %esi
 56f:	5f                   	pop    %edi
 570:	5d                   	pop    %ebp
 571:	c3                   	ret    
 572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 578:	bf 25 00 00 00       	mov    $0x25,%edi
 57d:	e9 66 ff ff ff       	jmp    4e8 <printf+0x48>
 582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 588:	83 ec 0c             	sub    $0xc,%esp
 58b:	b9 10 00 00 00       	mov    $0x10,%ecx
 590:	6a 00                	push   $0x0
 592:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 595:	8b 45 08             	mov    0x8(%ebp),%eax
 598:	8b 17                	mov    (%edi),%edx
 59a:	e8 61 fe ff ff       	call   400 <printint>
        ap++;
 59f:	89 f8                	mov    %edi,%eax
 5a1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5a4:	31 ff                	xor    %edi,%edi
        ap++;
 5a6:	83 c0 04             	add    $0x4,%eax
 5a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5ac:	e9 37 ff ff ff       	jmp    4e8 <printf+0x48>
 5b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5bb:	8b 08                	mov    (%eax),%ecx
        ap++;
 5bd:	83 c0 04             	add    $0x4,%eax
 5c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 5c3:	85 c9                	test   %ecx,%ecx
 5c5:	0f 84 8e 00 00 00    	je     659 <printf+0x1b9>
        while(*s != 0){
 5cb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 5ce:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 5d0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 5d2:	84 c0                	test   %al,%al
 5d4:	0f 84 0e ff ff ff    	je     4e8 <printf+0x48>
 5da:	89 75 d0             	mov    %esi,-0x30(%ebp)
 5dd:	89 de                	mov    %ebx,%esi
 5df:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5e2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 5e5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5e8:	83 ec 04             	sub    $0x4,%esp
          s++;
 5eb:	83 c6 01             	add    $0x1,%esi
 5ee:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 5f1:	6a 01                	push   $0x1
 5f3:	57                   	push   %edi
 5f4:	53                   	push   %ebx
 5f5:	e8 68 fd ff ff       	call   362 <write>
        while(*s != 0){
 5fa:	0f b6 06             	movzbl (%esi),%eax
 5fd:	83 c4 10             	add    $0x10,%esp
 600:	84 c0                	test   %al,%al
 602:	75 e4                	jne    5e8 <printf+0x148>
 604:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 607:	31 ff                	xor    %edi,%edi
 609:	e9 da fe ff ff       	jmp    4e8 <printf+0x48>
 60e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 610:	83 ec 0c             	sub    $0xc,%esp
 613:	b9 0a 00 00 00       	mov    $0xa,%ecx
 618:	6a 01                	push   $0x1
 61a:	e9 73 ff ff ff       	jmp    592 <printf+0xf2>
 61f:	90                   	nop
  write(fd, &c, 1);
 620:	83 ec 04             	sub    $0x4,%esp
 623:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 626:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 629:	6a 01                	push   $0x1
 62b:	e9 21 ff ff ff       	jmp    551 <printf+0xb1>
        putc(fd, *ap);
 630:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 633:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 636:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 638:	6a 01                	push   $0x1
        ap++;
 63a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 63d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 640:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 643:	50                   	push   %eax
 644:	ff 75 08             	pushl  0x8(%ebp)
 647:	e8 16 fd ff ff       	call   362 <write>
        ap++;
 64c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 64f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 652:	31 ff                	xor    %edi,%edi
 654:	e9 8f fe ff ff       	jmp    4e8 <printf+0x48>
          s = "(null)";
 659:	bb 48 08 00 00       	mov    $0x848,%ebx
        while(*s != 0){
 65e:	b8 28 00 00 00       	mov    $0x28,%eax
 663:	e9 72 ff ff ff       	jmp    5da <printf+0x13a>
 668:	66 90                	xchg   %ax,%ax
 66a:	66 90                	xchg   %ax,%ax
 66c:	66 90                	xchg   %ax,%ax
 66e:	66 90                	xchg   %ax,%ax

00000670 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 670:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 671:	a1 00 0b 00 00       	mov    0xb00,%eax
{
 676:	89 e5                	mov    %esp,%ebp
 678:	57                   	push   %edi
 679:	56                   	push   %esi
 67a:	53                   	push   %ebx
 67b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 67e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 688:	39 c8                	cmp    %ecx,%eax
 68a:	8b 10                	mov    (%eax),%edx
 68c:	73 32                	jae    6c0 <free+0x50>
 68e:	39 d1                	cmp    %edx,%ecx
 690:	72 04                	jb     696 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 692:	39 d0                	cmp    %edx,%eax
 694:	72 32                	jb     6c8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 696:	8b 73 fc             	mov    -0x4(%ebx),%esi
 699:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 69c:	39 fa                	cmp    %edi,%edx
 69e:	74 30                	je     6d0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6a0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6a3:	8b 50 04             	mov    0x4(%eax),%edx
 6a6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6a9:	39 f1                	cmp    %esi,%ecx
 6ab:	74 3a                	je     6e7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6ad:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6af:	a3 00 0b 00 00       	mov    %eax,0xb00
}
 6b4:	5b                   	pop    %ebx
 6b5:	5e                   	pop    %esi
 6b6:	5f                   	pop    %edi
 6b7:	5d                   	pop    %ebp
 6b8:	c3                   	ret    
 6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c0:	39 d0                	cmp    %edx,%eax
 6c2:	72 04                	jb     6c8 <free+0x58>
 6c4:	39 d1                	cmp    %edx,%ecx
 6c6:	72 ce                	jb     696 <free+0x26>
{
 6c8:	89 d0                	mov    %edx,%eax
 6ca:	eb bc                	jmp    688 <free+0x18>
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 6d0:	03 72 04             	add    0x4(%edx),%esi
 6d3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d6:	8b 10                	mov    (%eax),%edx
 6d8:	8b 12                	mov    (%edx),%edx
 6da:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6dd:	8b 50 04             	mov    0x4(%eax),%edx
 6e0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6e3:	39 f1                	cmp    %esi,%ecx
 6e5:	75 c6                	jne    6ad <free+0x3d>
    p->s.size += bp->s.size;
 6e7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6ea:	a3 00 0b 00 00       	mov    %eax,0xb00
    p->s.size += bp->s.size;
 6ef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6f5:	89 10                	mov    %edx,(%eax)
}
 6f7:	5b                   	pop    %ebx
 6f8:	5e                   	pop    %esi
 6f9:	5f                   	pop    %edi
 6fa:	5d                   	pop    %ebp
 6fb:	c3                   	ret    
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000700 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	57                   	push   %edi
 704:	56                   	push   %esi
 705:	53                   	push   %ebx
 706:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 709:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 70c:	8b 15 00 0b 00 00    	mov    0xb00,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 712:	8d 78 07             	lea    0x7(%eax),%edi
 715:	c1 ef 03             	shr    $0x3,%edi
 718:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 71b:	85 d2                	test   %edx,%edx
 71d:	0f 84 9d 00 00 00    	je     7c0 <malloc+0xc0>
 723:	8b 02                	mov    (%edx),%eax
 725:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 728:	39 cf                	cmp    %ecx,%edi
 72a:	76 6c                	jbe    798 <malloc+0x98>
 72c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 732:	bb 00 10 00 00       	mov    $0x1000,%ebx
 737:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 73a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 741:	eb 0e                	jmp    751 <malloc+0x51>
 743:	90                   	nop
 744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 748:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 74a:	8b 48 04             	mov    0x4(%eax),%ecx
 74d:	39 f9                	cmp    %edi,%ecx
 74f:	73 47                	jae    798 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 751:	39 05 00 0b 00 00    	cmp    %eax,0xb00
 757:	89 c2                	mov    %eax,%edx
 759:	75 ed                	jne    748 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 75b:	83 ec 0c             	sub    $0xc,%esp
 75e:	56                   	push   %esi
 75f:	e8 66 fc ff ff       	call   3ca <sbrk>
  if(p == (char*)-1)
 764:	83 c4 10             	add    $0x10,%esp
 767:	83 f8 ff             	cmp    $0xffffffff,%eax
 76a:	74 1c                	je     788 <malloc+0x88>
  hp->s.size = nu;
 76c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 76f:	83 ec 0c             	sub    $0xc,%esp
 772:	83 c0 08             	add    $0x8,%eax
 775:	50                   	push   %eax
 776:	e8 f5 fe ff ff       	call   670 <free>
  return freep;
 77b:	8b 15 00 0b 00 00    	mov    0xb00,%edx
      if((p = morecore(nunits)) == 0)
 781:	83 c4 10             	add    $0x10,%esp
 784:	85 d2                	test   %edx,%edx
 786:	75 c0                	jne    748 <malloc+0x48>
        return 0;
  }
}
 788:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 78b:	31 c0                	xor    %eax,%eax
}
 78d:	5b                   	pop    %ebx
 78e:	5e                   	pop    %esi
 78f:	5f                   	pop    %edi
 790:	5d                   	pop    %ebp
 791:	c3                   	ret    
 792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 798:	39 cf                	cmp    %ecx,%edi
 79a:	74 54                	je     7f0 <malloc+0xf0>
        p->s.size -= nunits;
 79c:	29 f9                	sub    %edi,%ecx
 79e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7a1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7a4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 7a7:	89 15 00 0b 00 00    	mov    %edx,0xb00
}
 7ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7b0:	83 c0 08             	add    $0x8,%eax
}
 7b3:	5b                   	pop    %ebx
 7b4:	5e                   	pop    %esi
 7b5:	5f                   	pop    %edi
 7b6:	5d                   	pop    %ebp
 7b7:	c3                   	ret    
 7b8:	90                   	nop
 7b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 7c0:	c7 05 00 0b 00 00 04 	movl   $0xb04,0xb00
 7c7:	0b 00 00 
 7ca:	c7 05 04 0b 00 00 04 	movl   $0xb04,0xb04
 7d1:	0b 00 00 
    base.s.size = 0;
 7d4:	b8 04 0b 00 00       	mov    $0xb04,%eax
 7d9:	c7 05 08 0b 00 00 00 	movl   $0x0,0xb08
 7e0:	00 00 00 
 7e3:	e9 44 ff ff ff       	jmp    72c <malloc+0x2c>
 7e8:	90                   	nop
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 7f0:	8b 08                	mov    (%eax),%ecx
 7f2:	89 0a                	mov    %ecx,(%edx)
 7f4:	eb b1                	jmp    7a7 <malloc+0xa7>
