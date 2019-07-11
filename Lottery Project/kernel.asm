
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc b0 cf 10 80       	mov    $0x8010cfb0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 2e 10 80       	mov    $0x80102eb0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 cf 10 80       	mov    $0x8010cff4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 79 10 80       	push   $0x801079a0
80100051:	68 c0 cf 10 80       	push   $0x8010cfc0
80100056:	e8 25 4b 00 00       	call   80104b80 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 17 11 80 bc 	movl   $0x801116bc,0x8011170c
80100062:	16 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 17 11 80 bc 	movl   $0x801116bc,0x80111710
8010006c:	16 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 16 11 80       	mov    $0x801116bc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 16 11 80 	movl   $0x801116bc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 79 10 80       	push   $0x801079a7
80100097:	50                   	push   %eax
80100098:	e8 b3 49 00 00       	call   80104a50 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 17 11 80       	mov    0x80111710,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 17 11 80    	mov    %ebx,0x80111710
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 16 11 80       	cmp    $0x801116bc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 cf 10 80       	push   $0x8010cfc0
801000e4:	e8 d7 4b 00 00       	call   80104cc0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 17 11 80    	mov    0x80111710,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 16 11 80    	cmp    $0x801116bc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 16 11 80    	cmp    $0x801116bc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 17 11 80    	mov    0x8011170c,%ebx
80100126:	81 fb bc 16 11 80    	cmp    $0x801116bc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 16 11 80    	cmp    $0x801116bc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 cf 10 80       	push   $0x8010cfc0
80100162:	e8 19 4c 00 00       	call   80104d80 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 49 00 00       	call   80104a90 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ad 1f 00 00       	call   80102130 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ae 79 10 80       	push   $0x801079ae
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 7d 49 00 00       	call   80104b30 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 79 10 80       	push   $0x801079bf
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 3c 49 00 00       	call   80104b30 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 48 00 00       	call   80104af0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 cf 10 80 	movl   $0x8010cfc0,(%esp)
8010020b:	e8 b0 4a 00 00       	call   80104cc0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 17 11 80       	mov    0x80111710,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 16 11 80 	movl   $0x801116bc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 17 11 80       	mov    0x80111710,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 17 11 80    	mov    %ebx,0x80111710
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 cf 10 80 	movl   $0x8010cfc0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 1f 4b 00 00       	jmp    80104d80 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 79 10 80       	push   $0x801079c6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 2f 4a 00 00       	call   80104cc0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 19 11 80    	mov    0x801119a0,%edx
801002a7:	39 15 a4 19 11 80    	cmp    %edx,0x801119a4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 a0 19 11 80       	push   $0x801119a0
801002c5:	e8 a6 41 00 00       	call   80104470 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 19 11 80    	mov    0x801119a0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 19 11 80    	cmp    0x801119a4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 10 3b 00 00       	call   80103df0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 8c 4a 00 00       	call   80104d80 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 19 11 80       	mov    %eax,0x801119a0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 19 11 80 	movsbl -0x7feee6e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 2e 4a 00 00       	call   80104d80 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 19 11 80    	mov    %edx,0x801119a0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 92 23 00 00       	call   80102740 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 cd 79 10 80       	push   $0x801079cd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 63 80 10 80 	movl   $0x80108063,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 c3 47 00 00       	call   80104ba0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 e1 79 10 80       	push   $0x801079e1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 61 61 00 00       	call   801065a0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 af 60 00 00       	call   801065a0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 a3 60 00 00       	call   801065a0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 97 60 00 00       	call   801065a0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 57 49 00 00       	call   80104e80 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 8a 48 00 00       	call   80104dd0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 e5 79 10 80       	push   $0x801079e5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 10 7a 10 80 	movzbl -0x7fef85f0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 a0 46 00 00       	call   80104cc0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 34 47 00 00       	call   80104d80 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 5c 46 00 00       	call   80104d80 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba f8 79 10 80       	mov    $0x801079f8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 cb 44 00 00       	call   80104cc0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 ff 79 10 80       	push   $0x801079ff
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 98 44 00 00       	call   80104cc0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 19 11 80       	mov    0x801119a8,%eax
80100856:	3b 05 a4 19 11 80    	cmp    0x801119a4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 19 11 80       	mov    %eax,0x801119a8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 f3 44 00 00       	call   80104d80 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 19 11 80       	mov    0x801119a8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 19 11 80    	sub    0x801119a0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 19 11 80    	mov    %edx,0x801119a8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 19 11 80    	mov    %cl,-0x7feee6e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 19 11 80       	mov    0x801119a0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 19 11 80    	cmp    %eax,0x801119a8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 19 11 80       	mov    %eax,0x801119a4
          wakeup(&input.r);
80100911:	68 a0 19 11 80       	push   $0x801119a0
80100916:	e8 15 3d 00 00       	call   80104630 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 19 11 80       	mov    0x801119a8,%eax
8010093d:	39 05 a4 19 11 80    	cmp    %eax,0x801119a4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 19 11 80       	mov    %eax,0x801119a8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 19 11 80       	mov    0x801119a8,%eax
80100964:	3b 05 a4 19 11 80    	cmp    0x801119a4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 19 11 80 0a 	cmpb   $0xa,-0x7feee6e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 74 3d 00 00       	jmp    80104710 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 19 11 80 0a 	movb   $0xa,-0x7feee6e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 19 11 80       	mov    0x801119a8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 08 7a 10 80       	push   $0x80107a08
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 ab 41 00 00       	call   80104b80 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 23 11 80 00 	movl   $0x80100600,0x8011236c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 23 11 80 70 	movl   $0x80100270,0x80112368
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 e2 18 00 00       	call   801022e0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 cf 33 00 00       	call   80103df0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 84 21 00 00       	call   80102bb0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 ac 21 00 00       	call   80102c20 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 57 6c 00 00       	call   801076f0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 15 6a 00 00       	call   80107510 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 23 69 00 00       	call   80107450 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 f9 6a 00 00       	call   80107670 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 81 20 00 00       	call   80102c20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 61 69 00 00       	call   80107510 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 aa 6a 00 00       	call   80107670 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 48 20 00 00       	call   80102c20 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 21 7a 10 80       	push   $0x80107a21
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 85 6b 00 00       	call   80107790 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 b2 43 00 00       	call   80104ff0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 9f 43 00 00       	call   80104ff0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 8e 6c 00 00       	call   801078f0 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 24 6c 00 00       	call   801078f0 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 a1 42 00 00       	call   80104fb0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 87 65 00 00       	call   801072c0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 2f 69 00 00       	call   80107670 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 2d 7a 10 80       	push   $0x80107a2d
80100d6b:	68 c0 19 11 80       	push   $0x801119c0
80100d70:	e8 0b 3e 00 00       	call   80104b80 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 19 11 80       	mov    $0x801119f4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 19 11 80       	push   $0x801119c0
80100d91:	e8 2a 3f 00 00       	call   80104cc0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 23 11 80    	cmp    $0x80112354,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 19 11 80       	push   $0x801119c0
80100dc1:	e8 ba 3f 00 00       	call   80104d80 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 19 11 80       	push   $0x801119c0
80100dda:	e8 a1 3f 00 00       	call   80104d80 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 19 11 80       	push   $0x801119c0
80100dff:	e8 bc 3e 00 00       	call   80104cc0 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 19 11 80       	push   $0x801119c0
80100e1c:	e8 5f 3f 00 00       	call   80104d80 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 34 7a 10 80       	push   $0x80107a34
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 19 11 80       	push   $0x801119c0
80100e51:	e8 6a 3e 00 00       	call   80104cc0 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 19 11 80 	movl   $0x801119c0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 ff 3e 00 00       	jmp    80104d80 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 19 11 80       	push   $0x801119c0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 d3 3e 00 00       	call   80104d80 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 8a 24 00 00       	call   80103360 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 cb 1c 00 00       	call   80102bb0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 21 1d 00 00       	jmp    80102c20 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 3c 7a 10 80       	push   $0x80107a3c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 3e 25 00 00       	jmp    80103510 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 46 7a 10 80       	push   $0x80107a46
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 d2 1b 00 00       	call   80102c20 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 35 1b 00 00       	call   80102bb0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 6e 1b 00 00       	call   80102c20 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 0e 23 00 00       	jmp    80103400 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 4f 7a 10 80       	push   $0x80107a4f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 55 7a 10 80       	push   $0x80107a55
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d c0 23 11 80    	mov    0x801123c0,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 d8 23 11 80    	add    0x801123d8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 c0 23 11 80       	mov    0x801123c0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 c0 23 11 80    	cmp    %eax,0x801123c0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 5f 7a 10 80       	push   $0x80107a5f
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 ae 1b 00 00       	call   80102d80 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 d6 3b 00 00       	call   80104dd0 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 7e 1b 00 00       	call   80102d80 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 24 11 80       	mov    $0x80112414,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 e0 23 11 80       	push   $0x801123e0
8010123a:	e8 81 3a 00 00       	call   80104cc0 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 34 40 11 80    	cmp    $0x80114034,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 34 40 11 80    	cmp    $0x80114034,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 e0 23 11 80       	push   $0x801123e0
8010129f:	e8 dc 3a 00 00       	call   80104d80 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 e0 23 11 80       	push   $0x801123e0
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 ae 3a 00 00       	call   80104d80 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 75 7a 10 80       	push   $0x80107a75
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 1d 1a 00 00       	call   80102d80 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 85 7a 10 80       	push   $0x80107a85
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 8a 3a 00 00       	call   80104e80 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 c0 23 11 80       	push   $0x801123c0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 d8 23 11 80    	add    0x801123d8,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 11 19 00 00       	call   80102d80 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 98 7a 10 80       	push   $0x80107a98
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 20 24 11 80       	mov    $0x80112420,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 ab 7a 10 80       	push   $0x80107aab
801014a1:	68 e0 23 11 80       	push   $0x801123e0
801014a6:	e8 d5 36 00 00       	call   80104b80 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 b2 7a 10 80       	push   $0x80107ab2
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 8c 35 00 00       	call   80104a50 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 40 40 11 80    	cmp    $0x80114040,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 c0 23 11 80       	push   $0x801123c0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 d8 23 11 80    	pushl  0x801123d8
801014e5:	ff 35 d4 23 11 80    	pushl  0x801123d4
801014eb:	ff 35 d0 23 11 80    	pushl  0x801123d0
801014f1:	ff 35 cc 23 11 80    	pushl  0x801123cc
801014f7:	ff 35 c8 23 11 80    	pushl  0x801123c8
801014fd:	ff 35 c4 23 11 80    	pushl  0x801123c4
80101503:	ff 35 c0 23 11 80    	pushl  0x801123c0
80101509:	68 18 7b 10 80       	push   $0x80107b18
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d c8 23 11 80 01 	cmpl   $0x1,0x801123c8
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d c8 23 11 80    	cmp    %ebx,0x801123c8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 d4 23 11 80    	add    0x801123d4,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 2d 38 00 00       	call   80104dd0 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 cb 17 00 00       	call   80102d80 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 b8 7a 10 80       	push   $0x80107ab8
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 23 11 80    	add    0x801123d4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 3a 38 00 00       	call   80104e80 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 32 17 00 00       	call   80102d80 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 e0 23 11 80       	push   $0x801123e0
8010166f:	e8 4c 36 00 00       	call   80104cc0 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 e0 23 11 80 	movl   $0x801123e0,(%esp)
8010167f:	e8 fc 36 00 00       	call   80104d80 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 d9 33 00 00       	call   80104a90 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 d4 23 11 80    	add    0x801123d4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 53 37 00 00       	call   80104e80 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 d0 7a 10 80       	push   $0x80107ad0
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 ca 7a 10 80       	push   $0x80107aca
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 a8 33 00 00       	call   80104b30 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 4c 33 00 00       	jmp    80104af0 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 df 7a 10 80       	push   $0x80107adf
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 bb 32 00 00       	call   80104a90 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 01 33 00 00       	call   80104af0 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 e0 23 11 80 	movl   $0x801123e0,(%esp)
801017f6:	e8 c5 34 00 00       	call   80104cc0 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 e0 23 11 80 	movl   $0x801123e0,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 6b 35 00 00       	jmp    80104d80 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 e0 23 11 80       	push   $0x801123e0
80101820:	e8 9b 34 00 00       	call   80104cc0 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 e0 23 11 80 	movl   $0x801123e0,(%esp)
8010182f:	e8 4c 35 00 00       	call   80104d80 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 64 34 00 00       	call   80104e80 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 60 23 11 80 	mov    -0x7feedca0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
      return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 68 33 00 00       	call   80104e80 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 60 12 00 00       	call   80102d80 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 64 23 11 80 	mov    -0x7feedc9c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 3d 33 00 00       	call   80104ef0 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 de 32 00 00       	call   80104ef0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
        *poff = off;
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 f9 7a 10 80       	push   $0x80107af9
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 e7 7a 10 80       	push   $0x80107ae7
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 62 21 00 00       	call   80103df0 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 e0 23 11 80       	push   $0x801123e0
80101c99:	e8 22 30 00 00       	call   80104cc0 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 e0 23 11 80 	movl   $0x801123e0,(%esp)
80101ca9:	e8 d2 30 00 00       	call   80104d80 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 76 31 00 00       	call   80104e80 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 e3 30 00 00       	call   80104e80 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
    iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
    return 0;
80101e20:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 be 30 00 00       	call   80104f50 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 08 7b 10 80       	push   $0x80107b08
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 e6 82 10 80       	push   $0x801082e6
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	66 90                	xchg   %ax,%ax
80101f26:	66 90                	xchg   %ax,%ax
80101f28:	66 90                	xchg   %ax,%ax
80101f2a:	66 90                	xchg   %ax,%ax
80101f2c:	66 90                	xchg   %ax,%ax
80101f2e:	66 90                	xchg   %ax,%ax

80101f30 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f39:	85 c0                	test   %eax,%eax
80101f3b:	0f 84 b4 00 00 00    	je     80101ff5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f41:	8b 58 08             	mov    0x8(%eax),%ebx
80101f44:	89 c6                	mov    %eax,%esi
80101f46:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f4c:	0f 87 96 00 00 00    	ja     80101fe8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f52:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f57:	89 f6                	mov    %esi,%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f60:	89 ca                	mov    %ecx,%edx
80101f62:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f63:	83 e0 c0             	and    $0xffffffc0,%eax
80101f66:	3c 40                	cmp    $0x40,%al
80101f68:	75 f6                	jne    80101f60 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f6a:	31 ff                	xor    %edi,%edi
80101f6c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f71:	89 f8                	mov    %edi,%eax
80101f73:	ee                   	out    %al,(%dx)
80101f74:	b8 01 00 00 00       	mov    $0x1,%eax
80101f79:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f7e:	ee                   	out    %al,(%dx)
80101f7f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f84:	89 d8                	mov    %ebx,%eax
80101f86:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f8e:	c1 f8 08             	sar    $0x8,%eax
80101f91:	ee                   	out    %al,(%dx)
80101f92:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f97:	89 f8                	mov    %edi,%eax
80101f99:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101f9a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101f9e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fa3:	c1 e0 04             	shl    $0x4,%eax
80101fa6:	83 e0 10             	and    $0x10,%eax
80101fa9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fad:	f6 06 04             	testb  $0x4,(%esi)
80101fb0:	75 16                	jne    80101fc8 <idestart+0x98>
80101fb2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fb7:	89 ca                	mov    %ecx,%edx
80101fb9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fbd:	5b                   	pop    %ebx
80101fbe:	5e                   	pop    %esi
80101fbf:	5f                   	pop    %edi
80101fc0:	5d                   	pop    %ebp
80101fc1:	c3                   	ret    
80101fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fc8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fcd:	89 ca                	mov    %ecx,%edx
80101fcf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fd0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fd5:	83 c6 5c             	add    $0x5c,%esi
80101fd8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fdd:	fc                   	cld    
80101fde:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fe3:	5b                   	pop    %ebx
80101fe4:	5e                   	pop    %esi
80101fe5:	5f                   	pop    %edi
80101fe6:	5d                   	pop    %ebp
80101fe7:	c3                   	ret    
    panic("incorrect blockno");
80101fe8:	83 ec 0c             	sub    $0xc,%esp
80101feb:	68 74 7b 10 80       	push   $0x80107b74
80101ff0:	e8 9b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80101ff5:	83 ec 0c             	sub    $0xc,%esp
80101ff8:	68 6b 7b 10 80       	push   $0x80107b6b
80101ffd:	e8 8e e3 ff ff       	call   80100390 <panic>
80102002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102016:	68 86 7b 10 80       	push   $0x80107b86
8010201b:	68 80 b5 10 80       	push   $0x8010b580
80102020:	e8 5b 2b 00 00       	call   80104b80 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102025:	58                   	pop    %eax
80102026:	a1 00 47 11 80       	mov    0x80114700,%eax
8010202b:	5a                   	pop    %edx
8010202c:	83 e8 01             	sub    $0x1,%eax
8010202f:	50                   	push   %eax
80102030:	6a 0e                	push   $0xe
80102032:	e8 a9 02 00 00       	call   801022e0 <ioapicenable>
80102037:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010203a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010203f:	90                   	nop
80102040:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102041:	83 e0 c0             	and    $0xffffffc0,%eax
80102044:	3c 40                	cmp    $0x40,%al
80102046:	75 f8                	jne    80102040 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102048:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010204d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102052:	ee                   	out    %al,(%dx)
80102053:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102058:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205d:	eb 06                	jmp    80102065 <ideinit+0x55>
8010205f:	90                   	nop
  for(i=0; i<1000; i++){
80102060:	83 e9 01             	sub    $0x1,%ecx
80102063:	74 0f                	je     80102074 <ideinit+0x64>
80102065:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102066:	84 c0                	test   %al,%al
80102068:	74 f6                	je     80102060 <ideinit+0x50>
      havedisk1 = 1;
8010206a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102071:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102074:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102079:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010207e:	ee                   	out    %al,(%dx)
}
8010207f:	c9                   	leave  
80102080:	c3                   	ret    
80102081:	eb 0d                	jmp    80102090 <ideintr>
80102083:	90                   	nop
80102084:	90                   	nop
80102085:	90                   	nop
80102086:	90                   	nop
80102087:	90                   	nop
80102088:	90                   	nop
80102089:	90                   	nop
8010208a:	90                   	nop
8010208b:	90                   	nop
8010208c:	90                   	nop
8010208d:	90                   	nop
8010208e:	90                   	nop
8010208f:	90                   	nop

80102090 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	68 80 b5 10 80       	push   $0x8010b580
8010209e:	e8 1d 2c 00 00       	call   80104cc0 <acquire>

  if((b = idequeue) == 0){
801020a3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020a9:	83 c4 10             	add    $0x10,%esp
801020ac:	85 db                	test   %ebx,%ebx
801020ae:	74 67                	je     80102117 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020b0:	8b 43 58             	mov    0x58(%ebx),%eax
801020b3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b8:	8b 3b                	mov    (%ebx),%edi
801020ba:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020c0:	75 31                	jne    801020f3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c7:	89 f6                	mov    %esi,%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d1:	89 c6                	mov    %eax,%esi
801020d3:	83 e6 c0             	and    $0xffffffc0,%esi
801020d6:	89 f1                	mov    %esi,%ecx
801020d8:	80 f9 40             	cmp    $0x40,%cl
801020db:	75 f3                	jne    801020d0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020dd:	a8 21                	test   $0x21,%al
801020df:	75 12                	jne    801020f3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801020e1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801020e4:	b9 80 00 00 00       	mov    $0x80,%ecx
801020e9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020ee:	fc                   	cld    
801020ef:	f3 6d                	rep insl (%dx),%es:(%edi)
801020f1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020f3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801020f6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801020f9:	89 f9                	mov    %edi,%ecx
801020fb:	83 c9 02             	or     $0x2,%ecx
801020fe:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102100:	53                   	push   %ebx
80102101:	e8 2a 25 00 00       	call   80104630 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102106:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	85 c0                	test   %eax,%eax
80102110:	74 05                	je     80102117 <ideintr+0x87>
    idestart(idequeue);
80102112:	e8 19 fe ff ff       	call   80101f30 <idestart>
    release(&idelock);
80102117:	83 ec 0c             	sub    $0xc,%esp
8010211a:	68 80 b5 10 80       	push   $0x8010b580
8010211f:	e8 5c 2c 00 00       	call   80104d80 <release>

  release(&idelock);
}
80102124:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102127:	5b                   	pop    %ebx
80102128:	5e                   	pop    %esi
80102129:	5f                   	pop    %edi
8010212a:	5d                   	pop    %ebp
8010212b:	c3                   	ret    
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 10             	sub    $0x10,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	50                   	push   %eax
8010213e:	e8 ed 29 00 00       	call   80104b30 <holdingsleep>
80102143:	83 c4 10             	add    $0x10,%esp
80102146:	85 c0                	test   %eax,%eax
80102148:	0f 84 c6 00 00 00    	je     80102214 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214e:	8b 03                	mov    (%ebx),%eax
80102150:	83 e0 06             	and    $0x6,%eax
80102153:	83 f8 02             	cmp    $0x2,%eax
80102156:	0f 84 ab 00 00 00    	je     80102207 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215c:	8b 53 04             	mov    0x4(%ebx),%edx
8010215f:	85 d2                	test   %edx,%edx
80102161:	74 0d                	je     80102170 <iderw+0x40>
80102163:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102168:	85 c0                	test   %eax,%eax
8010216a:	0f 84 b1 00 00 00    	je     80102221 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	68 80 b5 10 80       	push   $0x8010b580
80102178:	e8 43 2b 00 00       	call   80104cc0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102183:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102186:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218d:	85 d2                	test   %edx,%edx
8010218f:	75 09                	jne    8010219a <iderw+0x6a>
80102191:	eb 6d                	jmp    80102200 <iderw+0xd0>
80102193:	90                   	nop
80102194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102198:	89 c2                	mov    %eax,%edx
8010219a:	8b 42 58             	mov    0x58(%edx),%eax
8010219d:	85 c0                	test   %eax,%eax
8010219f:	75 f7                	jne    80102198 <iderw+0x68>
801021a1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021a4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021a6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801021ac:	74 42                	je     801021f0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ae:	8b 03                	mov    (%ebx),%eax
801021b0:	83 e0 06             	and    $0x6,%eax
801021b3:	83 f8 02             	cmp    $0x2,%eax
801021b6:	74 23                	je     801021db <iderw+0xab>
801021b8:	90                   	nop
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021c0:	83 ec 08             	sub    $0x8,%esp
801021c3:	68 80 b5 10 80       	push   $0x8010b580
801021c8:	53                   	push   %ebx
801021c9:	e8 a2 22 00 00       	call   80104470 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 c4 10             	add    $0x10,%esp
801021d3:	83 e0 06             	and    $0x6,%eax
801021d6:	83 f8 02             	cmp    $0x2,%eax
801021d9:	75 e5                	jne    801021c0 <iderw+0x90>
  }


  release(&idelock);
801021db:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801021e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021e5:	c9                   	leave  
  release(&idelock);
801021e6:	e9 95 2b 00 00       	jmp    80104d80 <release>
801021eb:	90                   	nop
801021ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801021f0:	89 d8                	mov    %ebx,%eax
801021f2:	e8 39 fd ff ff       	call   80101f30 <idestart>
801021f7:	eb b5                	jmp    801021ae <iderw+0x7e>
801021f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102200:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102205:	eb 9d                	jmp    801021a4 <iderw+0x74>
    panic("iderw: nothing to do");
80102207:	83 ec 0c             	sub    $0xc,%esp
8010220a:	68 a0 7b 10 80       	push   $0x80107ba0
8010220f:	e8 7c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 8a 7b 10 80       	push   $0x80107b8a
8010221c:	e8 6f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102221:	83 ec 0c             	sub    $0xc,%esp
80102224:	68 b5 7b 10 80       	push   $0x80107bb5
80102229:	e8 62 e1 ff ff       	call   80100390 <panic>
8010222e:	66 90                	xchg   %ax,%ax

80102230 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102230:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102231:	c7 05 34 40 11 80 00 	movl   $0xfec00000,0x80114034
80102238:	00 c0 fe 
{
8010223b:	89 e5                	mov    %esp,%ebp
8010223d:	56                   	push   %esi
8010223e:	53                   	push   %ebx
  ioapic->reg = reg;
8010223f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102246:	00 00 00 
  return ioapic->data;
80102249:	a1 34 40 11 80       	mov    0x80114034,%eax
8010224e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102251:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102257:	8b 0d 34 40 11 80    	mov    0x80114034,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010225d:	0f b6 15 60 41 11 80 	movzbl 0x80114160,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102264:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102267:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010226a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010226d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102270:	39 c2                	cmp    %eax,%edx
80102272:	74 16                	je     8010228a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102274:	83 ec 0c             	sub    $0xc,%esp
80102277:	68 d4 7b 10 80       	push   $0x80107bd4
8010227c:	e8 df e3 ff ff       	call   80100660 <cprintf>
80102281:	8b 0d 34 40 11 80    	mov    0x80114034,%ecx
80102287:	83 c4 10             	add    $0x10,%esp
8010228a:	83 c3 21             	add    $0x21,%ebx
{
8010228d:	ba 10 00 00 00       	mov    $0x10,%edx
80102292:	b8 20 00 00 00       	mov    $0x20,%eax
80102297:	89 f6                	mov    %esi,%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022a0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022a2:	8b 0d 34 40 11 80    	mov    0x80114034,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022a8:	89 c6                	mov    %eax,%esi
801022aa:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022b0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022b3:	89 71 10             	mov    %esi,0x10(%ecx)
801022b6:	8d 72 01             	lea    0x1(%edx),%esi
801022b9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022bc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022be:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022c0:	8b 0d 34 40 11 80    	mov    0x80114034,%ecx
801022c6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022cd:	75 d1                	jne    801022a0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022d2:	5b                   	pop    %ebx
801022d3:	5e                   	pop    %esi
801022d4:	5d                   	pop    %ebp
801022d5:	c3                   	ret    
801022d6:	8d 76 00             	lea    0x0(%esi),%esi
801022d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022e0:	55                   	push   %ebp
  ioapic->reg = reg;
801022e1:	8b 0d 34 40 11 80    	mov    0x80114034,%ecx
{
801022e7:	89 e5                	mov    %esp,%ebp
801022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ec:	8d 50 20             	lea    0x20(%eax),%edx
801022ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801022f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022f5:	8b 0d 34 40 11 80    	mov    0x80114034,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102301:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102304:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102306:	a1 34 40 11 80       	mov    0x80114034,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010230b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010230e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102311:	5d                   	pop    %ebp
80102312:	c3                   	ret    
80102313:	66 90                	xchg   %ax,%ax
80102315:	66 90                	xchg   %ax,%ax
80102317:	66 90                	xchg   %ax,%ax
80102319:	66 90                	xchg   %ax,%ax
8010231b:	66 90                	xchg   %ax,%ax
8010231d:	66 90                	xchg   %ax,%ax
8010231f:	90                   	nop

80102320 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 04             	sub    $0x4,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010232a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102330:	75 70                	jne    801023a2 <kfree+0x82>
80102332:	81 fb a8 c0 11 80    	cmp    $0x8011c0a8,%ebx
80102338:	72 68                	jb     801023a2 <kfree+0x82>
8010233a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102340:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102345:	77 5b                	ja     801023a2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102347:	83 ec 04             	sub    $0x4,%esp
8010234a:	68 00 10 00 00       	push   $0x1000
8010234f:	6a 01                	push   $0x1
80102351:	53                   	push   %ebx
80102352:	e8 79 2a 00 00       	call   80104dd0 <memset>

  if(kmem.use_lock)
80102357:	8b 15 74 40 11 80    	mov    0x80114074,%edx
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	85 d2                	test   %edx,%edx
80102362:	75 2c                	jne    80102390 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102364:	a1 78 40 11 80       	mov    0x80114078,%eax
80102369:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010236b:	a1 74 40 11 80       	mov    0x80114074,%eax
  kmem.freelist = r;
80102370:	89 1d 78 40 11 80    	mov    %ebx,0x80114078
  if(kmem.use_lock)
80102376:	85 c0                	test   %eax,%eax
80102378:	75 06                	jne    80102380 <kfree+0x60>
    release(&kmem.lock);
}
8010237a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010237d:	c9                   	leave  
8010237e:	c3                   	ret    
8010237f:	90                   	nop
    release(&kmem.lock);
80102380:	c7 45 08 40 40 11 80 	movl   $0x80114040,0x8(%ebp)
}
80102387:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010238a:	c9                   	leave  
    release(&kmem.lock);
8010238b:	e9 f0 29 00 00       	jmp    80104d80 <release>
    acquire(&kmem.lock);
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 40 40 11 80       	push   $0x80114040
80102398:	e8 23 29 00 00       	call   80104cc0 <acquire>
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	eb c2                	jmp    80102364 <kfree+0x44>
    panic("kfree");
801023a2:	83 ec 0c             	sub    $0xc,%esp
801023a5:	68 06 7c 10 80       	push   $0x80107c06
801023aa:	e8 e1 df ff ff       	call   80100390 <panic>
801023af:	90                   	nop

801023b0 <freerange>:
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	56                   	push   %esi
801023b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023cd:	39 de                	cmp    %ebx,%esi
801023cf:	72 23                	jb     801023f4 <freerange+0x44>
801023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801023d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023de:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023e7:	50                   	push   %eax
801023e8:	e8 33 ff ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	39 f3                	cmp    %esi,%ebx
801023f2:	76 e4                	jbe    801023d8 <freerange+0x28>
}
801023f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023f7:	5b                   	pop    %ebx
801023f8:	5e                   	pop    %esi
801023f9:	5d                   	pop    %ebp
801023fa:	c3                   	ret    
801023fb:	90                   	nop
801023fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102400 <kinit1>:
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
80102405:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102408:	83 ec 08             	sub    $0x8,%esp
8010240b:	68 0c 7c 10 80       	push   $0x80107c0c
80102410:	68 40 40 11 80       	push   $0x80114040
80102415:	e8 66 27 00 00       	call   80104b80 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010241a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010241d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102420:	c7 05 74 40 11 80 00 	movl   $0x0,0x80114074
80102427:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010242a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102430:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102436:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010243c:	39 de                	cmp    %ebx,%esi
8010243e:	72 1c                	jb     8010245c <kinit1+0x5c>
    kfree(p);
80102440:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102446:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102449:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010244f:	50                   	push   %eax
80102450:	e8 cb fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102455:	83 c4 10             	add    $0x10,%esp
80102458:	39 de                	cmp    %ebx,%esi
8010245a:	73 e4                	jae    80102440 <kinit1+0x40>
}
8010245c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245f:	5b                   	pop    %ebx
80102460:	5e                   	pop    %esi
80102461:	5d                   	pop    %ebp
80102462:	c3                   	ret    
80102463:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kinit2>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	56                   	push   %esi
80102474:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102475:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102478:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010247b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102481:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102487:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010248d:	39 de                	cmp    %ebx,%esi
8010248f:	72 23                	jb     801024b4 <kinit2+0x44>
80102491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102498:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010249e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024a7:	50                   	push   %eax
801024a8:	e8 73 fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ad:	83 c4 10             	add    $0x10,%esp
801024b0:	39 de                	cmp    %ebx,%esi
801024b2:	73 e4                	jae    80102498 <kinit2+0x28>
  kmem.use_lock = 1;
801024b4:	c7 05 74 40 11 80 01 	movl   $0x1,0x80114074
801024bb:	00 00 00 
}
801024be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c1:	5b                   	pop    %ebx
801024c2:	5e                   	pop    %esi
801024c3:	5d                   	pop    %ebp
801024c4:	c3                   	ret    
801024c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024d0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801024d0:	a1 74 40 11 80       	mov    0x80114074,%eax
801024d5:	85 c0                	test   %eax,%eax
801024d7:	75 1f                	jne    801024f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024d9:	a1 78 40 11 80       	mov    0x80114078,%eax
  if(r)
801024de:	85 c0                	test   %eax,%eax
801024e0:	74 0e                	je     801024f0 <kalloc+0x20>
    kmem.freelist = r->next;
801024e2:	8b 10                	mov    (%eax),%edx
801024e4:	89 15 78 40 11 80    	mov    %edx,0x80114078
801024ea:	c3                   	ret    
801024eb:	90                   	nop
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801024f0:	f3 c3                	repz ret 
801024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801024f8:	55                   	push   %ebp
801024f9:	89 e5                	mov    %esp,%ebp
801024fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801024fe:	68 40 40 11 80       	push   $0x80114040
80102503:	e8 b8 27 00 00       	call   80104cc0 <acquire>
  r = kmem.freelist;
80102508:	a1 78 40 11 80       	mov    0x80114078,%eax
  if(r)
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	8b 15 74 40 11 80    	mov    0x80114074,%edx
80102516:	85 c0                	test   %eax,%eax
80102518:	74 08                	je     80102522 <kalloc+0x52>
    kmem.freelist = r->next;
8010251a:	8b 08                	mov    (%eax),%ecx
8010251c:	89 0d 78 40 11 80    	mov    %ecx,0x80114078
  if(kmem.use_lock)
80102522:	85 d2                	test   %edx,%edx
80102524:	74 16                	je     8010253c <kalloc+0x6c>
    release(&kmem.lock);
80102526:	83 ec 0c             	sub    $0xc,%esp
80102529:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010252c:	68 40 40 11 80       	push   $0x80114040
80102531:	e8 4a 28 00 00       	call   80104d80 <release>
  return (char*)r;
80102536:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102539:	83 c4 10             	add    $0x10,%esp
}
8010253c:	c9                   	leave  
8010253d:	c3                   	ret    
8010253e:	66 90                	xchg   %ax,%ax

80102540 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102540:	ba 64 00 00 00       	mov    $0x64,%edx
80102545:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102546:	a8 01                	test   $0x1,%al
80102548:	0f 84 c2 00 00 00    	je     80102610 <kbdgetc+0xd0>
8010254e:	ba 60 00 00 00       	mov    $0x60,%edx
80102553:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102554:	0f b6 d0             	movzbl %al,%edx
80102557:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010255d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102563:	0f 84 7f 00 00 00    	je     801025e8 <kbdgetc+0xa8>
{
80102569:	55                   	push   %ebp
8010256a:	89 e5                	mov    %esp,%ebp
8010256c:	53                   	push   %ebx
8010256d:	89 cb                	mov    %ecx,%ebx
8010256f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102572:	84 c0                	test   %al,%al
80102574:	78 4a                	js     801025c0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102576:	85 db                	test   %ebx,%ebx
80102578:	74 09                	je     80102583 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010257a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010257d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102580:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102583:	0f b6 82 40 7d 10 80 	movzbl -0x7fef82c0(%edx),%eax
8010258a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010258c:	0f b6 82 40 7c 10 80 	movzbl -0x7fef83c0(%edx),%eax
80102593:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102595:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102597:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010259d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025a0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025a3:	8b 04 85 20 7c 10 80 	mov    -0x7fef83e0(,%eax,4),%eax
801025aa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025ae:	74 31                	je     801025e1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025b0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025b3:	83 fa 19             	cmp    $0x19,%edx
801025b6:	77 40                	ja     801025f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025b8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025bb:	5b                   	pop    %ebx
801025bc:	5d                   	pop    %ebp
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025c0:	83 e0 7f             	and    $0x7f,%eax
801025c3:	85 db                	test   %ebx,%ebx
801025c5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025c8:	0f b6 82 40 7d 10 80 	movzbl -0x7fef82c0(%edx),%eax
801025cf:	83 c8 40             	or     $0x40,%eax
801025d2:	0f b6 c0             	movzbl %al,%eax
801025d5:	f7 d0                	not    %eax
801025d7:	21 c1                	and    %eax,%ecx
    return 0;
801025d9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801025db:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801025e1:	5b                   	pop    %ebx
801025e2:	5d                   	pop    %ebp
801025e3:	c3                   	ret    
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025e8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801025eb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801025ed:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
801025f3:	c3                   	ret    
801025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801025f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801025fe:	5b                   	pop    %ebx
      c += 'a' - 'A';
801025ff:	83 f9 1a             	cmp    $0x1a,%ecx
80102602:	0f 42 c2             	cmovb  %edx,%eax
}
80102605:	5d                   	pop    %ebp
80102606:	c3                   	ret    
80102607:	89 f6                	mov    %esi,%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102615:	c3                   	ret    
80102616:	8d 76 00             	lea    0x0(%esi),%esi
80102619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102620 <kbdintr>:

void
kbdintr(void)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102626:	68 40 25 10 80       	push   $0x80102540
8010262b:	e8 e0 e1 ff ff       	call   80100810 <consoleintr>
}
80102630:	83 c4 10             	add    $0x10,%esp
80102633:	c9                   	leave  
80102634:	c3                   	ret    
80102635:	66 90                	xchg   %ax,%ax
80102637:	66 90                	xchg   %ax,%ax
80102639:	66 90                	xchg   %ax,%ax
8010263b:	66 90                	xchg   %ax,%ax
8010263d:	66 90                	xchg   %ax,%ax
8010263f:	90                   	nop

80102640 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102640:	a1 7c 40 11 80       	mov    0x8011407c,%eax
{
80102645:	55                   	push   %ebp
80102646:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102648:	85 c0                	test   %eax,%eax
8010264a:	0f 84 c8 00 00 00    	je     80102718 <lapicinit+0xd8>
  lapic[index] = value;
80102650:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102657:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010265a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010265d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102664:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102667:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010266a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102671:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102674:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102677:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010267e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102681:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102684:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010268b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010268e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102691:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102698:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010269b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010269e:	8b 50 30             	mov    0x30(%eax),%edx
801026a1:	c1 ea 10             	shr    $0x10,%edx
801026a4:	80 fa 03             	cmp    $0x3,%dl
801026a7:	77 77                	ja     80102720 <lapicinit+0xe0>
  lapic[index] = value;
801026a9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026b0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026dd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801026e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ea:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026f1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026f4:	8b 50 20             	mov    0x20(%eax),%edx
801026f7:	89 f6                	mov    %esi,%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102700:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102706:	80 e6 10             	and    $0x10,%dh
80102709:	75 f5                	jne    80102700 <lapicinit+0xc0>
  lapic[index] = value;
8010270b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102712:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102715:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102720:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102727:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010272a:	8b 50 20             	mov    0x20(%eax),%edx
8010272d:	e9 77 ff ff ff       	jmp    801026a9 <lapicinit+0x69>
80102732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102740:	8b 15 7c 40 11 80    	mov    0x8011407c,%edx
{
80102746:	55                   	push   %ebp
80102747:	31 c0                	xor    %eax,%eax
80102749:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010274b:	85 d2                	test   %edx,%edx
8010274d:	74 06                	je     80102755 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010274f:	8b 42 20             	mov    0x20(%edx),%eax
80102752:	c1 e8 18             	shr    $0x18,%eax
}
80102755:	5d                   	pop    %ebp
80102756:	c3                   	ret    
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102760 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102760:	a1 7c 40 11 80       	mov    0x8011407c,%eax
{
80102765:	55                   	push   %ebp
80102766:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102768:	85 c0                	test   %eax,%eax
8010276a:	74 0d                	je     80102779 <lapiceoi+0x19>
  lapic[index] = value;
8010276c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102773:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102776:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102779:	5d                   	pop    %ebp
8010277a:	c3                   	ret    
8010277b:	90                   	nop
8010277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102780 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
}
80102783:	5d                   	pop    %ebp
80102784:	c3                   	ret    
80102785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102790:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102791:	b8 0f 00 00 00       	mov    $0xf,%eax
80102796:	ba 70 00 00 00       	mov    $0x70,%edx
8010279b:	89 e5                	mov    %esp,%ebp
8010279d:	53                   	push   %ebx
8010279e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027a4:	ee                   	out    %al,(%dx)
801027a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027aa:	ba 71 00 00 00       	mov    $0x71,%edx
801027af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027b0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027b2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027bd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027c0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027c3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027c5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027ce:	a1 7c 40 11 80       	mov    0x8011407c,%eax
801027d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027d9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801027ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102805:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102808:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102811:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010281a:	5b                   	pop    %ebx
8010281b:	5d                   	pop    %ebp
8010281c:	c3                   	ret    
8010281d:	8d 76 00             	lea    0x0(%esi),%esi

80102820 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102820:	55                   	push   %ebp
80102821:	b8 0b 00 00 00       	mov    $0xb,%eax
80102826:	ba 70 00 00 00       	mov    $0x70,%edx
8010282b:	89 e5                	mov    %esp,%ebp
8010282d:	57                   	push   %edi
8010282e:	56                   	push   %esi
8010282f:	53                   	push   %ebx
80102830:	83 ec 4c             	sub    $0x4c,%esp
80102833:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102834:	ba 71 00 00 00       	mov    $0x71,%edx
80102839:	ec                   	in     (%dx),%al
8010283a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010283d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102842:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102845:	8d 76 00             	lea    0x0(%esi),%esi
80102848:	31 c0                	xor    %eax,%eax
8010284a:	89 da                	mov    %ebx,%edx
8010284c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102852:	89 ca                	mov    %ecx,%edx
80102854:	ec                   	in     (%dx),%al
80102855:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102858:	89 da                	mov    %ebx,%edx
8010285a:	b8 02 00 00 00       	mov    $0x2,%eax
8010285f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102860:	89 ca                	mov    %ecx,%edx
80102862:	ec                   	in     (%dx),%al
80102863:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102866:	89 da                	mov    %ebx,%edx
80102868:	b8 04 00 00 00       	mov    $0x4,%eax
8010286d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286e:	89 ca                	mov    %ecx,%edx
80102870:	ec                   	in     (%dx),%al
80102871:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102874:	89 da                	mov    %ebx,%edx
80102876:	b8 07 00 00 00       	mov    $0x7,%eax
8010287b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	89 ca                	mov    %ecx,%edx
8010287e:	ec                   	in     (%dx),%al
8010287f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102882:	89 da                	mov    %ebx,%edx
80102884:	b8 08 00 00 00       	mov    $0x8,%eax
80102889:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288a:	89 ca                	mov    %ecx,%edx
8010288c:	ec                   	in     (%dx),%al
8010288d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288f:	89 da                	mov    %ebx,%edx
80102891:	b8 09 00 00 00       	mov    $0x9,%eax
80102896:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102897:	89 ca                	mov    %ecx,%edx
80102899:	ec                   	in     (%dx),%al
8010289a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010289c:	89 da                	mov    %ebx,%edx
8010289e:	b8 0a 00 00 00       	mov    $0xa,%eax
801028a3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a4:	89 ca                	mov    %ecx,%edx
801028a6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028a7:	84 c0                	test   %al,%al
801028a9:	78 9d                	js     80102848 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028ab:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028af:	89 fa                	mov    %edi,%edx
801028b1:	0f b6 fa             	movzbl %dl,%edi
801028b4:	89 f2                	mov    %esi,%edx
801028b6:	0f b6 f2             	movzbl %dl,%esi
801028b9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bc:	89 da                	mov    %ebx,%edx
801028be:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028c1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028c4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028c8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028cb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
801028d2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801028d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028d9:	31 c0                	xor    %eax,%eax
801028db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dc:	89 ca                	mov    %ecx,%edx
801028de:	ec                   	in     (%dx),%al
801028df:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e2:	89 da                	mov    %ebx,%edx
801028e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028e7:	b8 02 00 00 00       	mov    $0x2,%eax
801028ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ed:	89 ca                	mov    %ecx,%edx
801028ef:	ec                   	in     (%dx),%al
801028f0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f3:	89 da                	mov    %ebx,%edx
801028f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028f8:	b8 04 00 00 00       	mov    $0x4,%eax
801028fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fe:	89 ca                	mov    %ecx,%edx
80102900:	ec                   	in     (%dx),%al
80102901:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102904:	89 da                	mov    %ebx,%edx
80102906:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102909:	b8 07 00 00 00       	mov    $0x7,%eax
8010290e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290f:	89 ca                	mov    %ecx,%edx
80102911:	ec                   	in     (%dx),%al
80102912:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102915:	89 da                	mov    %ebx,%edx
80102917:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010291a:	b8 08 00 00 00       	mov    $0x8,%eax
8010291f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102920:	89 ca                	mov    %ecx,%edx
80102922:	ec                   	in     (%dx),%al
80102923:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102926:	89 da                	mov    %ebx,%edx
80102928:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010292b:	b8 09 00 00 00       	mov    $0x9,%eax
80102930:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102931:	89 ca                	mov    %ecx,%edx
80102933:	ec                   	in     (%dx),%al
80102934:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102937:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010293a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010293d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102940:	6a 18                	push   $0x18
80102942:	50                   	push   %eax
80102943:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102946:	50                   	push   %eax
80102947:	e8 d4 24 00 00       	call   80104e20 <memcmp>
8010294c:	83 c4 10             	add    $0x10,%esp
8010294f:	85 c0                	test   %eax,%eax
80102951:	0f 85 f1 fe ff ff    	jne    80102848 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102957:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010295b:	75 78                	jne    801029d5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010295d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102960:	89 c2                	mov    %eax,%edx
80102962:	83 e0 0f             	and    $0xf,%eax
80102965:	c1 ea 04             	shr    $0x4,%edx
80102968:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102971:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102974:	89 c2                	mov    %eax,%edx
80102976:	83 e0 0f             	and    $0xf,%eax
80102979:	c1 ea 04             	shr    $0x4,%edx
8010297c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102982:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102985:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102988:	89 c2                	mov    %eax,%edx
8010298a:	83 e0 0f             	and    $0xf,%eax
8010298d:	c1 ea 04             	shr    $0x4,%edx
80102990:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102993:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102996:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102999:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010299c:	89 c2                	mov    %eax,%edx
8010299e:	83 e0 0f             	and    $0xf,%eax
801029a1:	c1 ea 04             	shr    $0x4,%edx
801029a4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029aa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029ad:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029b0:	89 c2                	mov    %eax,%edx
801029b2:	83 e0 0f             	and    $0xf,%eax
801029b5:	c1 ea 04             	shr    $0x4,%edx
801029b8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029be:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c4:	89 c2                	mov    %eax,%edx
801029c6:	83 e0 0f             	and    $0xf,%eax
801029c9:	c1 ea 04             	shr    $0x4,%edx
801029cc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029d5:	8b 75 08             	mov    0x8(%ebp),%esi
801029d8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029db:	89 06                	mov    %eax,(%esi)
801029dd:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029e0:	89 46 04             	mov    %eax,0x4(%esi)
801029e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029e6:	89 46 08             	mov    %eax,0x8(%esi)
801029e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ec:	89 46 0c             	mov    %eax,0xc(%esi)
801029ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029f2:	89 46 10             	mov    %eax,0x10(%esi)
801029f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029fb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a05:	5b                   	pop    %ebx
80102a06:	5e                   	pop    %esi
80102a07:	5f                   	pop    %edi
80102a08:	5d                   	pop    %ebp
80102a09:	c3                   	ret    
80102a0a:	66 90                	xchg   %ax,%ax
80102a0c:	66 90                	xchg   %ax,%ax
80102a0e:	66 90                	xchg   %ax,%ax

80102a10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a10:	8b 0d c8 40 11 80    	mov    0x801140c8,%ecx
80102a16:	85 c9                	test   %ecx,%ecx
80102a18:	0f 8e 8a 00 00 00    	jle    80102aa8 <install_trans+0x98>
{
80102a1e:	55                   	push   %ebp
80102a1f:	89 e5                	mov    %esp,%ebp
80102a21:	57                   	push   %edi
80102a22:	56                   	push   %esi
80102a23:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a24:	31 db                	xor    %ebx,%ebx
{
80102a26:	83 ec 0c             	sub    $0xc,%esp
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a30:	a1 b4 40 11 80       	mov    0x801140b4,%eax
80102a35:	83 ec 08             	sub    $0x8,%esp
80102a38:	01 d8                	add    %ebx,%eax
80102a3a:	83 c0 01             	add    $0x1,%eax
80102a3d:	50                   	push   %eax
80102a3e:	ff 35 c4 40 11 80    	pushl  0x801140c4
80102a44:	e8 87 d6 ff ff       	call   801000d0 <bread>
80102a49:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4b:	58                   	pop    %eax
80102a4c:	5a                   	pop    %edx
80102a4d:	ff 34 9d cc 40 11 80 	pushl  -0x7feebf34(,%ebx,4)
80102a54:	ff 35 c4 40 11 80    	pushl  0x801140c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5d:	e8 6e d6 ff ff       	call   801000d0 <bread>
80102a62:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a64:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a67:	83 c4 0c             	add    $0xc,%esp
80102a6a:	68 00 02 00 00       	push   $0x200
80102a6f:	50                   	push   %eax
80102a70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a73:	50                   	push   %eax
80102a74:	e8 07 24 00 00       	call   80104e80 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 1f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a81:	89 3c 24             	mov    %edi,(%esp)
80102a84:	e8 57 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 4f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a91:	83 c4 10             	add    $0x10,%esp
80102a94:	39 1d c8 40 11 80    	cmp    %ebx,0x801140c8
80102a9a:	7f 94                	jg     80102a30 <install_trans+0x20>
  }
}
80102a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a9f:	5b                   	pop    %ebx
80102aa0:	5e                   	pop    %esi
80102aa1:	5f                   	pop    %edi
80102aa2:	5d                   	pop    %ebp
80102aa3:	c3                   	ret    
80102aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa8:	f3 c3                	repz ret 
80102aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ab0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	56                   	push   %esi
80102ab4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ab5:	83 ec 08             	sub    $0x8,%esp
80102ab8:	ff 35 b4 40 11 80    	pushl  0x801140b4
80102abe:	ff 35 c4 40 11 80    	pushl  0x801140c4
80102ac4:	e8 07 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ac9:	8b 1d c8 40 11 80    	mov    0x801140c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102acf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ad2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ad4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ad6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ad9:	7e 16                	jle    80102af1 <write_head+0x41>
80102adb:	c1 e3 02             	shl    $0x2,%ebx
80102ade:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ae0:	8b 8a cc 40 11 80    	mov    -0x7feebf34(%edx),%ecx
80102ae6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102aea:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102aed:	39 da                	cmp    %ebx,%edx
80102aef:	75 ef                	jne    80102ae0 <write_head+0x30>
  }
  bwrite(buf);
80102af1:	83 ec 0c             	sub    $0xc,%esp
80102af4:	56                   	push   %esi
80102af5:	e8 a6 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102afa:	89 34 24             	mov    %esi,(%esp)
80102afd:	e8 de d6 ff ff       	call   801001e0 <brelse>
}
80102b02:	83 c4 10             	add    $0x10,%esp
80102b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b08:	5b                   	pop    %ebx
80102b09:	5e                   	pop    %esi
80102b0a:	5d                   	pop    %ebp
80102b0b:	c3                   	ret    
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <initlog>:
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	53                   	push   %ebx
80102b14:	83 ec 2c             	sub    $0x2c,%esp
80102b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b1a:	68 40 7e 10 80       	push   $0x80107e40
80102b1f:	68 80 40 11 80       	push   $0x80114080
80102b24:	e8 57 20 00 00       	call   80104b80 <initlock>
  readsb(dev, &sb);
80102b29:	58                   	pop    %eax
80102b2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b2d:	5a                   	pop    %edx
80102b2e:	50                   	push   %eax
80102b2f:	53                   	push   %ebx
80102b30:	e8 9b e8 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b3b:	59                   	pop    %ecx
  log.dev = dev;
80102b3c:	89 1d c4 40 11 80    	mov    %ebx,0x801140c4
  log.size = sb.nlog;
80102b42:	89 15 b8 40 11 80    	mov    %edx,0x801140b8
  log.start = sb.logstart;
80102b48:	a3 b4 40 11 80       	mov    %eax,0x801140b4
  struct buf *buf = bread(log.dev, log.start);
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 7b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b55:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b58:	83 c4 10             	add    $0x10,%esp
80102b5b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b5d:	89 1d c8 40 11 80    	mov    %ebx,0x801140c8
  for (i = 0; i < log.lh.n; i++) {
80102b63:	7e 1c                	jle    80102b81 <initlog+0x71>
80102b65:	c1 e3 02             	shl    $0x2,%ebx
80102b68:	31 d2                	xor    %edx,%edx
80102b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102b70:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b74:	83 c2 04             	add    $0x4,%edx
80102b77:	89 8a c8 40 11 80    	mov    %ecx,-0x7feebf38(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102b7d:	39 d3                	cmp    %edx,%ebx
80102b7f:	75 ef                	jne    80102b70 <initlog+0x60>
  brelse(buf);
80102b81:	83 ec 0c             	sub    $0xc,%esp
80102b84:	50                   	push   %eax
80102b85:	e8 56 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b8a:	e8 81 fe ff ff       	call   80102a10 <install_trans>
  log.lh.n = 0;
80102b8f:	c7 05 c8 40 11 80 00 	movl   $0x0,0x801140c8
80102b96:	00 00 00 
  write_head(); // clear the log
80102b99:	e8 12 ff ff ff       	call   80102ab0 <write_head>
}
80102b9e:	83 c4 10             	add    $0x10,%esp
80102ba1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ba4:	c9                   	leave  
80102ba5:	c3                   	ret    
80102ba6:	8d 76 00             	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bb6:	68 80 40 11 80       	push   $0x80114080
80102bbb:	e8 00 21 00 00       	call   80104cc0 <acquire>
80102bc0:	83 c4 10             	add    $0x10,%esp
80102bc3:	eb 18                	jmp    80102bdd <begin_op+0x2d>
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bc8:	83 ec 08             	sub    $0x8,%esp
80102bcb:	68 80 40 11 80       	push   $0x80114080
80102bd0:	68 80 40 11 80       	push   $0x80114080
80102bd5:	e8 96 18 00 00       	call   80104470 <sleep>
80102bda:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102bdd:	a1 c0 40 11 80       	mov    0x801140c0,%eax
80102be2:	85 c0                	test   %eax,%eax
80102be4:	75 e2                	jne    80102bc8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102be6:	a1 bc 40 11 80       	mov    0x801140bc,%eax
80102beb:	8b 15 c8 40 11 80    	mov    0x801140c8,%edx
80102bf1:	83 c0 01             	add    $0x1,%eax
80102bf4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bf7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bfa:	83 fa 1e             	cmp    $0x1e,%edx
80102bfd:	7f c9                	jg     80102bc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c02:	a3 bc 40 11 80       	mov    %eax,0x801140bc
      release(&log.lock);
80102c07:	68 80 40 11 80       	push   $0x80114080
80102c0c:	e8 6f 21 00 00       	call   80104d80 <release>
      break;
    }
  }
}
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    
80102c16:	8d 76 00             	lea    0x0(%esi),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	57                   	push   %edi
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c29:	68 80 40 11 80       	push   $0x80114080
80102c2e:	e8 8d 20 00 00       	call   80104cc0 <acquire>
  log.outstanding -= 1;
80102c33:	a1 bc 40 11 80       	mov    0x801140bc,%eax
  if(log.committing)
80102c38:	8b 35 c0 40 11 80    	mov    0x801140c0,%esi
80102c3e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c41:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c44:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c46:	89 1d bc 40 11 80    	mov    %ebx,0x801140bc
  if(log.committing)
80102c4c:	0f 85 1a 01 00 00    	jne    80102d6c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c52:	85 db                	test   %ebx,%ebx
80102c54:	0f 85 ee 00 00 00    	jne    80102d48 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c5a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c5d:	c7 05 c0 40 11 80 01 	movl   $0x1,0x801140c0
80102c64:	00 00 00 
  release(&log.lock);
80102c67:	68 80 40 11 80       	push   $0x80114080
80102c6c:	e8 0f 21 00 00       	call   80104d80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c71:	8b 0d c8 40 11 80    	mov    0x801140c8,%ecx
80102c77:	83 c4 10             	add    $0x10,%esp
80102c7a:	85 c9                	test   %ecx,%ecx
80102c7c:	0f 8e 85 00 00 00    	jle    80102d07 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c82:	a1 b4 40 11 80       	mov    0x801140b4,%eax
80102c87:	83 ec 08             	sub    $0x8,%esp
80102c8a:	01 d8                	add    %ebx,%eax
80102c8c:	83 c0 01             	add    $0x1,%eax
80102c8f:	50                   	push   %eax
80102c90:	ff 35 c4 40 11 80    	pushl  0x801140c4
80102c96:	e8 35 d4 ff ff       	call   801000d0 <bread>
80102c9b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c9d:	58                   	pop    %eax
80102c9e:	5a                   	pop    %edx
80102c9f:	ff 34 9d cc 40 11 80 	pushl  -0x7feebf34(,%ebx,4)
80102ca6:	ff 35 c4 40 11 80    	pushl  0x801140c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cac:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102caf:	e8 1c d4 ff ff       	call   801000d0 <bread>
80102cb4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cb6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102cb9:	83 c4 0c             	add    $0xc,%esp
80102cbc:	68 00 02 00 00       	push   $0x200
80102cc1:	50                   	push   %eax
80102cc2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cc5:	50                   	push   %eax
80102cc6:	e8 b5 21 00 00       	call   80104e80 <memmove>
    bwrite(to);  // write the log
80102ccb:	89 34 24             	mov    %esi,(%esp)
80102cce:	e8 cd d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cd3:	89 3c 24             	mov    %edi,(%esp)
80102cd6:	e8 05 d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102cdb:	89 34 24             	mov    %esi,(%esp)
80102cde:	e8 fd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ce3:	83 c4 10             	add    $0x10,%esp
80102ce6:	3b 1d c8 40 11 80    	cmp    0x801140c8,%ebx
80102cec:	7c 94                	jl     80102c82 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cee:	e8 bd fd ff ff       	call   80102ab0 <write_head>
    install_trans(); // Now install writes to home locations
80102cf3:	e8 18 fd ff ff       	call   80102a10 <install_trans>
    log.lh.n = 0;
80102cf8:	c7 05 c8 40 11 80 00 	movl   $0x0,0x801140c8
80102cff:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d02:	e8 a9 fd ff ff       	call   80102ab0 <write_head>
    acquire(&log.lock);
80102d07:	83 ec 0c             	sub    $0xc,%esp
80102d0a:	68 80 40 11 80       	push   $0x80114080
80102d0f:	e8 ac 1f 00 00       	call   80104cc0 <acquire>
    wakeup(&log);
80102d14:	c7 04 24 80 40 11 80 	movl   $0x80114080,(%esp)
    log.committing = 0;
80102d1b:	c7 05 c0 40 11 80 00 	movl   $0x0,0x801140c0
80102d22:	00 00 00 
    wakeup(&log);
80102d25:	e8 06 19 00 00       	call   80104630 <wakeup>
    release(&log.lock);
80102d2a:	c7 04 24 80 40 11 80 	movl   $0x80114080,(%esp)
80102d31:	e8 4a 20 00 00       	call   80104d80 <release>
80102d36:	83 c4 10             	add    $0x10,%esp
}
80102d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d3c:	5b                   	pop    %ebx
80102d3d:	5e                   	pop    %esi
80102d3e:	5f                   	pop    %edi
80102d3f:	5d                   	pop    %ebp
80102d40:	c3                   	ret    
80102d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d48:	83 ec 0c             	sub    $0xc,%esp
80102d4b:	68 80 40 11 80       	push   $0x80114080
80102d50:	e8 db 18 00 00       	call   80104630 <wakeup>
  release(&log.lock);
80102d55:	c7 04 24 80 40 11 80 	movl   $0x80114080,(%esp)
80102d5c:	e8 1f 20 00 00       	call   80104d80 <release>
80102d61:	83 c4 10             	add    $0x10,%esp
}
80102d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d67:	5b                   	pop    %ebx
80102d68:	5e                   	pop    %esi
80102d69:	5f                   	pop    %edi
80102d6a:	5d                   	pop    %ebp
80102d6b:	c3                   	ret    
    panic("log.committing");
80102d6c:	83 ec 0c             	sub    $0xc,%esp
80102d6f:	68 44 7e 10 80       	push   $0x80107e44
80102d74:	e8 17 d6 ff ff       	call   80100390 <panic>
80102d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d80 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d87:	8b 15 c8 40 11 80    	mov    0x801140c8,%edx
{
80102d8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d90:	83 fa 1d             	cmp    $0x1d,%edx
80102d93:	0f 8f 9d 00 00 00    	jg     80102e36 <log_write+0xb6>
80102d99:	a1 b8 40 11 80       	mov    0x801140b8,%eax
80102d9e:	83 e8 01             	sub    $0x1,%eax
80102da1:	39 c2                	cmp    %eax,%edx
80102da3:	0f 8d 8d 00 00 00    	jge    80102e36 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102da9:	a1 bc 40 11 80       	mov    0x801140bc,%eax
80102dae:	85 c0                	test   %eax,%eax
80102db0:	0f 8e 8d 00 00 00    	jle    80102e43 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	68 80 40 11 80       	push   $0x80114080
80102dbe:	e8 fd 1e 00 00       	call   80104cc0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102dc3:	8b 0d c8 40 11 80    	mov    0x801140c8,%ecx
80102dc9:	83 c4 10             	add    $0x10,%esp
80102dcc:	83 f9 00             	cmp    $0x0,%ecx
80102dcf:	7e 57                	jle    80102e28 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dd1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102dd4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102dd6:	3b 15 cc 40 11 80    	cmp    0x801140cc,%edx
80102ddc:	75 0b                	jne    80102de9 <log_write+0x69>
80102dde:	eb 38                	jmp    80102e18 <log_write+0x98>
80102de0:	39 14 85 cc 40 11 80 	cmp    %edx,-0x7feebf34(,%eax,4)
80102de7:	74 2f                	je     80102e18 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102de9:	83 c0 01             	add    $0x1,%eax
80102dec:	39 c1                	cmp    %eax,%ecx
80102dee:	75 f0                	jne    80102de0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102df0:	89 14 85 cc 40 11 80 	mov    %edx,-0x7feebf34(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102df7:	83 c0 01             	add    $0x1,%eax
80102dfa:	a3 c8 40 11 80       	mov    %eax,0x801140c8
  b->flags |= B_DIRTY; // prevent eviction
80102dff:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e02:	c7 45 08 80 40 11 80 	movl   $0x80114080,0x8(%ebp)
}
80102e09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e0c:	c9                   	leave  
  release(&log.lock);
80102e0d:	e9 6e 1f 00 00       	jmp    80104d80 <release>
80102e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e18:	89 14 85 cc 40 11 80 	mov    %edx,-0x7feebf34(,%eax,4)
80102e1f:	eb de                	jmp    80102dff <log_write+0x7f>
80102e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e28:	8b 43 08             	mov    0x8(%ebx),%eax
80102e2b:	a3 cc 40 11 80       	mov    %eax,0x801140cc
  if (i == log.lh.n)
80102e30:	75 cd                	jne    80102dff <log_write+0x7f>
80102e32:	31 c0                	xor    %eax,%eax
80102e34:	eb c1                	jmp    80102df7 <log_write+0x77>
    panic("too big a transaction");
80102e36:	83 ec 0c             	sub    $0xc,%esp
80102e39:	68 53 7e 10 80       	push   $0x80107e53
80102e3e:	e8 4d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e43:	83 ec 0c             	sub    $0xc,%esp
80102e46:	68 69 7e 10 80       	push   $0x80107e69
80102e4b:	e8 40 d5 ff ff       	call   80100390 <panic>

80102e50 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e57:	e8 74 0f 00 00       	call   80103dd0 <cpuid>
80102e5c:	89 c3                	mov    %eax,%ebx
80102e5e:	e8 6d 0f 00 00       	call   80103dd0 <cpuid>
80102e63:	83 ec 04             	sub    $0x4,%esp
80102e66:	53                   	push   %ebx
80102e67:	50                   	push   %eax
80102e68:	68 84 7e 10 80       	push   $0x80107e84
80102e6d:	e8 ee d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e72:	e8 39 33 00 00       	call   801061b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e77:	e8 d4 0e 00 00       	call   80103d50 <mycpu>
80102e7c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e7e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e83:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e8a:	e8 21 12 00 00       	call   801040b0 <scheduler>
80102e8f:	90                   	nop

80102e90 <mpenter>:
{
80102e90:	55                   	push   %ebp
80102e91:	89 e5                	mov    %esp,%ebp
80102e93:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e96:	e8 05 44 00 00       	call   801072a0 <switchkvm>
  seginit();
80102e9b:	e8 70 43 00 00       	call   80107210 <seginit>
  lapicinit();
80102ea0:	e8 9b f7 ff ff       	call   80102640 <lapicinit>
  mpmain();
80102ea5:	e8 a6 ff ff ff       	call   80102e50 <mpmain>
80102eaa:	66 90                	xchg   %ax,%ax
80102eac:	66 90                	xchg   %ax,%ax
80102eae:	66 90                	xchg   %ax,%ax

80102eb0 <main>:
{
80102eb0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102eb4:	83 e4 f0             	and    $0xfffffff0,%esp
80102eb7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eba:	55                   	push   %ebp
80102ebb:	89 e5                	mov    %esp,%ebp
80102ebd:	53                   	push   %ebx
80102ebe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ebf:	83 ec 08             	sub    $0x8,%esp
80102ec2:	68 00 00 40 80       	push   $0x80400000
80102ec7:	68 a8 c0 11 80       	push   $0x8011c0a8
80102ecc:	e8 2f f5 ff ff       	call   80102400 <kinit1>
  kvmalloc();      // kernel page table
80102ed1:	e8 9a 48 00 00       	call   80107770 <kvmalloc>
  mpinit();        // detect other processors
80102ed6:	e8 75 01 00 00       	call   80103050 <mpinit>
  lapicinit();     // interrupt controller
80102edb:	e8 60 f7 ff ff       	call   80102640 <lapicinit>
  seginit();       // segment descriptors
80102ee0:	e8 2b 43 00 00       	call   80107210 <seginit>
  picinit();       // disable pic
80102ee5:	e8 46 03 00 00       	call   80103230 <picinit>
  ioapicinit();    // another interrupt controller
80102eea:	e8 41 f3 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
80102eef:	e8 cc da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102ef4:	e8 e7 35 00 00       	call   801064e0 <uartinit>
  pinit();         // process table
80102ef9:	e8 02 0e 00 00       	call   80103d00 <pinit>
  tvinit();        // trap vectors
80102efe:	e8 2d 32 00 00       	call   80106130 <tvinit>
  binit();         // buffer cache
80102f03:	e8 38 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f08:	e8 53 de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102f0d:	e8 fe f0 ff ff       	call   80102010 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f12:	83 c4 0c             	add    $0xc,%esp
80102f15:	68 8a 00 00 00       	push   $0x8a
80102f1a:	68 8c b4 10 80       	push   $0x8010b48c
80102f1f:	68 00 70 00 80       	push   $0x80007000
80102f24:	e8 57 1f 00 00       	call   80104e80 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f29:	69 05 00 47 11 80 b0 	imul   $0xb0,0x80114700,%eax
80102f30:	00 00 00 
80102f33:	83 c4 10             	add    $0x10,%esp
80102f36:	05 80 41 11 80       	add    $0x80114180,%eax
80102f3b:	3d 80 41 11 80       	cmp    $0x80114180,%eax
80102f40:	76 71                	jbe    80102fb3 <main+0x103>
80102f42:	bb 80 41 11 80       	mov    $0x80114180,%ebx
80102f47:	89 f6                	mov    %esi,%esi
80102f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f50:	e8 fb 0d 00 00       	call   80103d50 <mycpu>
80102f55:	39 d8                	cmp    %ebx,%eax
80102f57:	74 41                	je     80102f9a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f59:	e8 72 f5 ff ff       	call   801024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f5e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f63:	c7 05 f8 6f 00 80 90 	movl   $0x80102e90,0x80006ff8
80102f6a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f6d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102f74:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f77:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102f7c:	0f b6 03             	movzbl (%ebx),%eax
80102f7f:	83 ec 08             	sub    $0x8,%esp
80102f82:	68 00 70 00 00       	push   $0x7000
80102f87:	50                   	push   %eax
80102f88:	e8 03 f8 ff ff       	call   80102790 <lapicstartap>
80102f8d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f90:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f96:	85 c0                	test   %eax,%eax
80102f98:	74 f6                	je     80102f90 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f9a:	69 05 00 47 11 80 b0 	imul   $0xb0,0x80114700,%eax
80102fa1:	00 00 00 
80102fa4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102faa:	05 80 41 11 80       	add    $0x80114180,%eax
80102faf:	39 c3                	cmp    %eax,%ebx
80102fb1:	72 9d                	jb     80102f50 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fb3:	83 ec 08             	sub    $0x8,%esp
80102fb6:	68 00 00 00 8e       	push   $0x8e000000
80102fbb:	68 00 00 40 80       	push   $0x80400000
80102fc0:	e8 ab f4 ff ff       	call   80102470 <kinit2>
  userinit();      // first user process
80102fc5:	e8 56 0e 00 00       	call   80103e20 <userinit>
  mpmain();        // finish this processor's setup
80102fca:	e8 81 fe ff ff       	call   80102e50 <mpmain>
80102fcf:	90                   	nop

80102fd0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	57                   	push   %edi
80102fd4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102fd5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102fdb:	53                   	push   %ebx
  e = addr+len;
80102fdc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102fdf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102fe2:	39 de                	cmp    %ebx,%esi
80102fe4:	72 10                	jb     80102ff6 <mpsearch1+0x26>
80102fe6:	eb 50                	jmp    80103038 <mpsearch1+0x68>
80102fe8:	90                   	nop
80102fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ff0:	39 fb                	cmp    %edi,%ebx
80102ff2:	89 fe                	mov    %edi,%esi
80102ff4:	76 42                	jbe    80103038 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102ff6:	83 ec 04             	sub    $0x4,%esp
80102ff9:	8d 7e 10             	lea    0x10(%esi),%edi
80102ffc:	6a 04                	push   $0x4
80102ffe:	68 98 7e 10 80       	push   $0x80107e98
80103003:	56                   	push   %esi
80103004:	e8 17 1e 00 00       	call   80104e20 <memcmp>
80103009:	83 c4 10             	add    $0x10,%esp
8010300c:	85 c0                	test   %eax,%eax
8010300e:	75 e0                	jne    80102ff0 <mpsearch1+0x20>
80103010:	89 f1                	mov    %esi,%ecx
80103012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103018:	0f b6 11             	movzbl (%ecx),%edx
8010301b:	83 c1 01             	add    $0x1,%ecx
8010301e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103020:	39 f9                	cmp    %edi,%ecx
80103022:	75 f4                	jne    80103018 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103024:	84 c0                	test   %al,%al
80103026:	75 c8                	jne    80102ff0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302b:	89 f0                	mov    %esi,%eax
8010302d:	5b                   	pop    %ebx
8010302e:	5e                   	pop    %esi
8010302f:	5f                   	pop    %edi
80103030:	5d                   	pop    %ebp
80103031:	c3                   	ret    
80103032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103038:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010303b:	31 f6                	xor    %esi,%esi
}
8010303d:	89 f0                	mov    %esi,%eax
8010303f:	5b                   	pop    %ebx
80103040:	5e                   	pop    %esi
80103041:	5f                   	pop    %edi
80103042:	5d                   	pop    %ebp
80103043:	c3                   	ret    
80103044:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010304a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103050 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
80103055:	53                   	push   %ebx
80103056:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103059:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103060:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103067:	c1 e0 08             	shl    $0x8,%eax
8010306a:	09 d0                	or     %edx,%eax
8010306c:	c1 e0 04             	shl    $0x4,%eax
8010306f:	85 c0                	test   %eax,%eax
80103071:	75 1b                	jne    8010308e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103073:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010307a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103081:	c1 e0 08             	shl    $0x8,%eax
80103084:	09 d0                	or     %edx,%eax
80103086:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103089:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010308e:	ba 00 04 00 00       	mov    $0x400,%edx
80103093:	e8 38 ff ff ff       	call   80102fd0 <mpsearch1>
80103098:	85 c0                	test   %eax,%eax
8010309a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010309d:	0f 84 3d 01 00 00    	je     801031e0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030a6:	8b 58 04             	mov    0x4(%eax),%ebx
801030a9:	85 db                	test   %ebx,%ebx
801030ab:	0f 84 4f 01 00 00    	je     80103200 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030b1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030b7:	83 ec 04             	sub    $0x4,%esp
801030ba:	6a 04                	push   $0x4
801030bc:	68 b5 7e 10 80       	push   $0x80107eb5
801030c1:	56                   	push   %esi
801030c2:	e8 59 1d 00 00       	call   80104e20 <memcmp>
801030c7:	83 c4 10             	add    $0x10,%esp
801030ca:	85 c0                	test   %eax,%eax
801030cc:	0f 85 2e 01 00 00    	jne    80103200 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801030d2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801030d9:	3c 01                	cmp    $0x1,%al
801030db:	0f 95 c2             	setne  %dl
801030de:	3c 04                	cmp    $0x4,%al
801030e0:	0f 95 c0             	setne  %al
801030e3:	20 c2                	and    %al,%dl
801030e5:	0f 85 15 01 00 00    	jne    80103200 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801030eb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801030f2:	66 85 ff             	test   %di,%di
801030f5:	74 1a                	je     80103111 <mpinit+0xc1>
801030f7:	89 f0                	mov    %esi,%eax
801030f9:	01 f7                	add    %esi,%edi
  sum = 0;
801030fb:	31 d2                	xor    %edx,%edx
801030fd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103100:	0f b6 08             	movzbl (%eax),%ecx
80103103:	83 c0 01             	add    $0x1,%eax
80103106:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103108:	39 c7                	cmp    %eax,%edi
8010310a:	75 f4                	jne    80103100 <mpinit+0xb0>
8010310c:	84 d2                	test   %dl,%dl
8010310e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103111:	85 f6                	test   %esi,%esi
80103113:	0f 84 e7 00 00 00    	je     80103200 <mpinit+0x1b0>
80103119:	84 d2                	test   %dl,%dl
8010311b:	0f 85 df 00 00 00    	jne    80103200 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103121:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103127:	a3 7c 40 11 80       	mov    %eax,0x8011407c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010312c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103133:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103139:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010313e:	01 d6                	add    %edx,%esi
80103140:	39 c6                	cmp    %eax,%esi
80103142:	76 23                	jbe    80103167 <mpinit+0x117>
    switch(*p){
80103144:	0f b6 10             	movzbl (%eax),%edx
80103147:	80 fa 04             	cmp    $0x4,%dl
8010314a:	0f 87 ca 00 00 00    	ja     8010321a <mpinit+0x1ca>
80103150:	ff 24 95 dc 7e 10 80 	jmp    *-0x7fef8124(,%edx,4)
80103157:	89 f6                	mov    %esi,%esi
80103159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103160:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103163:	39 c6                	cmp    %eax,%esi
80103165:	77 dd                	ja     80103144 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103167:	85 db                	test   %ebx,%ebx
80103169:	0f 84 9e 00 00 00    	je     8010320d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010316f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103172:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103176:	74 15                	je     8010318d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103178:	b8 70 00 00 00       	mov    $0x70,%eax
8010317d:	ba 22 00 00 00       	mov    $0x22,%edx
80103182:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103183:	ba 23 00 00 00       	mov    $0x23,%edx
80103188:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103189:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010318c:	ee                   	out    %al,(%dx)
  }
}
8010318d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103190:	5b                   	pop    %ebx
80103191:	5e                   	pop    %esi
80103192:	5f                   	pop    %edi
80103193:	5d                   	pop    %ebp
80103194:	c3                   	ret    
80103195:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103198:	8b 0d 00 47 11 80    	mov    0x80114700,%ecx
8010319e:	83 f9 07             	cmp    $0x7,%ecx
801031a1:	7f 19                	jg     801031bc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031a3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031a7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031ad:	83 c1 01             	add    $0x1,%ecx
801031b0:	89 0d 00 47 11 80    	mov    %ecx,0x80114700
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031b6:	88 97 80 41 11 80    	mov    %dl,-0x7feebe80(%edi)
      p += sizeof(struct mpproc);
801031bc:	83 c0 14             	add    $0x14,%eax
      continue;
801031bf:	e9 7c ff ff ff       	jmp    80103140 <mpinit+0xf0>
801031c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031c8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031cc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031cf:	88 15 60 41 11 80    	mov    %dl,0x80114160
      continue;
801031d5:	e9 66 ff ff ff       	jmp    80103140 <mpinit+0xf0>
801031da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801031e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801031e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801031ea:	e8 e1 fd ff ff       	call   80102fd0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031ef:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801031f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031f4:	0f 85 a9 fe ff ff    	jne    801030a3 <mpinit+0x53>
801031fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103200:	83 ec 0c             	sub    $0xc,%esp
80103203:	68 9d 7e 10 80       	push   $0x80107e9d
80103208:	e8 83 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010320d:	83 ec 0c             	sub    $0xc,%esp
80103210:	68 bc 7e 10 80       	push   $0x80107ebc
80103215:	e8 76 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010321a:	31 db                	xor    %ebx,%ebx
8010321c:	e9 26 ff ff ff       	jmp    80103147 <mpinit+0xf7>
80103221:	66 90                	xchg   %ax,%ax
80103223:	66 90                	xchg   %ax,%ax
80103225:	66 90                	xchg   %ax,%ax
80103227:	66 90                	xchg   %ax,%ax
80103229:	66 90                	xchg   %ax,%ax
8010322b:	66 90                	xchg   %ax,%ax
8010322d:	66 90                	xchg   %ax,%ax
8010322f:	90                   	nop

80103230 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103230:	55                   	push   %ebp
80103231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103236:	ba 21 00 00 00       	mov    $0x21,%edx
8010323b:	89 e5                	mov    %esp,%ebp
8010323d:	ee                   	out    %al,(%dx)
8010323e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103243:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103244:	5d                   	pop    %ebp
80103245:	c3                   	ret    
80103246:	66 90                	xchg   %ax,%ax
80103248:	66 90                	xchg   %ax,%ax
8010324a:	66 90                	xchg   %ax,%ax
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 0c             	sub    $0xc,%esp
80103259:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010325c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010325f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103265:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010326b:	e8 10 db ff ff       	call   80100d80 <filealloc>
80103270:	85 c0                	test   %eax,%eax
80103272:	89 03                	mov    %eax,(%ebx)
80103274:	74 22                	je     80103298 <pipealloc+0x48>
80103276:	e8 05 db ff ff       	call   80100d80 <filealloc>
8010327b:	85 c0                	test   %eax,%eax
8010327d:	89 06                	mov    %eax,(%esi)
8010327f:	74 3f                	je     801032c0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103281:	e8 4a f2 ff ff       	call   801024d0 <kalloc>
80103286:	85 c0                	test   %eax,%eax
80103288:	89 c7                	mov    %eax,%edi
8010328a:	75 54                	jne    801032e0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010328c:	8b 03                	mov    (%ebx),%eax
8010328e:	85 c0                	test   %eax,%eax
80103290:	75 34                	jne    801032c6 <pipealloc+0x76>
80103292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103298:	8b 06                	mov    (%esi),%eax
8010329a:	85 c0                	test   %eax,%eax
8010329c:	74 0c                	je     801032aa <pipealloc+0x5a>
    fileclose(*f1);
8010329e:	83 ec 0c             	sub    $0xc,%esp
801032a1:	50                   	push   %eax
801032a2:	e8 99 db ff ff       	call   80100e40 <fileclose>
801032a7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032b2:	5b                   	pop    %ebx
801032b3:	5e                   	pop    %esi
801032b4:	5f                   	pop    %edi
801032b5:	5d                   	pop    %ebp
801032b6:	c3                   	ret    
801032b7:	89 f6                	mov    %esi,%esi
801032b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032c0:	8b 03                	mov    (%ebx),%eax
801032c2:	85 c0                	test   %eax,%eax
801032c4:	74 e4                	je     801032aa <pipealloc+0x5a>
    fileclose(*f0);
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	50                   	push   %eax
801032ca:	e8 71 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
801032cf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801032d1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032d4:	85 c0                	test   %eax,%eax
801032d6:	75 c6                	jne    8010329e <pipealloc+0x4e>
801032d8:	eb d0                	jmp    801032aa <pipealloc+0x5a>
801032da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801032e0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801032e3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801032ea:	00 00 00 
  p->writeopen = 1;
801032ed:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801032f4:	00 00 00 
  p->nwrite = 0;
801032f7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801032fe:	00 00 00 
  p->nread = 0;
80103301:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103308:	00 00 00 
  initlock(&p->lock, "pipe");
8010330b:	68 f0 7e 10 80       	push   $0x80107ef0
80103310:	50                   	push   %eax
80103311:	e8 6a 18 00 00       	call   80104b80 <initlock>
  (*f0)->type = FD_PIPE;
80103316:	8b 03                	mov    (%ebx),%eax
  return 0;
80103318:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010331b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103321:	8b 03                	mov    (%ebx),%eax
80103323:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103327:	8b 03                	mov    (%ebx),%eax
80103329:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010332d:	8b 03                	mov    (%ebx),%eax
8010332f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103332:	8b 06                	mov    (%esi),%eax
80103334:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010333a:	8b 06                	mov    (%esi),%eax
8010333c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103340:	8b 06                	mov    (%esi),%eax
80103342:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103346:	8b 06                	mov    (%esi),%eax
80103348:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010334b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010334e:	31 c0                	xor    %eax,%eax
}
80103350:	5b                   	pop    %ebx
80103351:	5e                   	pop    %esi
80103352:	5f                   	pop    %edi
80103353:	5d                   	pop    %ebp
80103354:	c3                   	ret    
80103355:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103360 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	56                   	push   %esi
80103364:	53                   	push   %ebx
80103365:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103368:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010336b:	83 ec 0c             	sub    $0xc,%esp
8010336e:	53                   	push   %ebx
8010336f:	e8 4c 19 00 00       	call   80104cc0 <acquire>
  if(writable){
80103374:	83 c4 10             	add    $0x10,%esp
80103377:	85 f6                	test   %esi,%esi
80103379:	74 45                	je     801033c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010337b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103381:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103384:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010338b:	00 00 00 
    wakeup(&p->nread);
8010338e:	50                   	push   %eax
8010338f:	e8 9c 12 00 00       	call   80104630 <wakeup>
80103394:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103397:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010339d:	85 d2                	test   %edx,%edx
8010339f:	75 0a                	jne    801033ab <pipeclose+0x4b>
801033a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033a7:	85 c0                	test   %eax,%eax
801033a9:	74 35                	je     801033e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033b1:	5b                   	pop    %ebx
801033b2:	5e                   	pop    %esi
801033b3:	5d                   	pop    %ebp
    release(&p->lock);
801033b4:	e9 c7 19 00 00       	jmp    80104d80 <release>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033c6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801033d0:	00 00 00 
    wakeup(&p->nwrite);
801033d3:	50                   	push   %eax
801033d4:	e8 57 12 00 00       	call   80104630 <wakeup>
801033d9:	83 c4 10             	add    $0x10,%esp
801033dc:	eb b9                	jmp    80103397 <pipeclose+0x37>
801033de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	53                   	push   %ebx
801033e4:	e8 97 19 00 00       	call   80104d80 <release>
    kfree((char*)p);
801033e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801033ec:	83 c4 10             	add    $0x10,%esp
}
801033ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033f2:	5b                   	pop    %ebx
801033f3:	5e                   	pop    %esi
801033f4:	5d                   	pop    %ebp
    kfree((char*)p);
801033f5:	e9 26 ef ff ff       	jmp    80102320 <kfree>
801033fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103400 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 28             	sub    $0x28,%esp
80103409:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010340c:	53                   	push   %ebx
8010340d:	e8 ae 18 00 00       	call   80104cc0 <acquire>
  for(i = 0; i < n; i++){
80103412:	8b 45 10             	mov    0x10(%ebp),%eax
80103415:	83 c4 10             	add    $0x10,%esp
80103418:	85 c0                	test   %eax,%eax
8010341a:	0f 8e c9 00 00 00    	jle    801034e9 <pipewrite+0xe9>
80103420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103423:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103429:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010342f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103432:	03 4d 10             	add    0x10(%ebp),%ecx
80103435:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103438:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010343e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103444:	39 d0                	cmp    %edx,%eax
80103446:	75 71                	jne    801034b9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103448:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010344e:	85 c0                	test   %eax,%eax
80103450:	74 4e                	je     801034a0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103452:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103458:	eb 3a                	jmp    80103494 <pipewrite+0x94>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103460:	83 ec 0c             	sub    $0xc,%esp
80103463:	57                   	push   %edi
80103464:	e8 c7 11 00 00       	call   80104630 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103469:	5a                   	pop    %edx
8010346a:	59                   	pop    %ecx
8010346b:	53                   	push   %ebx
8010346c:	56                   	push   %esi
8010346d:	e8 fe 0f 00 00       	call   80104470 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103472:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103478:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010347e:	83 c4 10             	add    $0x10,%esp
80103481:	05 00 02 00 00       	add    $0x200,%eax
80103486:	39 c2                	cmp    %eax,%edx
80103488:	75 36                	jne    801034c0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010348a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103490:	85 c0                	test   %eax,%eax
80103492:	74 0c                	je     801034a0 <pipewrite+0xa0>
80103494:	e8 57 09 00 00       	call   80103df0 <myproc>
80103499:	8b 40 24             	mov    0x24(%eax),%eax
8010349c:	85 c0                	test   %eax,%eax
8010349e:	74 c0                	je     80103460 <pipewrite+0x60>
        release(&p->lock);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	53                   	push   %ebx
801034a4:	e8 d7 18 00 00       	call   80104d80 <release>
        return -1;
801034a9:	83 c4 10             	add    $0x10,%esp
801034ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034b4:	5b                   	pop    %ebx
801034b5:	5e                   	pop    %esi
801034b6:	5f                   	pop    %edi
801034b7:	5d                   	pop    %ebp
801034b8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034b9:	89 c2                	mov    %eax,%edx
801034bb:	90                   	nop
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034c0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034c3:	8d 42 01             	lea    0x1(%edx),%eax
801034c6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034cc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801034d2:	83 c6 01             	add    $0x1,%esi
801034d5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801034d9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801034dc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034df:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801034e3:	0f 85 4f ff ff ff    	jne    80103438 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801034e9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801034ef:	83 ec 0c             	sub    $0xc,%esp
801034f2:	50                   	push   %eax
801034f3:	e8 38 11 00 00       	call   80104630 <wakeup>
  release(&p->lock);
801034f8:	89 1c 24             	mov    %ebx,(%esp)
801034fb:	e8 80 18 00 00       	call   80104d80 <release>
  return n;
80103500:	83 c4 10             	add    $0x10,%esp
80103503:	8b 45 10             	mov    0x10(%ebp),%eax
80103506:	eb a9                	jmp    801034b1 <pipewrite+0xb1>
80103508:	90                   	nop
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103510 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	57                   	push   %edi
80103514:	56                   	push   %esi
80103515:	53                   	push   %ebx
80103516:	83 ec 18             	sub    $0x18,%esp
80103519:	8b 75 08             	mov    0x8(%ebp),%esi
8010351c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010351f:	56                   	push   %esi
80103520:	e8 9b 17 00 00       	call   80104cc0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103525:	83 c4 10             	add    $0x10,%esp
80103528:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010352e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103534:	75 6a                	jne    801035a0 <piperead+0x90>
80103536:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010353c:	85 db                	test   %ebx,%ebx
8010353e:	0f 84 c4 00 00 00    	je     80103608 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103544:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010354a:	eb 2d                	jmp    80103579 <piperead+0x69>
8010354c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103550:	83 ec 08             	sub    $0x8,%esp
80103553:	56                   	push   %esi
80103554:	53                   	push   %ebx
80103555:	e8 16 0f 00 00       	call   80104470 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010355a:	83 c4 10             	add    $0x10,%esp
8010355d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103563:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103569:	75 35                	jne    801035a0 <piperead+0x90>
8010356b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103571:	85 d2                	test   %edx,%edx
80103573:	0f 84 8f 00 00 00    	je     80103608 <piperead+0xf8>
    if(myproc()->killed){
80103579:	e8 72 08 00 00       	call   80103df0 <myproc>
8010357e:	8b 48 24             	mov    0x24(%eax),%ecx
80103581:	85 c9                	test   %ecx,%ecx
80103583:	74 cb                	je     80103550 <piperead+0x40>
      release(&p->lock);
80103585:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103588:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010358d:	56                   	push   %esi
8010358e:	e8 ed 17 00 00       	call   80104d80 <release>
      return -1;
80103593:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103596:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103599:	89 d8                	mov    %ebx,%eax
8010359b:	5b                   	pop    %ebx
8010359c:	5e                   	pop    %esi
8010359d:	5f                   	pop    %edi
8010359e:	5d                   	pop    %ebp
8010359f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035a0:	8b 45 10             	mov    0x10(%ebp),%eax
801035a3:	85 c0                	test   %eax,%eax
801035a5:	7e 61                	jle    80103608 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035a7:	31 db                	xor    %ebx,%ebx
801035a9:	eb 13                	jmp    801035be <piperead+0xae>
801035ab:	90                   	nop
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035b6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035bc:	74 1f                	je     801035dd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035be:	8d 41 01             	lea    0x1(%ecx),%eax
801035c1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035c7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035cd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801035d2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d5:	83 c3 01             	add    $0x1,%ebx
801035d8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801035db:	75 d3                	jne    801035b0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801035dd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801035e3:	83 ec 0c             	sub    $0xc,%esp
801035e6:	50                   	push   %eax
801035e7:	e8 44 10 00 00       	call   80104630 <wakeup>
  release(&p->lock);
801035ec:	89 34 24             	mov    %esi,(%esp)
801035ef:	e8 8c 17 00 00       	call   80104d80 <release>
  return i;
801035f4:	83 c4 10             	add    $0x10,%esp
}
801035f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035fa:	89 d8                	mov    %ebx,%eax
801035fc:	5b                   	pop    %ebx
801035fd:	5e                   	pop    %esi
801035fe:	5f                   	pop    %edi
801035ff:	5d                   	pop    %ebp
80103600:	c3                   	ret    
80103601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103608:	31 db                	xor    %ebx,%ebx
8010360a:	eb d1                	jmp    801035dd <piperead+0xcd>
8010360c:	66 90                	xchg   %ax,%ax
8010360e:	66 90                	xchg   %ax,%ax

80103610 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103614:	bb 54 7e 11 80       	mov    $0x80117e54,%ebx
{
80103619:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010361c:	68 20 7e 11 80       	push   $0x80117e20
80103621:	e8 9a 16 00 00       	call   80104cc0 <acquire>
80103626:	83 c4 10             	add    $0x10,%esp
80103629:	eb 17                	jmp    80103642 <allocproc+0x32>
8010362b:	90                   	nop
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103630:	81 c3 e8 00 00 00    	add    $0xe8,%ebx
80103636:	81 fb 54 b8 11 80    	cmp    $0x8011b854,%ebx
8010363c:	0f 83 d1 00 00 00    	jae    80103713 <allocproc+0x103>
    if(p->state == UNUSED)
80103642:	8b 43 0c             	mov    0xc(%ebx),%eax
80103645:	85 c0                	test   %eax,%eax
80103647:	75 e7                	jne    80103630 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103649:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->state = EMBRYO;
8010364e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103655:	8d 50 01             	lea    0x1(%eax),%edx
80103658:	89 43 10             	mov    %eax,0x10(%ebx)
  init_syscalls_count(p->syscall_count);
8010365b:	8d 43 7c             	lea    0x7c(%ebx),%eax
  p->pid = nextpid++;
8010365e:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80103664:	8d 93 d8 00 00 00    	lea    0xd8(%ebx),%edx
8010366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sys_count[i]=0;
80103670:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103676:	83 c0 04             	add    $0x4,%eax
  for (int i=0 ; i<MAXSYSCALL ; i++)
80103679:	39 c2                	cmp    %eax,%edx
8010367b:	75 f3                	jne    80103670 <allocproc+0x60>

  release(&ptable.lock);
8010367d:	83 ec 0c             	sub    $0xc,%esp
80103680:	68 20 7e 11 80       	push   $0x80117e20
80103685:	e8 f6 16 00 00       	call   80104d80 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010368a:	e8 41 ee ff ff       	call   801024d0 <kalloc>
8010368f:	83 c4 10             	add    $0x10,%esp
80103692:	85 c0                	test   %eax,%eax
80103694:	89 43 08             	mov    %eax,0x8(%ebx)
80103697:	0f 84 8f 00 00 00    	je     8010372c <allocproc+0x11c>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010369d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036a3:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801036a6:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801036ab:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801036ae:	c7 40 14 1a 61 10 80 	movl   $0x8010611a,0x14(%eax)
  p->context = (struct context*)sp;
801036b5:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801036b8:	6a 14                	push   $0x14
801036ba:	6a 00                	push   $0x0
801036bc:	50                   	push   %eax
801036bd:	e8 0e 17 00 00       	call   80104dd0 <memset>
  p->context->eip = (uint)forkret;
801036c2:	8b 43 1c             	mov    0x1c(%ebx),%eax
801036c5:	c7 40 10 40 37 10 80 	movl   $0x80103740,0x10(%eax)
  p->ticket = 10;
801036cc:	c7 83 d8 00 00 00 0a 	movl   $0xa,0xd8(%ebx)
801036d3:	00 00 00 
  
  acquire(&tickslock);
801036d6:	c7 04 24 60 b8 11 80 	movl   $0x8011b860,(%esp)
801036dd:	e8 de 15 00 00       	call   80104cc0 <acquire>
  p->response_time = ticks;
801036e2:	a1 a0 c0 11 80       	mov    0x8011c0a0,%eax
  p->turn_around_time = ticks;
  p->serv=0;
801036e7:	c7 83 e4 00 00 00 00 	movl   $0x0,0xe4(%ebx)
801036ee:	00 00 00 
  p->response_time = ticks;
801036f1:	89 83 dc 00 00 00    	mov    %eax,0xdc(%ebx)
  p->turn_around_time = ticks;
801036f7:	89 83 e0 00 00 00    	mov    %eax,0xe0(%ebx)
  release(&tickslock);
801036fd:	c7 04 24 60 b8 11 80 	movl   $0x8011b860,(%esp)
80103704:	e8 77 16 00 00       	call   80104d80 <release>
  return p;
80103709:	83 c4 10             	add    $0x10,%esp
}
8010370c:	89 d8                	mov    %ebx,%eax
8010370e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103711:	c9                   	leave  
80103712:	c3                   	ret    
  release(&ptable.lock);
80103713:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103716:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103718:	68 20 7e 11 80       	push   $0x80117e20
8010371d:	e8 5e 16 00 00       	call   80104d80 <release>
}
80103722:	89 d8                	mov    %ebx,%eax
  return 0;
80103724:	83 c4 10             	add    $0x10,%esp
}
80103727:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010372a:	c9                   	leave  
8010372b:	c3                   	ret    
    p->state = UNUSED;
8010372c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103733:	31 db                	xor    %ebx,%ebx
80103735:	eb d5                	jmp    8010370c <allocproc+0xfc>
80103737:	89 f6                	mov    %esi,%esi
80103739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103740 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103746:	68 20 7e 11 80       	push   $0x80117e20
8010374b:	e8 30 16 00 00       	call   80104d80 <release>

  if (first) {
80103750:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	85 c0                	test   %eax,%eax
8010375a:	75 04                	jne    80103760 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010375c:	c9                   	leave  
8010375d:	c3                   	ret    
8010375e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103760:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103763:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010376a:	00 00 00 
    iinit(ROOTDEV);
8010376d:	6a 01                	push   $0x1
8010376f:	e8 1c dd ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103774:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010377b:	e8 90 f3 ff ff       	call   80102b10 <initlog>
80103780:	83 c4 10             	add    $0x10,%esp
}
80103783:	c9                   	leave  
80103784:	c3                   	ret    
80103785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103790 <getName>:

#include "syscall.h"

char* getName(int num)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	83 ec 08             	sub    $0x8,%esp
80103796:	8b 45 08             	mov    0x8(%ebp),%eax
  switch (num) {
80103799:	83 f8 17             	cmp    $0x17,%eax
8010379c:	0f 87 75 01 00 00    	ja     80103917 <getName+0x187>
801037a2:	ff 24 85 d4 80 10 80 	jmp    *-0x7fef7f2c(,%eax,4)
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      case SYS_invoked_syscalls:
        return("invoked_syscalls");
        break;
      case SYS_log_syscalls:
        return("log_syscalls");
801037b0:	b8 57 7f 10 80       	mov    $0x80107f57,%eax
      {
        panic("should never get here\n");
        return "";
      }
    }
801037b5:	c9                   	leave  
801037b6:	c3                   	ret    
801037b7:	89 f6                	mov    %esi,%esi
801037b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("invoked_syscalls");
801037c0:	b8 46 7f 10 80       	mov    $0x80107f46,%eax
801037c5:	c9                   	leave  
801037c6:	c3                   	ret    
801037c7:	89 f6                	mov    %esi,%esi
801037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("close");
801037d0:	b8 40 7a 10 80       	mov    $0x80107a40,%eax
801037d5:	c9                   	leave  
801037d6:	c3                   	ret    
801037d7:	89 f6                	mov    %esi,%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("mkdir");
801037e0:	b8 40 7f 10 80       	mov    $0x80107f40,%eax
801037e5:	c9                   	leave  
801037e6:	c3                   	ret    
801037e7:	89 f6                	mov    %esi,%esi
801037e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("link");
801037f0:	b8 3b 7f 10 80       	mov    $0x80107f3b,%eax
801037f5:	c9                   	leave  
801037f6:	c3                   	ret    
801037f7:	89 f6                	mov    %esi,%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("unlink");
80103800:	b8 39 7f 10 80       	mov    $0x80107f39,%eax
80103805:	c9                   	leave  
80103806:	c3                   	ret    
80103807:	89 f6                	mov    %esi,%esi
80103809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("mknod");
80103810:	b8 33 7f 10 80       	mov    $0x80107f33,%eax
80103815:	c9                   	leave  
80103816:	c3                   	ret    
80103817:	89 f6                	mov    %esi,%esi
80103819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("write");
80103820:	b8 c0 79 10 80       	mov    $0x801079c0,%eax
80103825:	c9                   	leave  
80103826:	c3                   	ret    
80103827:	89 f6                	mov    %esi,%esi
80103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("open");
80103830:	b8 2e 7f 10 80       	mov    $0x80107f2e,%eax
80103835:	c9                   	leave  
80103836:	c3                   	ret    
80103837:	89 f6                	mov    %esi,%esi
80103839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("uptime");
80103840:	b8 27 7f 10 80       	mov    $0x80107f27,%eax
80103845:	c9                   	leave  
80103846:	c3                   	ret    
80103847:	89 f6                	mov    %esi,%esi
80103849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("sleep");
80103850:	b8 21 7f 10 80       	mov    $0x80107f21,%eax
80103855:	c9                   	leave  
80103856:	c3                   	ret    
80103857:	89 f6                	mov    %esi,%esi
80103859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("sbrk");
80103860:	b8 1c 7f 10 80       	mov    $0x80107f1c,%eax
80103865:	c9                   	leave  
80103866:	c3                   	ret    
80103867:	89 f6                	mov    %esi,%esi
80103869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("getpid");
80103870:	b8 15 7f 10 80       	mov    $0x80107f15,%eax
80103875:	c9                   	leave  
80103876:	c3                   	ret    
80103877:	89 f6                	mov    %esi,%esi
80103879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("dup");
80103880:	b8 38 7a 10 80       	mov    $0x80107a38,%eax
80103885:	c9                   	leave  
80103886:	c3                   	ret    
80103887:	89 f6                	mov    %esi,%esi
80103889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("chdir");
80103890:	b8 0f 7f 10 80       	mov    $0x80107f0f,%eax
80103895:	c9                   	leave  
80103896:	c3                   	ret    
80103897:	89 f6                	mov    %esi,%esi
80103899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("fstat");
801038a0:	b8 09 7f 10 80       	mov    $0x80107f09,%eax
801038a5:	c9                   	leave  
801038a6:	c3                   	ret    
801038a7:	89 f6                	mov    %esi,%esi
801038a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("exec");
801038b0:	b8 04 7f 10 80       	mov    $0x80107f04,%eax
801038b5:	c9                   	leave  
801038b6:	c3                   	ret    
801038b7:	89 f6                	mov    %esi,%esi
801038b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("kill");
801038c0:	b8 ff 7e 10 80       	mov    $0x80107eff,%eax
801038c5:	c9                   	leave  
801038c6:	c3                   	ret    
801038c7:	89 f6                	mov    %esi,%esi
801038c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("read");
801038d0:	b8 10 7b 10 80       	mov    $0x80107b10,%eax
801038d5:	c9                   	leave  
801038d6:	c3                   	ret    
801038d7:	89 f6                	mov    %esi,%esi
801038d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("pipe");
801038e0:	b8 f0 7e 10 80       	mov    $0x80107ef0,%eax
801038e5:	c9                   	leave  
801038e6:	c3                   	ret    
801038e7:	89 f6                	mov    %esi,%esi
801038e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("wait");
801038f0:	b8 fa 7e 10 80       	mov    $0x80107efa,%eax
801038f5:	c9                   	leave  
801038f6:	c3                   	ret    
801038f7:	89 f6                	mov    %esi,%esi
801038f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("exit");
80103900:	b8 1b 80 10 80       	mov    $0x8010801b,%eax
80103905:	c9                   	leave  
80103906:	c3                   	ret    
80103907:	89 f6                	mov    %esi,%esi
80103909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return("fork");
80103910:	b8 f5 7e 10 80       	mov    $0x80107ef5,%eax
80103915:	c9                   	leave  
80103916:	c3                   	ret    
        panic("should never get here\n");
80103917:	83 ec 0c             	sub    $0xc,%esp
8010391a:	68 64 7f 10 80       	push   $0x80107f64
8010391f:	e8 6c ca ff ff       	call   80100390 <panic>
80103924:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010392a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103930 <sgenrand>:
static int mti=N+1; /* mti==N+1 means mt[N] is not initialized */

/* initializing the array with a NONZERO seed */
void
sgenrand(unsigned long seed)
{
80103930:	55                   	push   %ebp
80103931:	b8 e4 b5 10 80       	mov    $0x8010b5e4,%eax
80103936:	b9 9c bf 10 80       	mov    $0x8010bf9c,%ecx
8010393b:	89 e5                	mov    %esp,%ebp
8010393d:	8b 55 08             	mov    0x8(%ebp),%edx
    /* setting initial seeds to mt[N] using         */
    /* the generator Line 25 of Table 1 in          */
    /* [KNUTH 1981, The Art of Computer Programming */
    /*    Vol. 2 (2nd Ed.), pp102]                  */
    mt[0]= seed & 0xffffffff;
80103940:	89 15 e0 b5 10 80    	mov    %edx,0x8010b5e0
80103946:	eb 0b                	jmp    80103953 <sgenrand+0x23>
80103948:	90                   	nop
80103949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103950:	83 c0 04             	add    $0x4,%eax
    for (mti=1; mti<N; mti++)
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
80103953:	69 d2 cd 0d 01 00    	imul   $0x10dcd,%edx,%edx
    for (mti=1; mti<N; mti++)
80103959:	39 c1                	cmp    %eax,%ecx
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
8010395b:	89 10                	mov    %edx,(%eax)
    for (mti=1; mti<N; mti++)
8010395d:	75 f1                	jne    80103950 <sgenrand+0x20>
8010395f:	c7 05 08 b0 10 80 70 	movl   $0x270,0x8010b008
80103966:	02 00 00 
}
80103969:	5d                   	pop    %ebp
8010396a:	c3                   	ret    
8010396b:	90                   	nop
8010396c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103970 <genrand>:
{
    unsigned long y;
    static unsigned long mag01[2]={0x0, MATRIX_A};
    /* mag01[x] = x * MATRIX_A  for x=0,1 */

    if (mti >= N) { /* generate N words at one time */
80103970:	a1 08 b0 10 80       	mov    0x8010b008,%eax
{
80103975:	55                   	push   %ebp
80103976:	89 e5                	mov    %esp,%ebp
80103978:	56                   	push   %esi
80103979:	53                   	push   %ebx
    if (mti >= N) { /* generate N words at one time */
8010397a:	3d 6f 02 00 00       	cmp    $0x26f,%eax
8010397f:	0f 8e f9 00 00 00    	jle    80103a7e <genrand+0x10e>
        int kk;

        if (mti == N+1)   /* if sgenrand() has not been called, */
80103985:	3d 71 02 00 00       	cmp    $0x271,%eax
8010398a:	0f 84 fa 00 00 00    	je     80103a8a <genrand+0x11a>
80103990:	ba e0 b5 10 80       	mov    $0x8010b5e0,%edx
80103995:	bb 6c b9 10 80       	mov    $0x8010b96c,%ebx
    mt[0]= seed & 0xffffffff;
8010399a:	89 d1                	mov    %edx,%ecx
8010399c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            sgenrand(4357); /* a default initial seed is used   */

        for (kk=0;kk<N-M;kk++) {
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
801039a0:	8b 01                	mov    (%ecx),%eax
801039a2:	8b 71 04             	mov    0x4(%ecx),%esi
801039a5:	83 c1 04             	add    $0x4,%ecx
801039a8:	81 e6 ff ff ff 7f    	and    $0x7fffffff,%esi
801039ae:	25 00 00 00 80       	and    $0x80000000,%eax
801039b3:	09 f0                	or     %esi,%eax
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1];
801039b5:	89 c6                	mov    %eax,%esi
801039b7:	83 e0 01             	and    $0x1,%eax
801039ba:	d1 ee                	shr    %esi
801039bc:	33 b1 30 06 00 00    	xor    0x630(%ecx),%esi
801039c2:	33 34 85 4c 81 10 80 	xor    -0x7fef7eb4(,%eax,4),%esi
801039c9:	89 71 fc             	mov    %esi,-0x4(%ecx)
        for (kk=0;kk<N-M;kk++) {
801039cc:	39 cb                	cmp    %ecx,%ebx
801039ce:	75 d0                	jne    801039a0 <genrand+0x30>
801039d0:	b9 10 bc 10 80       	mov    $0x8010bc10,%ecx
801039d5:	8d 76 00             	lea    0x0(%esi),%esi
        }
        for (;kk<N-1;kk++) {
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK);
801039d8:	8b 82 8c 03 00 00    	mov    0x38c(%edx),%eax
801039de:	8b 9a 90 03 00 00    	mov    0x390(%edx),%ebx
801039e4:	83 c2 04             	add    $0x4,%edx
801039e7:	81 e3 ff ff ff 7f    	and    $0x7fffffff,%ebx
801039ed:	25 00 00 00 80       	and    $0x80000000,%eax
801039f2:	09 d8                	or     %ebx,%eax
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1];
801039f4:	89 c3                	mov    %eax,%ebx
801039f6:	83 e0 01             	and    $0x1,%eax
801039f9:	d1 eb                	shr    %ebx
801039fb:	33 5a fc             	xor    -0x4(%edx),%ebx
801039fe:	33 1c 85 4c 81 10 80 	xor    -0x7fef7eb4(,%eax,4),%ebx
80103a05:	89 9a 88 03 00 00    	mov    %ebx,0x388(%edx)
        for (;kk<N-1;kk++) {
80103a0b:	39 d1                	cmp    %edx,%ecx
80103a0d:	75 c9                	jne    801039d8 <genrand+0x68>
        }
        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK);
80103a0f:	a1 e0 b5 10 80       	mov    0x8010b5e0,%eax
80103a14:	8b 0d 9c bf 10 80    	mov    0x8010bf9c,%ecx
80103a1a:	89 c2                	mov    %eax,%edx
80103a1c:	81 e1 00 00 00 80    	and    $0x80000000,%ecx
80103a22:	81 e2 ff ff ff 7f    	and    $0x7fffffff,%edx
80103a28:	09 d1                	or     %edx,%ecx
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1];
80103a2a:	89 ca                	mov    %ecx,%edx
80103a2c:	83 e1 01             	and    $0x1,%ecx
80103a2f:	d1 ea                	shr    %edx
80103a31:	33 15 10 bc 10 80    	xor    0x8010bc10,%edx
80103a37:	33 14 8d 4c 81 10 80 	xor    -0x7fef7eb4(,%ecx,4),%edx
80103a3e:	89 15 9c bf 10 80    	mov    %edx,0x8010bf9c
80103a44:	ba 01 00 00 00       	mov    $0x1,%edx

        mti = 0;
    }
  
    y = mt[mti++];
80103a49:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
    y ^= TEMPERING_SHIFT_U(y);
80103a4f:	89 c2                	mov    %eax,%edx
80103a51:	c1 ea 0b             	shr    $0xb,%edx
80103a54:	31 c2                	xor    %eax,%edx
    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B;
80103a56:	89 d0                	mov    %edx,%eax
80103a58:	c1 e0 07             	shl    $0x7,%eax
80103a5b:	25 80 56 2c 9d       	and    $0x9d2c5680,%eax
80103a60:	31 c2                	xor    %eax,%edx
    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C;
80103a62:	89 d0                	mov    %edx,%eax
80103a64:	c1 e0 0f             	shl    $0xf,%eax
80103a67:	25 00 00 c6 ef       	and    $0xefc60000,%eax
80103a6c:	31 d0                	xor    %edx,%eax
    y ^= TEMPERING_SHIFT_L(y);
80103a6e:	89 c2                	mov    %eax,%edx
80103a70:	c1 ea 12             	shr    $0x12,%edx
80103a73:	31 d0                	xor    %edx,%eax

    // Strip off uppermost bit because we want a long,
    // not an unsigned long
    return y & RAND_MAX;
}
80103a75:	5b                   	pop    %ebx
    return y & RAND_MAX;
80103a76:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
80103a7b:	5e                   	pop    %esi
80103a7c:	5d                   	pop    %ebp
80103a7d:	c3                   	ret    
80103a7e:	8d 50 01             	lea    0x1(%eax),%edx
80103a81:	8b 04 85 e0 b5 10 80 	mov    -0x7fef4a20(,%eax,4),%eax
80103a88:	eb bf                	jmp    80103a49 <genrand+0xd9>
    mt[0]= seed & 0xffffffff;
80103a8a:	c7 05 e0 b5 10 80 05 	movl   $0x1105,0x8010b5e0
80103a91:	11 00 00 
80103a94:	b8 e4 b5 10 80       	mov    $0x8010b5e4,%eax
80103a99:	b9 9c bf 10 80       	mov    $0x8010bf9c,%ecx
80103a9e:	ba 05 11 00 00       	mov    $0x1105,%edx
80103aa3:	eb 06                	jmp    80103aab <genrand+0x13b>
80103aa5:	8d 76 00             	lea    0x0(%esi),%esi
80103aa8:	83 c0 04             	add    $0x4,%eax
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
80103aab:	69 d2 cd 0d 01 00    	imul   $0x10dcd,%edx,%edx
    for (mti=1; mti<N; mti++)
80103ab1:	39 c1                	cmp    %eax,%ecx
        mt[mti] = (69069 * mt[mti-1]) & 0xffffffff;
80103ab3:	89 10                	mov    %edx,(%eax)
    for (mti=1; mti<N; mti++)
80103ab5:	75 f1                	jne    80103aa8 <genrand+0x138>
80103ab7:	e9 d4 fe ff ff       	jmp    80103990 <genrand+0x20>
80103abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ac0 <random_at_most>:

// Assumes 0 <= max <= RAND_MAX
// Returns in the half-open interval [0, max]
long random_at_most(long max) {
80103ac0:	55                   	push   %ebp
  unsigned long
    // max <= RAND_MAX < ULONG_MAX, so this is okay.
    num_bins = (unsigned long) max + 1,
    num_rand = (unsigned long) RAND_MAX + 1,
    bin_size = num_rand / num_bins,
80103ac1:	31 d2                	xor    %edx,%edx
long random_at_most(long max) {
80103ac3:	89 e5                	mov    %esp,%ebp
80103ac5:	56                   	push   %esi
80103ac6:	53                   	push   %ebx
    num_bins = (unsigned long) max + 1,
80103ac7:	8b 45 08             	mov    0x8(%ebp),%eax
    bin_size = num_rand / num_bins,
80103aca:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    num_bins = (unsigned long) max + 1,
80103acf:	8d 48 01             	lea    0x1(%eax),%ecx
    bin_size = num_rand / num_bins,
80103ad2:	89 d8                	mov    %ebx,%eax
80103ad4:	f7 f1                	div    %ecx
80103ad6:	89 c6                	mov    %eax,%esi
80103ad8:	29 d3                	sub    %edx,%ebx
80103ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    defect   = num_rand % num_bins;

  long x;
  do {
   x = genrand();
80103ae0:	e8 8b fe ff ff       	call   80103970 <genrand>
  }
  // This is carefully written not to overflow
  while (num_rand - defect <= (unsigned long)x);
80103ae5:	39 d8                	cmp    %ebx,%eax
80103ae7:	73 f7                	jae    80103ae0 <random_at_most+0x20>

  // Truncated division is intentional
  return x/bin_size;
80103ae9:	31 d2                	xor    %edx,%edx
80103aeb:	f7 f6                	div    %esi
80103aed:	5b                   	pop    %ebx
80103aee:	5e                   	pop    %esi
80103aef:	5d                   	pop    %ebp
80103af0:	c3                   	ret    
80103af1:	eb 0d                	jmp    80103b00 <set_last_syscall_info>
80103af3:	90                   	nop
80103af4:	90                   	nop
80103af5:	90                   	nop
80103af6:	90                   	nop
80103af7:	90                   	nop
80103af8:	90                   	nop
80103af9:	90                   	nop
80103afa:	90                   	nop
80103afb:	90                   	nop
80103afc:	90                   	nop
80103afd:	90                   	nop
80103afe:	90                   	nop
80103aff:	90                   	nop

80103b00 <set_last_syscall_info>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	57                   	push   %edi
80103b04:	56                   	push   %esi
80103b05:	53                   	push   %ebx
80103b06:	83 ec 28             	sub    $0x28,%esp
80103b09:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(& syscalls_history.lock);
80103b0c:	68 20 47 11 80       	push   $0x80114720
80103b11:	e8 aa 11 00 00       	call   80104cc0 <acquire>
    syscalls_history.sf[rscount].args[syscalls_history.sf[rscount].args_c][i] = in[i];
80103b16:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
80103b1b:	83 c4 10             	add    $0x10,%esp
80103b1e:	89 c7                	mov    %eax,%edi
80103b20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for (int i=0 ; i<10 && in[i] != '\0' ; i++)
80103b23:	31 c0                	xor    %eax,%eax
    syscalls_history.sf[rscount].args[syscalls_history.sf[rscount].args_c][i] = in[i];
80103b25:	69 df 8c 00 00 00    	imul   $0x8c,%edi,%ebx
80103b2b:	8d bb 20 47 11 80    	lea    -0x7feeb8e0(%ebx),%edi
80103b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (int i=0 ; i<10 && in[i] != '\0' ; i++)
80103b38:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80103b3c:	84 d2                	test   %dl,%dl
80103b3e:	74 1c                	je     80103b5c <set_last_syscall_info+0x5c>
    syscalls_history.sf[rscount].args[syscalls_history.sf[rscount].args_c][i] = in[i];
80103b40:	8b 8f bc 00 00 00    	mov    0xbc(%edi),%ecx
80103b46:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
80103b49:	8d 8c 4b 20 47 11 80 	lea    -0x7feeb8e0(%ebx,%ecx,2),%ecx
80103b50:	88 54 01 58          	mov    %dl,0x58(%ecx,%eax,1)
  for (int i=0 ; i<10 && in[i] != '\0' ; i++)
80103b54:	83 c0 01             	add    $0x1,%eax
80103b57:	83 f8 0a             	cmp    $0xa,%eax
80103b5a:	75 dc                	jne    80103b38 <set_last_syscall_info+0x38>
  syscalls_history.sf[rscount].args_c++;
80103b5c:	69 45 e4 8c 00 00 00 	imul   $0x8c,-0x1c(%ebp),%eax
  release(& syscalls_history.lock);
80103b63:	c7 45 08 20 47 11 80 	movl   $0x80114720,0x8(%ebp)
  syscalls_history.sf[rscount].args_c++;
80103b6a:	83 80 dc 47 11 80 01 	addl   $0x1,-0x7feeb824(%eax)
}
80103b71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b74:	5b                   	pop    %ebx
80103b75:	5e                   	pop    %esi
80103b76:	5f                   	pop    %edi
80103b77:	5d                   	pop    %ebp
  release(& syscalls_history.lock);
80103b78:	e9 03 12 00 00       	jmp    80104d80 <release>
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi

80103b80 <init_arg_count>:
{
80103b80:	55                   	push   %ebp
80103b81:	b8 dc 47 11 80       	mov    $0x801147dc,%eax
80103b86:	89 e5                	mov    %esp,%ebp
80103b88:	90                   	nop
80103b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    syscalls_history.sf[i].args_c=0;
80103b90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103b96:	05 8c 00 00 00       	add    $0x8c,%eax
  for (int i=0 ; i<RSCOUNTMAX ; i++)
80103b9b:	3d 8c 7e 11 80       	cmp    $0x80117e8c,%eax
80103ba0:	75 ee                	jne    80103b90 <init_arg_count+0x10>
}
80103ba2:	5d                   	pop    %ebp
80103ba3:	c3                   	ret    
80103ba4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103baa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103bb0 <init_syscalls_count>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	8b 45 08             	mov    0x8(%ebp),%eax
80103bb6:	8d 50 5c             	lea    0x5c(%eax),%edx
80103bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sys_count[i]=0;
80103bc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103bc6:	83 c0 04             	add    $0x4,%eax
  for (int i=0 ; i<MAXSYSCALL ; i++)
80103bc9:	39 d0                	cmp    %edx,%eax
80103bcb:	75 f3                	jne    80103bc0 <init_syscalls_count+0x10>
}
80103bcd:	5d                   	pop    %ebp
80103bce:	c3                   	ret    
80103bcf:	90                   	nop

80103bd0 <register_syscall>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	57                   	push   %edi
80103bd4:	56                   	push   %esi
80103bd5:	53                   	push   %ebx
    cmostime(&r); 
80103bd6:	8d 45 d0             	lea    -0x30(%ebp),%eax
{
80103bd9:	83 ec 38             	sub    $0x38,%esp
80103bdc:	8b 7d 08             	mov    0x8(%ebp),%edi
80103bdf:	8b 75 0c             	mov    0xc(%ebp),%esi
    cmostime(&r); 
80103be2:	50                   	push   %eax
80103be3:	e8 38 ec ff ff       	call   80102820 <cmostime>
    acquire(&syscalls_history.lock);
80103be8:	c7 04 24 20 47 11 80 	movl   $0x80114720,(%esp)
80103bef:	e8 cc 10 00 00       	call   80104cc0 <acquire>
    syscalls_history.sf[rscount].date = r;
80103bf4:	8b 0d c4 b5 10 80    	mov    0x8010b5c4,%ecx
80103bfa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
80103bfd:	83 c4 10             	add    $0x10,%esp
    syscalls_history.sf[rscount].name = name;
80103c00:	8b 55 10             	mov    0x10(%ebp),%edx
    syscalls_history.sf[rscount].date = r;
80103c03:	69 c1 8c 00 00 00    	imul   $0x8c,%ecx,%eax
80103c09:	89 98 60 47 11 80    	mov    %ebx,-0x7feeb8a0(%eax)
80103c0f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    syscalls_history.sf[rscount].name = name;
80103c12:	89 90 54 47 11 80    	mov    %edx,-0x7feeb8ac(%eax)
    syscalls_history.sf[rscount].pid = pid;
80103c18:	89 b8 5c 47 11 80    	mov    %edi,-0x7feeb8a4(%eax)
80103c1e:	ba 64 7e 11 80       	mov    $0x80117e64,%edx
    syscalls_history.sf[rscount].id = id;
80103c23:	89 b0 58 47 11 80    	mov    %esi,-0x7feeb8a8(%eax)
    syscalls_history.sf[rscount].date = r;
80103c29:	89 98 64 47 11 80    	mov    %ebx,-0x7feeb89c(%eax)
80103c2f:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80103c32:	89 98 68 47 11 80    	mov    %ebx,-0x7feeb898(%eax)
80103c38:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80103c3b:	89 98 6c 47 11 80    	mov    %ebx,-0x7feeb894(%eax)
80103c41:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80103c44:	89 98 70 47 11 80    	mov    %ebx,-0x7feeb890(%eax)
80103c4a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c4d:	89 98 74 47 11 80    	mov    %ebx,-0x7feeb88c(%eax)
    for (int i=0 ; i<NPROC ; i++)
80103c53:	31 c0                	xor    %eax,%eax
80103c55:	eb 17                	jmp    80103c6e <register_syscall+0x9e>
80103c57:	89 f6                	mov    %esi,%esi
80103c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80103c60:	83 c0 01             	add    $0x1,%eax
80103c63:	81 c2 e8 00 00 00    	add    $0xe8,%edx
80103c69:	83 f8 40             	cmp    $0x40,%eax
80103c6c:	74 13                	je     80103c81 <register_syscall+0xb1>
      if(ptable.proc[i].pid == pid)
80103c6e:	39 3a                	cmp    %edi,(%edx)
80103c70:	75 ee                	jne    80103c60 <register_syscall+0x90>
        ptable.proc[i].syscall_count[id]++;
80103c72:	6b c0 3a             	imul   $0x3a,%eax,%eax
80103c75:	8d 44 06 28          	lea    0x28(%esi,%eax,1),%eax
80103c79:	83 04 85 30 7e 11 80 	addl   $0x1,-0x7fee81d0(,%eax,4)
80103c80:	01 
    rscount++;
80103c81:	83 c1 01             	add    $0x1,%ecx
    tscount++;
80103c84:	83 05 c0 b5 10 80 01 	addl   $0x1,0x8010b5c0
    if (rscount>=RSCOUNTMAX)
80103c8b:	83 f9 63             	cmp    $0x63,%ecx
    rscount++;
80103c8e:	89 0d c4 b5 10 80    	mov    %ecx,0x8010b5c4
    if (rscount>=RSCOUNTMAX)
80103c94:	7e 49                	jle    80103cdf <register_syscall+0x10f>
80103c96:	b8 54 47 11 80       	mov    $0x80114754,%eax
80103c9b:	90                   	nop
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
         syscalls_history.sf[i]=syscalls_history.sf[i+RSCOUNTMAX-RSCOUNTMAX/2];  
80103ca0:	8d b0 58 1b 00 00    	lea    0x1b58(%eax),%esi
80103ca6:	89 c7                	mov    %eax,%edi
80103ca8:	05 8c 00 00 00       	add    $0x8c,%eax
      for (int i=0 ; i<RSCOUNTMAX-RSCOUNTMAX/2 ; i++)
80103cad:	3d ac 62 11 80       	cmp    $0x801162ac,%eax
         syscalls_history.sf[i]=syscalls_history.sf[i+RSCOUNTMAX-RSCOUNTMAX/2];  
80103cb2:	b9 23 00 00 00       	mov    $0x23,%ecx
80103cb7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
      for (int i=0 ; i<RSCOUNTMAX-RSCOUNTMAX/2 ; i++)
80103cb9:	75 e5                	jne    80103ca0 <register_syscall+0xd0>
      rscount=RSCOUNTMAX-RSCOUNTMAX/2 + 1;
80103cbb:	c7 05 c4 b5 10 80 33 	movl   $0x33,0x8010b5c4
80103cc2:	00 00 00 
80103cc5:	b8 4c 64 11 80       	mov    $0x8011644c,%eax
80103cca:	ba 8c 7e 11 80       	mov    $0x80117e8c,%edx
80103ccf:	90                   	nop
        syscalls_history.sf[i].args_c=0;
80103cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103cd6:	05 8c 00 00 00       	add    $0x8c,%eax
      for (int i=rscount+1 ; i<RSCOUNTMAX ; i++)
80103cdb:	39 c2                	cmp    %eax,%edx
80103cdd:	75 f1                	jne    80103cd0 <register_syscall+0x100>
    release(&syscalls_history.lock);
80103cdf:	83 ec 0c             	sub    $0xc,%esp
80103ce2:	68 20 47 11 80       	push   $0x80114720
80103ce7:	e8 94 10 00 00       	call   80104d80 <release>
    return ;
80103cec:	83 c4 10             	add    $0x10,%esp
}
80103cef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cf2:	5b                   	pop    %ebx
80103cf3:	5e                   	pop    %esi
80103cf4:	5f                   	pop    %edi
80103cf5:	5d                   	pop    %ebp
80103cf6:	c3                   	ret    
80103cf7:	89 f6                	mov    %esi,%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d00 <pinit>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103d06:	68 7b 7f 10 80       	push   $0x80107f7b
80103d0b:	68 20 7e 11 80       	push   $0x80117e20
80103d10:	e8 6b 0e 00 00       	call   80104b80 <initlock>
  initlock(&syscalls_history.lock, "syscalls_history");
80103d15:	58                   	pop    %eax
80103d16:	5a                   	pop    %edx
80103d17:	68 82 7f 10 80       	push   $0x80107f82
80103d1c:	68 20 47 11 80       	push   $0x80114720
80103d21:	e8 5a 0e 00 00       	call   80104b80 <initlock>
80103d26:	b8 dc 47 11 80       	mov    $0x801147dc,%eax
80103d2b:	83 c4 10             	add    $0x10,%esp
80103d2e:	66 90                	xchg   %ax,%ax
    syscalls_history.sf[i].args_c=0;
80103d30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103d36:	05 8c 00 00 00       	add    $0x8c,%eax
  for (int i=0 ; i<RSCOUNTMAX ; i++)
80103d3b:	3d 8c 7e 11 80       	cmp    $0x80117e8c,%eax
80103d40:	75 ee                	jne    80103d30 <pinit+0x30>
}
80103d42:	c9                   	leave  
80103d43:	c3                   	ret    
80103d44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103d50 <mycpu>:
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	56                   	push   %esi
80103d54:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d55:	9c                   	pushf  
80103d56:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d57:	f6 c4 02             	test   $0x2,%ah
80103d5a:	75 5e                	jne    80103dba <mycpu+0x6a>
  apicid = lapicid();
80103d5c:	e8 df e9 ff ff       	call   80102740 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103d61:	8b 35 00 47 11 80    	mov    0x80114700,%esi
80103d67:	85 f6                	test   %esi,%esi
80103d69:	7e 42                	jle    80103dad <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103d6b:	0f b6 15 80 41 11 80 	movzbl 0x80114180,%edx
80103d72:	39 d0                	cmp    %edx,%eax
80103d74:	74 30                	je     80103da6 <mycpu+0x56>
80103d76:	b9 30 42 11 80       	mov    $0x80114230,%ecx
  for (i = 0; i < ncpu; ++i) {
80103d7b:	31 d2                	xor    %edx,%edx
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi
80103d80:	83 c2 01             	add    $0x1,%edx
80103d83:	39 f2                	cmp    %esi,%edx
80103d85:	74 26                	je     80103dad <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103d87:	0f b6 19             	movzbl (%ecx),%ebx
80103d8a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103d90:	39 c3                	cmp    %eax,%ebx
80103d92:	75 ec                	jne    80103d80 <mycpu+0x30>
80103d94:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103d9a:	05 80 41 11 80       	add    $0x80114180,%eax
}
80103d9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103da2:	5b                   	pop    %ebx
80103da3:	5e                   	pop    %esi
80103da4:	5d                   	pop    %ebp
80103da5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103da6:	b8 80 41 11 80       	mov    $0x80114180,%eax
      return &cpus[i];
80103dab:	eb f2                	jmp    80103d9f <mycpu+0x4f>
  panic("unknown apicid\n");
80103dad:	83 ec 0c             	sub    $0xc,%esp
80103db0:	68 93 7f 10 80       	push   $0x80107f93
80103db5:	e8 d6 c5 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103dba:	83 ec 0c             	sub    $0xc,%esp
80103dbd:	68 54 81 10 80       	push   $0x80108154
80103dc2:	e8 c9 c5 ff ff       	call   80100390 <panic>
80103dc7:	89 f6                	mov    %esi,%esi
80103dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dd0 <cpuid>:
cpuid() {
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103dd6:	e8 75 ff ff ff       	call   80103d50 <mycpu>
80103ddb:	2d 80 41 11 80       	sub    $0x80114180,%eax
}
80103de0:	c9                   	leave  
  return mycpu()-cpus;
80103de1:	c1 f8 04             	sar    $0x4,%eax
80103de4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103dea:	c3                   	ret    
80103deb:	90                   	nop
80103dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103df0 <myproc>:
myproc(void) {
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	53                   	push   %ebx
80103df4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103df7:	e8 f4 0d 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
80103dfc:	e8 4f ff ff ff       	call   80103d50 <mycpu>
  p = c->proc;
80103e01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e07:	e8 24 0e 00 00       	call   80104c30 <popcli>
}
80103e0c:	83 c4 04             	add    $0x4,%esp
80103e0f:	89 d8                	mov    %ebx,%eax
80103e11:	5b                   	pop    %ebx
80103e12:	5d                   	pop    %ebp
80103e13:	c3                   	ret    
80103e14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103e1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103e20 <userinit>:
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	53                   	push   %ebx
80103e24:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103e27:	e8 e4 f7 ff ff       	call   80103610 <allocproc>
80103e2c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103e2e:	a3 c8 b5 10 80       	mov    %eax,0x8010b5c8
  if((p->pgdir = setupkvm()) == 0)
80103e33:	e8 b8 38 00 00       	call   801076f0 <setupkvm>
80103e38:	85 c0                	test   %eax,%eax
80103e3a:	89 43 04             	mov    %eax,0x4(%ebx)
80103e3d:	0f 84 bd 00 00 00    	je     80103f00 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e43:	83 ec 04             	sub    $0x4,%esp
80103e46:	68 2c 00 00 00       	push   $0x2c
80103e4b:	68 60 b4 10 80       	push   $0x8010b460
80103e50:	50                   	push   %eax
80103e51:	e8 7a 35 00 00       	call   801073d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e56:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e59:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e5f:	6a 4c                	push   $0x4c
80103e61:	6a 00                	push   $0x0
80103e63:	ff 73 18             	pushl  0x18(%ebx)
80103e66:	e8 65 0f 00 00       	call   80104dd0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e6b:	8b 43 18             	mov    0x18(%ebx),%eax
80103e6e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e73:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e78:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e7b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e7f:	8b 43 18             	mov    0x18(%ebx),%eax
80103e82:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103e86:	8b 43 18             	mov    0x18(%ebx),%eax
80103e89:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e8d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103e91:	8b 43 18             	mov    0x18(%ebx),%eax
80103e94:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e98:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103e9c:	8b 43 18             	mov    0x18(%ebx),%eax
80103e9f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ea6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ea9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103eb0:	8b 43 18             	mov    0x18(%ebx),%eax
80103eb3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103eba:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ebd:	6a 10                	push   $0x10
80103ebf:	68 bc 7f 10 80       	push   $0x80107fbc
80103ec4:	50                   	push   %eax
80103ec5:	e8 e6 10 00 00       	call   80104fb0 <safestrcpy>
  p->cwd = namei("/");
80103eca:	c7 04 24 c5 7f 10 80 	movl   $0x80107fc5,(%esp)
80103ed1:	e8 1a e0 ff ff       	call   80101ef0 <namei>
80103ed6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ed9:	c7 04 24 20 7e 11 80 	movl   $0x80117e20,(%esp)
80103ee0:	e8 db 0d 00 00       	call   80104cc0 <acquire>
  p->state = RUNNABLE;
80103ee5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103eec:	c7 04 24 20 7e 11 80 	movl   $0x80117e20,(%esp)
80103ef3:	e8 88 0e 00 00       	call   80104d80 <release>
}
80103ef8:	83 c4 10             	add    $0x10,%esp
80103efb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103efe:	c9                   	leave  
80103eff:	c3                   	ret    
    panic("userinit: out of memory?");
80103f00:	83 ec 0c             	sub    $0xc,%esp
80103f03:	68 a3 7f 10 80       	push   $0x80107fa3
80103f08:	e8 83 c4 ff ff       	call   80100390 <panic>
80103f0d:	8d 76 00             	lea    0x0(%esi),%esi

80103f10 <growproc>:
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	56                   	push   %esi
80103f14:	53                   	push   %ebx
80103f15:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f18:	e8 d3 0c 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
80103f1d:	e8 2e fe ff ff       	call   80103d50 <mycpu>
  p = c->proc;
80103f22:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f28:	e8 03 0d 00 00       	call   80104c30 <popcli>
  if(n > 0){
80103f2d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103f30:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f32:	7f 1c                	jg     80103f50 <growproc+0x40>
  } else if(n < 0){
80103f34:	75 3a                	jne    80103f70 <growproc+0x60>
  switchuvm(curproc);
80103f36:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f39:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f3b:	53                   	push   %ebx
80103f3c:	e8 7f 33 00 00       	call   801072c0 <switchuvm>
  return 0;
80103f41:	83 c4 10             	add    $0x10,%esp
80103f44:	31 c0                	xor    %eax,%eax
}
80103f46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f49:	5b                   	pop    %ebx
80103f4a:	5e                   	pop    %esi
80103f4b:	5d                   	pop    %ebp
80103f4c:	c3                   	ret    
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f50:	83 ec 04             	sub    $0x4,%esp
80103f53:	01 c6                	add    %eax,%esi
80103f55:	56                   	push   %esi
80103f56:	50                   	push   %eax
80103f57:	ff 73 04             	pushl  0x4(%ebx)
80103f5a:	e8 b1 35 00 00       	call   80107510 <allocuvm>
80103f5f:	83 c4 10             	add    $0x10,%esp
80103f62:	85 c0                	test   %eax,%eax
80103f64:	75 d0                	jne    80103f36 <growproc+0x26>
      return -1;
80103f66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f6b:	eb d9                	jmp    80103f46 <growproc+0x36>
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f70:	83 ec 04             	sub    $0x4,%esp
80103f73:	01 c6                	add    %eax,%esi
80103f75:	56                   	push   %esi
80103f76:	50                   	push   %eax
80103f77:	ff 73 04             	pushl  0x4(%ebx)
80103f7a:	e8 c1 36 00 00       	call   80107640 <deallocuvm>
80103f7f:	83 c4 10             	add    $0x10,%esp
80103f82:	85 c0                	test   %eax,%eax
80103f84:	75 b0                	jne    80103f36 <growproc+0x26>
80103f86:	eb de                	jmp    80103f66 <growproc+0x56>
80103f88:	90                   	nop
80103f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f90 <fork>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	57                   	push   %edi
80103f94:	56                   	push   %esi
80103f95:	53                   	push   %ebx
80103f96:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103f99:	e8 52 0c 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
80103f9e:	e8 ad fd ff ff       	call   80103d50 <mycpu>
  p = c->proc;
80103fa3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fa9:	e8 82 0c 00 00       	call   80104c30 <popcli>
  if((np = allocproc()) == 0){
80103fae:	e8 5d f6 ff ff       	call   80103610 <allocproc>
80103fb3:	85 c0                	test   %eax,%eax
80103fb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103fb8:	0f 84 b7 00 00 00    	je     80104075 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103fbe:	83 ec 08             	sub    $0x8,%esp
80103fc1:	ff 33                	pushl  (%ebx)
80103fc3:	ff 73 04             	pushl  0x4(%ebx)
80103fc6:	89 c7                	mov    %eax,%edi
80103fc8:	e8 f3 37 00 00       	call   801077c0 <copyuvm>
80103fcd:	83 c4 10             	add    $0x10,%esp
80103fd0:	85 c0                	test   %eax,%eax
80103fd2:	89 47 04             	mov    %eax,0x4(%edi)
80103fd5:	0f 84 a1 00 00 00    	je     8010407c <fork+0xec>
  np->sz = curproc->sz;
80103fdb:	8b 03                	mov    (%ebx),%eax
80103fdd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103fe0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103fe2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103fe5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103fe7:	8b 79 18             	mov    0x18(%ecx),%edi
80103fea:	8b 73 18             	mov    0x18(%ebx),%esi
80103fed:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ff2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ff4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ff6:	8b 40 18             	mov    0x18(%eax),%eax
80103ff9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104000:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104004:	85 c0                	test   %eax,%eax
80104006:	74 13                	je     8010401b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104008:	83 ec 0c             	sub    $0xc,%esp
8010400b:	50                   	push   %eax
8010400c:	e8 df cd ff ff       	call   80100df0 <filedup>
80104011:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104014:	83 c4 10             	add    $0x10,%esp
80104017:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010401b:	83 c6 01             	add    $0x1,%esi
8010401e:	83 fe 10             	cmp    $0x10,%esi
80104021:	75 dd                	jne    80104000 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104023:	83 ec 0c             	sub    $0xc,%esp
80104026:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104029:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010402c:	e8 2f d6 ff ff       	call   80101660 <idup>
80104031:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104034:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104037:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010403a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010403d:	6a 10                	push   $0x10
8010403f:	53                   	push   %ebx
80104040:	50                   	push   %eax
80104041:	e8 6a 0f 00 00       	call   80104fb0 <safestrcpy>
  pid = np->pid;
80104046:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104049:	c7 04 24 20 7e 11 80 	movl   $0x80117e20,(%esp)
80104050:	e8 6b 0c 00 00       	call   80104cc0 <acquire>
  np->state = RUNNABLE;
80104055:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010405c:	c7 04 24 20 7e 11 80 	movl   $0x80117e20,(%esp)
80104063:	e8 18 0d 00 00       	call   80104d80 <release>
  return pid;
80104068:	83 c4 10             	add    $0x10,%esp
}
8010406b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010406e:	89 d8                	mov    %ebx,%eax
80104070:	5b                   	pop    %ebx
80104071:	5e                   	pop    %esi
80104072:	5f                   	pop    %edi
80104073:	5d                   	pop    %ebp
80104074:	c3                   	ret    
    return -1;
80104075:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010407a:	eb ef                	jmp    8010406b <fork+0xdb>
    kfree(np->kstack);
8010407c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010407f:	83 ec 0c             	sub    $0xc,%esp
80104082:	ff 73 08             	pushl  0x8(%ebx)
80104085:	e8 96 e2 ff ff       	call   80102320 <kfree>
    np->kstack = 0;
8010408a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80104091:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104098:	83 c4 10             	add    $0x10,%esp
8010409b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040a0:	eb c9                	jmp    8010406b <fork+0xdb>
801040a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040b0 <scheduler>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	57                   	push   %edi
801040b4:	56                   	push   %esi
801040b5:	53                   	push   %ebx
801040b6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801040b9:	e8 92 fc ff ff       	call   80103d50 <mycpu>
801040be:	8d 70 04             	lea    0x4(%eax),%esi
801040c1:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
801040c3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040ca:	00 00 00 
801040cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801040d0:	fb                   	sti    
    lottery_total_tickets=0;
801040d1:	31 d2                	xor    %edx,%edx
    for (p = ptable.proc; p<&ptable.proc[NPROC] ; p++)
801040d3:	b8 54 7e 11 80       	mov    $0x80117e54,%eax
801040d8:	90                   	nop
801040d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(p->state == RUNNABLE)
801040e0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801040e4:	75 06                	jne    801040ec <scheduler+0x3c>
          lottery_total_tickets = p->ticket + lottery_total_tickets;
801040e6:	03 90 d8 00 00 00    	add    0xd8(%eax),%edx
    for (p = ptable.proc; p<&ptable.proc[NPROC] ; p++)
801040ec:	05 e8 00 00 00       	add    $0xe8,%eax
801040f1:	3d 54 b8 11 80       	cmp    $0x8011b854,%eax
801040f6:	72 e8                	jb     801040e0 <scheduler+0x30>
    num_bins = (unsigned long) max + 1,
801040f8:	8d 4a 01             	lea    0x1(%edx),%ecx
    bin_size = num_rand / num_bins,
801040fb:	bf 00 00 00 80       	mov    $0x80000000,%edi
80104100:	31 d2                	xor    %edx,%edx
80104102:	89 f8                	mov    %edi,%eax
80104104:	f7 f1                	div    %ecx
80104106:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104109:	29 d7                	sub    %edx,%edi
8010410b:	90                   	nop
8010410c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
   x = genrand();
80104110:	e8 5b f8 ff ff       	call   80103970 <genrand>
  while (num_rand - defect <= (unsigned long)x);
80104115:	39 f8                	cmp    %edi,%eax
80104117:	73 f7                	jae    80104110 <scheduler+0x60>
  return x/bin_size;
80104119:	31 d2                	xor    %edx,%edx
    acquire(&ptable.lock);
8010411b:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010411e:	bf 54 7e 11 80       	mov    $0x80117e54,%edi
80104123:	f7 75 e4             	divl   -0x1c(%ebp)
    acquire(&ptable.lock);
80104126:	68 20 7e 11 80       	push   $0x80117e20
8010412b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010412e:	e8 8d 0b 00 00       	call   80104cc0 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    acquire(&ptable.lock);
80104136:	83 c4 10             	add    $0x10,%esp
    passed_tickets = 0;
80104139:	31 d2                	xor    %edx,%edx
8010413b:	90                   	nop
8010413c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->state != RUNNABLE)
80104140:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80104144:	75 6a                	jne    801041b0 <scheduler+0x100>
      if (passed_tickets + p->ticket < chance)
80104146:	03 97 d8 00 00 00    	add    0xd8(%edi),%edx
8010414c:	39 c2                	cmp    %eax,%edx
8010414e:	7c 60                	jl     801041b0 <scheduler+0x100>
      switchuvm(p);
80104150:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104153:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80104159:	57                   	push   %edi
8010415a:	e8 61 31 00 00       	call   801072c0 <switchuvm>
      if(p->serv == 0)
8010415f:	8b 87 e4 00 00 00    	mov    0xe4(%edi),%eax
80104165:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104168:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      if(p->serv == 0)
8010416f:	85 c0                	test   %eax,%eax
80104171:	75 1b                	jne    8010418e <scheduler+0xde>
        p->response_time = ticks - p->response_time;
80104173:	a1 a0 c0 11 80       	mov    0x8011c0a0,%eax
80104178:	2b 87 dc 00 00 00    	sub    0xdc(%edi),%eax
        p->serv=1;
8010417e:	c7 87 e4 00 00 00 01 	movl   $0x1,0xe4(%edi)
80104185:	00 00 00 
        p->response_time = ticks - p->response_time;
80104188:	89 87 dc 00 00 00    	mov    %eax,0xdc(%edi)
      swtch(&(c->scheduler), p->context);
8010418e:	83 ec 08             	sub    $0x8,%esp
80104191:	ff 77 1c             	pushl  0x1c(%edi)
80104194:	56                   	push   %esi
80104195:	e8 71 0e 00 00       	call   8010500b <swtch>
      switchkvm();
8010419a:	e8 01 31 00 00       	call   801072a0 <switchkvm>
      c->proc = 0;
8010419f:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
801041a6:	00 00 00 
801041a9:	83 c4 10             	add    $0x10,%esp
      passed_tickets = 0;
801041ac:	31 d2                	xor    %edx,%edx
      chance = 0;
801041ae:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b0:	81 c7 e8 00 00 00    	add    $0xe8,%edi
801041b6:	81 ff 54 b8 11 80    	cmp    $0x8011b854,%edi
801041bc:	72 82                	jb     80104140 <scheduler+0x90>
    release(&ptable.lock);
801041be:	83 ec 0c             	sub    $0xc,%esp
801041c1:	68 20 7e 11 80       	push   $0x80117e20
801041c6:	e8 b5 0b 00 00       	call   80104d80 <release>
    sti();
801041cb:	83 c4 10             	add    $0x10,%esp
801041ce:	e9 fd fe ff ff       	jmp    801040d0 <scheduler+0x20>
801041d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <sched>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	56                   	push   %esi
801041e4:	53                   	push   %ebx
  pushcli();
801041e5:	e8 06 0a 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
801041ea:	e8 61 fb ff ff       	call   80103d50 <mycpu>
  p = c->proc;
801041ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041f5:	e8 36 0a 00 00       	call   80104c30 <popcli>
  if(!holding(&ptable.lock))
801041fa:	83 ec 0c             	sub    $0xc,%esp
801041fd:	68 20 7e 11 80       	push   $0x80117e20
80104202:	e8 89 0a 00 00       	call   80104c90 <holding>
80104207:	83 c4 10             	add    $0x10,%esp
8010420a:	85 c0                	test   %eax,%eax
8010420c:	74 4f                	je     8010425d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010420e:	e8 3d fb ff ff       	call   80103d50 <mycpu>
80104213:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010421a:	75 68                	jne    80104284 <sched+0xa4>
  if(p->state == RUNNING)
8010421c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104220:	74 55                	je     80104277 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104222:	9c                   	pushf  
80104223:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104224:	f6 c4 02             	test   $0x2,%ah
80104227:	75 41                	jne    8010426a <sched+0x8a>
  intena = mycpu()->intena;
80104229:	e8 22 fb ff ff       	call   80103d50 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010422e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104231:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104237:	e8 14 fb ff ff       	call   80103d50 <mycpu>
8010423c:	83 ec 08             	sub    $0x8,%esp
8010423f:	ff 70 04             	pushl  0x4(%eax)
80104242:	53                   	push   %ebx
80104243:	e8 c3 0d 00 00       	call   8010500b <swtch>
  mycpu()->intena = intena;
80104248:	e8 03 fb ff ff       	call   80103d50 <mycpu>
}
8010424d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104250:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104259:	5b                   	pop    %ebx
8010425a:	5e                   	pop    %esi
8010425b:	5d                   	pop    %ebp
8010425c:	c3                   	ret    
    panic("sched ptable.lock");
8010425d:	83 ec 0c             	sub    $0xc,%esp
80104260:	68 c7 7f 10 80       	push   $0x80107fc7
80104265:	e8 26 c1 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010426a:	83 ec 0c             	sub    $0xc,%esp
8010426d:	68 f3 7f 10 80       	push   $0x80107ff3
80104272:	e8 19 c1 ff ff       	call   80100390 <panic>
    panic("sched running");
80104277:	83 ec 0c             	sub    $0xc,%esp
8010427a:	68 e5 7f 10 80       	push   $0x80107fe5
8010427f:	e8 0c c1 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104284:	83 ec 0c             	sub    $0xc,%esp
80104287:	68 d9 7f 10 80       	push   $0x80107fd9
8010428c:	e8 ff c0 ff ff       	call   80100390 <panic>
80104291:	eb 0d                	jmp    801042a0 <exit>
80104293:	90                   	nop
80104294:	90                   	nop
80104295:	90                   	nop
80104296:	90                   	nop
80104297:	90                   	nop
80104298:	90                   	nop
80104299:	90                   	nop
8010429a:	90                   	nop
8010429b:	90                   	nop
8010429c:	90                   	nop
8010429d:	90                   	nop
8010429e:	90                   	nop
8010429f:	90                   	nop

801042a0 <exit>:
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	57                   	push   %edi
801042a4:	56                   	push   %esi
801042a5:	53                   	push   %ebx
801042a6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801042a9:	e8 42 09 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
801042ae:	e8 9d fa ff ff       	call   80103d50 <mycpu>
  p = c->proc;
801042b3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042b9:	e8 72 09 00 00       	call   80104c30 <popcli>
  if(curproc == initproc)
801042be:	39 1d c8 b5 10 80    	cmp    %ebx,0x8010b5c8
801042c4:	8d 73 28             	lea    0x28(%ebx),%esi
801042c7:	8d 7b 68             	lea    0x68(%ebx),%edi
801042ca:	0f 84 37 01 00 00    	je     80104407 <exit+0x167>
    if(curproc->ofile[fd]){
801042d0:	8b 06                	mov    (%esi),%eax
801042d2:	85 c0                	test   %eax,%eax
801042d4:	74 12                	je     801042e8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801042d6:	83 ec 0c             	sub    $0xc,%esp
801042d9:	50                   	push   %eax
801042da:	e8 61 cb ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
801042df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801042e5:	83 c4 10             	add    $0x10,%esp
801042e8:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
801042eb:	39 fe                	cmp    %edi,%esi
801042ed:	75 e1                	jne    801042d0 <exit+0x30>
  begin_op();
801042ef:	e8 bc e8 ff ff       	call   80102bb0 <begin_op>
  iput(curproc->cwd);
801042f4:	83 ec 0c             	sub    $0xc,%esp
801042f7:	ff 73 68             	pushl  0x68(%ebx)
801042fa:	e8 c1 d4 ff ff       	call   801017c0 <iput>
  end_op();
801042ff:	e8 1c e9 ff ff       	call   80102c20 <end_op>
  curproc->cwd = 0;
80104304:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010430b:	c7 04 24 20 7e 11 80 	movl   $0x80117e20,(%esp)
80104312:	e8 a9 09 00 00       	call   80104cc0 <acquire>
  wakeup1(curproc->parent);
80104317:	8b 53 14             	mov    0x14(%ebx),%edx
8010431a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010431d:	b8 54 7e 11 80       	mov    $0x80117e54,%eax
80104322:	eb 10                	jmp    80104334 <exit+0x94>
80104324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104328:	05 e8 00 00 00       	add    $0xe8,%eax
8010432d:	3d 54 b8 11 80       	cmp    $0x8011b854,%eax
80104332:	73 1e                	jae    80104352 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104334:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104338:	75 ee                	jne    80104328 <exit+0x88>
8010433a:	3b 50 20             	cmp    0x20(%eax),%edx
8010433d:	75 e9                	jne    80104328 <exit+0x88>
      p->state = RUNNABLE;
8010433f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104346:	05 e8 00 00 00       	add    $0xe8,%eax
8010434b:	3d 54 b8 11 80       	cmp    $0x8011b854,%eax
80104350:	72 e2                	jb     80104334 <exit+0x94>
      p->parent = initproc;
80104352:	8b 0d c8 b5 10 80    	mov    0x8010b5c8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104358:	ba 54 7e 11 80       	mov    $0x80117e54,%edx
8010435d:	eb 0f                	jmp    8010436e <exit+0xce>
8010435f:	90                   	nop
80104360:	81 c2 e8 00 00 00    	add    $0xe8,%edx
80104366:	81 fa 54 b8 11 80    	cmp    $0x8011b854,%edx
8010436c:	73 3a                	jae    801043a8 <exit+0x108>
    if(p->parent == curproc){
8010436e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104371:	75 ed                	jne    80104360 <exit+0xc0>
      if(p->state == ZOMBIE)
80104373:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104377:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010437a:	75 e4                	jne    80104360 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010437c:	b8 54 7e 11 80       	mov    $0x80117e54,%eax
80104381:	eb 11                	jmp    80104394 <exit+0xf4>
80104383:	90                   	nop
80104384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104388:	05 e8 00 00 00       	add    $0xe8,%eax
8010438d:	3d 54 b8 11 80       	cmp    $0x8011b854,%eax
80104392:	73 cc                	jae    80104360 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104394:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104398:	75 ee                	jne    80104388 <exit+0xe8>
8010439a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010439d:	75 e9                	jne    80104388 <exit+0xe8>
      p->state = RUNNABLE;
8010439f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801043a6:	eb e0                	jmp    80104388 <exit+0xe8>
  acquire(&tickslock);
801043a8:	83 ec 0c             	sub    $0xc,%esp
  curproc->state = ZOMBIE;
801043ab:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  acquire(&tickslock);
801043b2:	68 60 b8 11 80       	push   $0x8011b860
801043b7:	e8 04 09 00 00       	call   80104cc0 <acquire>
  curproc->turn_around_time = ticks - curproc->turn_around_time;
801043bc:	a1 a0 c0 11 80       	mov    0x8011c0a0,%eax
801043c1:	2b 83 e0 00 00 00    	sub    0xe0(%ebx),%eax
801043c7:	89 83 e0 00 00 00    	mov    %eax,0xe0(%ebx)
  release(&tickslock);
801043cd:	c7 04 24 60 b8 11 80 	movl   $0x8011b860,(%esp)
801043d4:	e8 a7 09 00 00       	call   80104d80 <release>
  cprintf("pid = %d, turn_around_time=%d, response_time=%d\n", curproc->pid, curproc->turn_around_time, curproc->response_time);
801043d9:	ff b3 dc 00 00 00    	pushl  0xdc(%ebx)
801043df:	ff b3 e0 00 00 00    	pushl  0xe0(%ebx)
801043e5:	ff 73 10             	pushl  0x10(%ebx)
801043e8:	68 7c 81 10 80       	push   $0x8010817c
801043ed:	e8 6e c2 ff ff       	call   80100660 <cprintf>
  sched();
801043f2:	83 c4 20             	add    $0x20,%esp
801043f5:	e8 e6 fd ff ff       	call   801041e0 <sched>
  panic("zombie exit");
801043fa:	83 ec 0c             	sub    $0xc,%esp
801043fd:	68 14 80 10 80       	push   $0x80108014
80104402:	e8 89 bf ff ff       	call   80100390 <panic>
    panic("init exiting");
80104407:	83 ec 0c             	sub    $0xc,%esp
8010440a:	68 07 80 10 80       	push   $0x80108007
8010440f:	e8 7c bf ff ff       	call   80100390 <panic>
80104414:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010441a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104420 <yield>:
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	53                   	push   %ebx
80104424:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104427:	68 20 7e 11 80       	push   $0x80117e20
8010442c:	e8 8f 08 00 00       	call   80104cc0 <acquire>
  pushcli();
80104431:	e8 ba 07 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
80104436:	e8 15 f9 ff ff       	call   80103d50 <mycpu>
  p = c->proc;
8010443b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104441:	e8 ea 07 00 00       	call   80104c30 <popcli>
  myproc()->state = RUNNABLE;
80104446:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010444d:	e8 8e fd ff ff       	call   801041e0 <sched>
  release(&ptable.lock);
80104452:	c7 04 24 20 7e 11 80 	movl   $0x80117e20,(%esp)
80104459:	e8 22 09 00 00       	call   80104d80 <release>
}
8010445e:	83 c4 10             	add    $0x10,%esp
80104461:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104464:	c9                   	leave  
80104465:	c3                   	ret    
80104466:	8d 76 00             	lea    0x0(%esi),%esi
80104469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104470 <sleep>:
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	56                   	push   %esi
80104475:	53                   	push   %ebx
80104476:	83 ec 0c             	sub    $0xc,%esp
80104479:	8b 7d 08             	mov    0x8(%ebp),%edi
8010447c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010447f:	e8 6c 07 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
80104484:	e8 c7 f8 ff ff       	call   80103d50 <mycpu>
  p = c->proc;
80104489:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010448f:	e8 9c 07 00 00       	call   80104c30 <popcli>
  if(p == 0)
80104494:	85 db                	test   %ebx,%ebx
80104496:	0f 84 87 00 00 00    	je     80104523 <sleep+0xb3>
  if(lk == 0)
8010449c:	85 f6                	test   %esi,%esi
8010449e:	74 76                	je     80104516 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801044a0:	81 fe 20 7e 11 80    	cmp    $0x80117e20,%esi
801044a6:	74 50                	je     801044f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801044a8:	83 ec 0c             	sub    $0xc,%esp
801044ab:	68 20 7e 11 80       	push   $0x80117e20
801044b0:	e8 0b 08 00 00       	call   80104cc0 <acquire>
    release(lk);
801044b5:	89 34 24             	mov    %esi,(%esp)
801044b8:	e8 c3 08 00 00       	call   80104d80 <release>
  p->chan = chan;
801044bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801044c7:	e8 14 fd ff ff       	call   801041e0 <sched>
  p->chan = 0;
801044cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801044d3:	c7 04 24 20 7e 11 80 	movl   $0x80117e20,(%esp)
801044da:	e8 a1 08 00 00       	call   80104d80 <release>
    acquire(lk);
801044df:	89 75 08             	mov    %esi,0x8(%ebp)
801044e2:	83 c4 10             	add    $0x10,%esp
}
801044e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044e8:	5b                   	pop    %ebx
801044e9:	5e                   	pop    %esi
801044ea:	5f                   	pop    %edi
801044eb:	5d                   	pop    %ebp
    acquire(lk);
801044ec:	e9 cf 07 00 00       	jmp    80104cc0 <acquire>
801044f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801044f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801044fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104502:	e8 d9 fc ff ff       	call   801041e0 <sched>
  p->chan = 0;
80104507:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010450e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104511:	5b                   	pop    %ebx
80104512:	5e                   	pop    %esi
80104513:	5f                   	pop    %edi
80104514:	5d                   	pop    %ebp
80104515:	c3                   	ret    
    panic("sleep without lk");
80104516:	83 ec 0c             	sub    $0xc,%esp
80104519:	68 20 80 10 80       	push   $0x80108020
8010451e:	e8 6d be ff ff       	call   80100390 <panic>
    panic("sleep");
80104523:	83 ec 0c             	sub    $0xc,%esp
80104526:	68 21 7f 10 80       	push   $0x80107f21
8010452b:	e8 60 be ff ff       	call   80100390 <panic>

80104530 <wait>:
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
  pushcli();
80104535:	e8 b6 06 00 00       	call   80104bf0 <pushcli>
  c = mycpu();
8010453a:	e8 11 f8 ff ff       	call   80103d50 <mycpu>
  p = c->proc;
8010453f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104545:	e8 e6 06 00 00       	call   80104c30 <popcli>
  acquire(&ptable.lock);
8010454a:	83 ec 0c             	sub    $0xc,%esp
8010454d:	68 20 7e 11 80       	push   $0x80117e20
80104552:	e8 69 07 00 00       	call   80104cc0 <acquire>
80104557:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010455a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010455c:	bb 54 7e 11 80       	mov    $0x80117e54,%ebx
80104561:	eb 13                	jmp    80104576 <wait+0x46>
80104563:	90                   	nop
80104564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104568:	81 c3 e8 00 00 00    	add    $0xe8,%ebx
8010456e:	81 fb 54 b8 11 80    	cmp    $0x8011b854,%ebx
80104574:	73 1e                	jae    80104594 <wait+0x64>
      if(p->parent != curproc)
80104576:	39 73 14             	cmp    %esi,0x14(%ebx)
80104579:	75 ed                	jne    80104568 <wait+0x38>
      if(p->state == ZOMBIE){
8010457b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010457f:	74 37                	je     801045b8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104581:	81 c3 e8 00 00 00    	add    $0xe8,%ebx
      havekids = 1;
80104587:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010458c:	81 fb 54 b8 11 80    	cmp    $0x8011b854,%ebx
80104592:	72 e2                	jb     80104576 <wait+0x46>
    if(!havekids || curproc->killed){
80104594:	85 c0                	test   %eax,%eax
80104596:	74 76                	je     8010460e <wait+0xde>
80104598:	8b 46 24             	mov    0x24(%esi),%eax
8010459b:	85 c0                	test   %eax,%eax
8010459d:	75 6f                	jne    8010460e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010459f:	83 ec 08             	sub    $0x8,%esp
801045a2:	68 20 7e 11 80       	push   $0x80117e20
801045a7:	56                   	push   %esi
801045a8:	e8 c3 fe ff ff       	call   80104470 <sleep>
    havekids = 0;
801045ad:	83 c4 10             	add    $0x10,%esp
801045b0:	eb a8                	jmp    8010455a <wait+0x2a>
801045b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801045be:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801045c1:	e8 5a dd ff ff       	call   80102320 <kfree>
        freevm(p->pgdir);
801045c6:	5a                   	pop    %edx
801045c7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801045ca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801045d1:	e8 9a 30 00 00       	call   80107670 <freevm>
        release(&ptable.lock);
801045d6:	c7 04 24 20 7e 11 80 	movl   $0x80117e20,(%esp)
        p->pid = 0;
801045dd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801045e4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801045eb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801045ef:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801045f6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801045fd:	e8 7e 07 00 00       	call   80104d80 <release>
        return pid;
80104602:	83 c4 10             	add    $0x10,%esp
}
80104605:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104608:	89 f0                	mov    %esi,%eax
8010460a:	5b                   	pop    %ebx
8010460b:	5e                   	pop    %esi
8010460c:	5d                   	pop    %ebp
8010460d:	c3                   	ret    
      release(&ptable.lock);
8010460e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104611:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104616:	68 20 7e 11 80       	push   $0x80117e20
8010461b:	e8 60 07 00 00       	call   80104d80 <release>
      return -1;
80104620:	83 c4 10             	add    $0x10,%esp
80104623:	eb e0                	jmp    80104605 <wait+0xd5>
80104625:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	53                   	push   %ebx
80104634:	83 ec 10             	sub    $0x10,%esp
80104637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010463a:	68 20 7e 11 80       	push   $0x80117e20
8010463f:	e8 7c 06 00 00       	call   80104cc0 <acquire>
80104644:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104647:	b8 54 7e 11 80       	mov    $0x80117e54,%eax
8010464c:	eb 0e                	jmp    8010465c <wakeup+0x2c>
8010464e:	66 90                	xchg   %ax,%ax
80104650:	05 e8 00 00 00       	add    $0xe8,%eax
80104655:	3d 54 b8 11 80       	cmp    $0x8011b854,%eax
8010465a:	73 1e                	jae    8010467a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010465c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104660:	75 ee                	jne    80104650 <wakeup+0x20>
80104662:	3b 58 20             	cmp    0x20(%eax),%ebx
80104665:	75 e9                	jne    80104650 <wakeup+0x20>
      p->state = RUNNABLE;
80104667:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010466e:	05 e8 00 00 00       	add    $0xe8,%eax
80104673:	3d 54 b8 11 80       	cmp    $0x8011b854,%eax
80104678:	72 e2                	jb     8010465c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010467a:	c7 45 08 20 7e 11 80 	movl   $0x80117e20,0x8(%ebp)
}
80104681:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104684:	c9                   	leave  
  release(&ptable.lock);
80104685:	e9 f6 06 00 00       	jmp    80104d80 <release>
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104690 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	53                   	push   %ebx
80104694:	83 ec 10             	sub    $0x10,%esp
80104697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010469a:	68 20 7e 11 80       	push   $0x80117e20
8010469f:	e8 1c 06 00 00       	call   80104cc0 <acquire>
801046a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a7:	b8 54 7e 11 80       	mov    $0x80117e54,%eax
801046ac:	eb 0e                	jmp    801046bc <kill+0x2c>
801046ae:	66 90                	xchg   %ax,%ax
801046b0:	05 e8 00 00 00       	add    $0xe8,%eax
801046b5:	3d 54 b8 11 80       	cmp    $0x8011b854,%eax
801046ba:	73 34                	jae    801046f0 <kill+0x60>
    if(p->pid == pid){
801046bc:	39 58 10             	cmp    %ebx,0x10(%eax)
801046bf:	75 ef                	jne    801046b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801046c1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801046c5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801046cc:	75 07                	jne    801046d5 <kill+0x45>
        p->state = RUNNABLE;
801046ce:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801046d5:	83 ec 0c             	sub    $0xc,%esp
801046d8:	68 20 7e 11 80       	push   $0x80117e20
801046dd:	e8 9e 06 00 00       	call   80104d80 <release>
      return 0;
801046e2:	83 c4 10             	add    $0x10,%esp
801046e5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801046e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046ea:	c9                   	leave  
801046eb:	c3                   	ret    
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801046f0:	83 ec 0c             	sub    $0xc,%esp
801046f3:	68 20 7e 11 80       	push   $0x80117e20
801046f8:	e8 83 06 00 00       	call   80104d80 <release>
  return -1;
801046fd:	83 c4 10             	add    $0x10,%esp
80104700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104705:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104708:	c9                   	leave  
80104709:	c3                   	ret    
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104710 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	57                   	push   %edi
80104714:	56                   	push   %esi
80104715:	53                   	push   %ebx
80104716:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104719:	bb 54 7e 11 80       	mov    $0x80117e54,%ebx
{
8010471e:	83 ec 3c             	sub    $0x3c,%esp
80104721:	eb 27                	jmp    8010474a <procdump+0x3a>
80104723:	90                   	nop
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104728:	83 ec 0c             	sub    $0xc,%esp
8010472b:	68 63 80 10 80       	push   $0x80108063
80104730:	e8 2b bf ff ff       	call   80100660 <cprintf>
80104735:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104738:	81 c3 e8 00 00 00    	add    $0xe8,%ebx
8010473e:	81 fb 54 b8 11 80    	cmp    $0x8011b854,%ebx
80104744:	0f 83 86 00 00 00    	jae    801047d0 <procdump+0xc0>
    if(p->state == UNUSED)
8010474a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010474d:	85 c0                	test   %eax,%eax
8010474f:	74 e7                	je     80104738 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104751:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104754:	ba 31 80 10 80       	mov    $0x80108031,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104759:	77 11                	ja     8010476c <procdump+0x5c>
8010475b:	8b 14 85 34 81 10 80 	mov    -0x7fef7ecc(,%eax,4),%edx
      state = "???";
80104762:	b8 31 80 10 80       	mov    $0x80108031,%eax
80104767:	85 d2                	test   %edx,%edx
80104769:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010476c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010476f:	50                   	push   %eax
80104770:	52                   	push   %edx
80104771:	ff 73 10             	pushl  0x10(%ebx)
80104774:	68 35 80 10 80       	push   $0x80108035
80104779:	e8 e2 be ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010477e:	83 c4 10             	add    $0x10,%esp
80104781:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104785:	75 a1                	jne    80104728 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104787:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010478a:	83 ec 08             	sub    $0x8,%esp
8010478d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104790:	50                   	push   %eax
80104791:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104794:	8b 40 0c             	mov    0xc(%eax),%eax
80104797:	83 c0 08             	add    $0x8,%eax
8010479a:	50                   	push   %eax
8010479b:	e8 00 04 00 00       	call   80104ba0 <getcallerpcs>
801047a0:	83 c4 10             	add    $0x10,%esp
801047a3:	90                   	nop
801047a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801047a8:	8b 17                	mov    (%edi),%edx
801047aa:	85 d2                	test   %edx,%edx
801047ac:	0f 84 76 ff ff ff    	je     80104728 <procdump+0x18>
        cprintf(" %p", pc[i]);
801047b2:	83 ec 08             	sub    $0x8,%esp
801047b5:	83 c7 04             	add    $0x4,%edi
801047b8:	52                   	push   %edx
801047b9:	68 e1 79 10 80       	push   $0x801079e1
801047be:	e8 9d be ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801047c3:	83 c4 10             	add    $0x10,%esp
801047c6:	39 fe                	cmp    %edi,%esi
801047c8:	75 de                	jne    801047a8 <procdump+0x98>
801047ca:	e9 59 ff ff ff       	jmp    80104728 <procdump+0x18>
801047cf:	90                   	nop
  }
}
801047d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047d3:	5b                   	pop    %ebx
801047d4:	5e                   	pop    %esi
801047d5:	5f                   	pop    %edi
801047d6:	5d                   	pop    %ebp
801047d7:	c3                   	ret    
801047d8:	90                   	nop
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047e0 <log_syscalls>:

int log_syscalls ()
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	57                   	push   %edi
801047e4:	56                   	push   %esi
801047e5:	53                   	push   %ebx
801047e6:	83 ec 28             	sub    $0x28,%esp
  cprintf("log_syscalls called \n");
801047e9:	68 3e 80 10 80       	push   $0x8010803e
801047ee:	e8 6d be ff ff       	call   80100660 <cprintf>
  for (int i = 0; i < rscount; i++)
801047f3:	a1 c4 b5 10 80       	mov    0x8010b5c4,%eax
801047f8:	83 c4 10             	add    $0x10,%esp
801047fb:	85 c0                	test   %eax,%eax
801047fd:	0f 8e bc 00 00 00    	jle    801048bf <log_syscalls+0xdf>
80104803:	be 78 47 11 80       	mov    $0x80114778,%esi
80104808:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010480f:	90                   	nop
  {
    cprintf("name: %s , id: %d,  pid: %d, time: ", syscalls_history.sf[i].name, syscalls_history.sf[i].id, syscalls_history.sf[i].pid);
80104810:	ff 76 e4             	pushl  -0x1c(%esi)
80104813:	ff 76 e0             	pushl  -0x20(%esi)
80104816:	ff 76 dc             	pushl  -0x24(%esi)
80104819:	68 b0 81 10 80       	push   $0x801081b0
8010481e:	e8 3d be ff ff       	call   80100660 <cprintf>
    for (int j = 0; j < syscalls_history.sf[i].args_c; j++)
80104823:	8b 46 64             	mov    0x64(%esi),%eax
80104826:	83 c4 10             	add    $0x10,%esp
80104829:	85 c0                	test   %eax,%eax
8010482b:	7e 27                	jle    80104854 <log_syscalls+0x74>
8010482d:	89 f7                	mov    %esi,%edi
8010482f:	31 db                	xor    %ebx,%ebx
80104831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    {
      cprintf("  %s  ", syscalls_history.sf[i].args[j]);
80104838:	83 ec 08             	sub    $0x8,%esp
    for (int j = 0; j < syscalls_history.sf[i].args_c; j++)
8010483b:	83 c3 01             	add    $0x1,%ebx
      cprintf("  %s  ", syscalls_history.sf[i].args[j]);
8010483e:	57                   	push   %edi
8010483f:	68 54 80 10 80       	push   $0x80108054
80104844:	83 c7 0a             	add    $0xa,%edi
80104847:	e8 14 be ff ff       	call   80100660 <cprintf>
    for (int j = 0; j < syscalls_history.sf[i].args_c; j++)
8010484c:	83 c4 10             	add    $0x10,%esp
8010484f:	39 5e 64             	cmp    %ebx,0x64(%esi)
80104852:	7f e4                	jg     80104838 <log_syscalls+0x58>
    }
    cprintf("\n");
80104854:	83 ec 0c             	sub    $0xc,%esp
80104857:	81 c6 8c 00 00 00    	add    $0x8c,%esi
8010485d:	68 63 80 10 80       	push   $0x80108063
80104862:	e8 f9 bd ff ff       	call   80100660 <cprintf>
    cprintf("%d:", syscalls_history.sf[i].date.hour);
80104867:	58                   	pop    %eax
80104868:	5a                   	pop    %edx
80104869:	ff b6 64 ff ff ff    	pushl  -0x9c(%esi)
8010486f:	68 5b 80 10 80       	push   $0x8010805b
80104874:	e8 e7 bd ff ff       	call   80100660 <cprintf>
    cprintf("%d:", syscalls_history.sf[i].date.minute);
80104879:	59                   	pop    %ecx
8010487a:	5b                   	pop    %ebx
8010487b:	ff b6 60 ff ff ff    	pushl  -0xa0(%esi)
80104881:	68 5b 80 10 80       	push   $0x8010805b
80104886:	e8 d5 bd ff ff       	call   80100660 <cprintf>
    cprintf("%d", syscalls_history.sf[i].date.second);
8010488b:	5f                   	pop    %edi
8010488c:	58                   	pop    %eax
8010488d:	ff b6 5c ff ff ff    	pushl  -0xa4(%esi)
80104893:	68 5f 80 10 80       	push   $0x8010805f
80104898:	e8 c3 bd ff ff       	call   80100660 <cprintf>
    cprintf("\n\n");
8010489d:	c7 04 24 62 80 10 80 	movl   $0x80108062,(%esp)
801048a4:	e8 b7 bd ff ff       	call   80100660 <cprintf>
  for (int i = 0; i < rscount; i++)
801048a9:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801048ad:	83 c4 10             	add    $0x10,%esp
801048b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801048b3:	39 05 c4 b5 10 80    	cmp    %eax,0x8010b5c4
801048b9:	0f 8f 51 ff ff ff    	jg     80104810 <log_syscalls+0x30>
  }
  return 23;
}
801048bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048c2:	b8 17 00 00 00       	mov    $0x17,%eax
801048c7:	5b                   	pop    %ebx
801048c8:	5e                   	pop    %esi
801048c9:	5f                   	pop    %edi
801048ca:	5d                   	pop    %ebp
801048cb:	c3                   	ret    
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048d0 <invoked_syscalls>:

int
invoked_syscalls(int pid)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	57                   	push   %edi
801048d4:	56                   	push   %esi
801048d5:	53                   	push   %ebx
801048d6:	83 ec 24             	sub    $0x24,%esp
    cprintf("invoked_syscalls called with %d \n", pid);
801048d9:	ff 75 08             	pushl  0x8(%ebp)
801048dc:	68 d4 81 10 80       	push   $0x801081d4
801048e1:	e8 7a bd ff ff       	call   80100660 <cprintf>
    if (pid > 0 && pid < nextpid)
801048e6:	8b 75 08             	mov    0x8(%ebp),%esi
801048e9:	83 c4 10             	add    $0x10,%esp
801048ec:	85 f6                	test   %esi,%esi
801048ee:	0f 8e 9c 00 00 00    	jle    80104990 <invoked_syscalls+0xc0>
801048f4:	8b 45 08             	mov    0x8(%ebp),%eax
801048f7:	39 05 04 b0 10 80    	cmp    %eax,0x8010b004
801048fd:	0f 8e 8d 00 00 00    	jle    80104990 <invoked_syscalls+0xc0>
    {
      for (int i = 0; i < rscount; i++)
80104903:	8b 1d c4 b5 10 80    	mov    0x8010b5c4,%ebx
80104909:	85 db                	test   %ebx,%ebx
8010490b:	7e 28                	jle    80104935 <invoked_syscalls+0x65>
8010490d:	bb 54 47 11 80       	mov    $0x80114754,%ebx
80104912:	31 f6                	xor    %esi,%esi
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      {
        if (pid == syscalls_history.sf[i].pid)
80104918:	8b 45 08             	mov    0x8(%ebp),%eax
8010491b:	39 43 08             	cmp    %eax,0x8(%ebx)
8010491e:	0f 84 89 00 00 00    	je     801049ad <invoked_syscalls+0xdd>
      for (int i = 0; i < rscount; i++)
80104924:	83 c6 01             	add    $0x1,%esi
80104927:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
8010492d:	39 35 c4 b5 10 80    	cmp    %esi,0x8010b5c4
80104933:	7f e3                	jg     80104918 <invoked_syscalls+0x48>
        {
          cprintf("name: %s , id: %d,  pid: %d,", syscalls_history.sf[i].name, syscalls_history.sf[i].id, syscalls_history.sf[i].pid);
          for (int j=0; j<syscalls_history.sf[i].args_c ; j++)
80104935:	31 ff                	xor    %edi,%edi
80104937:	eb 15                	jmp    8010494e <invoked_syscalls+0x7e>
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104940:	81 c7 e8 00 00 00    	add    $0xe8,%edi
          cprintf("%d:", syscalls_history.sf[i].date.minute);
          cprintf("%d", syscalls_history.sf[i].date.second);
          cprintf("\n\n");
        }
      }
      for (int i = 0; i < NPROC; i++)
80104946:	81 ff 00 3a 00 00    	cmp    $0x3a00,%edi
8010494c:	74 52                	je     801049a0 <invoked_syscalls+0xd0>
      {
        if (ptable.proc[i].pid == pid)
8010494e:	8b 45 08             	mov    0x8(%ebp),%eax
80104951:	39 87 64 7e 11 80    	cmp    %eax,-0x7fee819c(%edi)
80104957:	75 e7                	jne    80104940 <invoked_syscalls+0x70>
        {
          for (int id = 0; id < MAXSYSCALL; id++)
80104959:	31 db                	xor    %ebx,%ebx
8010495b:	90                   	nop
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          {
            if (ptable.proc[i].syscall_count[id] > 0)
80104960:	8b b4 9f d0 7e 11 80 	mov    -0x7fee8130(%edi,%ebx,4),%esi
80104967:	85 f6                	test   %esi,%esi
80104969:	7e 1b                	jle    80104986 <invoked_syscalls+0xb6>
            {
              cprintf(" %s  %d\n", getName(id), ptable.proc[i].syscall_count[id]);
8010496b:	83 ec 0c             	sub    $0xc,%esp
8010496e:	53                   	push   %ebx
8010496f:	e8 1c ee ff ff       	call   80103790 <getName>
80104974:	83 c4 0c             	add    $0xc,%esp
80104977:	56                   	push   %esi
80104978:	50                   	push   %eax
80104979:	68 89 80 10 80       	push   $0x80108089
8010497e:	e8 dd bc ff ff       	call   80100660 <cprintf>
80104983:	83 c4 10             	add    $0x10,%esp
          for (int id = 0; id < MAXSYSCALL; id++)
80104986:	83 c3 01             	add    $0x1,%ebx
80104989:	83 fb 17             	cmp    $0x17,%ebx
8010498c:	75 d2                	jne    80104960 <invoked_syscalls+0x90>
8010498e:	eb b0                	jmp    80104940 <invoked_syscalls+0x70>
        }
      }
    }
    else
    {
      cprintf("procces dosent created!");
80104990:	83 ec 0c             	sub    $0xc,%esp
80104993:	68 92 80 10 80       	push   $0x80108092
80104998:	e8 c3 bc ff ff       	call   80100660 <cprintf>
8010499d:	83 c4 10             	add    $0x10,%esp
    }
    
    return 22;
    // TODO implement printing process that system called
}
801049a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049a3:	b8 16 00 00 00       	mov    $0x16,%eax
801049a8:	5b                   	pop    %ebx
801049a9:	5e                   	pop    %esi
801049aa:	5f                   	pop    %edi
801049ab:	5d                   	pop    %ebp
801049ac:	c3                   	ret    
          cprintf("name: %s , id: %d,  pid: %d,", syscalls_history.sf[i].name, syscalls_history.sf[i].id, syscalls_history.sf[i].pid);
801049ad:	50                   	push   %eax
801049ae:	ff 73 04             	pushl  0x4(%ebx)
801049b1:	ff 33                	pushl  (%ebx)
801049b3:	68 65 80 10 80       	push   $0x80108065
801049b8:	e8 a3 bc ff ff       	call   80100660 <cprintf>
          for (int j=0; j<syscalls_history.sf[i].args_c ; j++)
801049bd:	8b 8b 88 00 00 00    	mov    0x88(%ebx),%ecx
801049c3:	83 c4 10             	add    $0x10,%esp
801049c6:	85 c9                	test   %ecx,%ecx
801049c8:	7e 2b                	jle    801049f5 <invoked_syscalls+0x125>
801049ca:	8d 53 24             	lea    0x24(%ebx),%edx
801049cd:	31 ff                	xor    %edi,%edi
801049cf:	90                   	nop
            cprintf("  %s  ", syscalls_history.sf[i].args[j]);
801049d0:	83 ec 08             	sub    $0x8,%esp
801049d3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
          for (int j=0; j<syscalls_history.sf[i].args_c ; j++)
801049d6:	83 c7 01             	add    $0x1,%edi
            cprintf("  %s  ", syscalls_history.sf[i].args[j]);
801049d9:	52                   	push   %edx
801049da:	68 54 80 10 80       	push   $0x80108054
801049df:	e8 7c bc ff ff       	call   80100660 <cprintf>
801049e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
          for (int j=0; j<syscalls_history.sf[i].args_c ; j++)
801049e7:	83 c4 10             	add    $0x10,%esp
801049ea:	83 c2 0a             	add    $0xa,%edx
801049ed:	39 bb 88 00 00 00    	cmp    %edi,0x88(%ebx)
801049f3:	7f db                	jg     801049d0 <invoked_syscalls+0x100>
          cprintf("\n");
801049f5:	83 ec 0c             	sub    $0xc,%esp
801049f8:	68 63 80 10 80       	push   $0x80108063
801049fd:	e8 5e bc ff ff       	call   80100660 <cprintf>
          cprintf("time: ");
80104a02:	c7 04 24 82 80 10 80 	movl   $0x80108082,(%esp)
80104a09:	e8 52 bc ff ff       	call   80100660 <cprintf>
          cprintf("%d:", syscalls_history.sf[i].date.hour);
80104a0e:	58                   	pop    %eax
80104a0f:	5a                   	pop    %edx
80104a10:	ff 73 14             	pushl  0x14(%ebx)
80104a13:	68 5b 80 10 80       	push   $0x8010805b
80104a18:	e8 43 bc ff ff       	call   80100660 <cprintf>
          cprintf("%d:", syscalls_history.sf[i].date.minute);
80104a1d:	59                   	pop    %ecx
80104a1e:	5f                   	pop    %edi
80104a1f:	ff 73 10             	pushl  0x10(%ebx)
80104a22:	68 5b 80 10 80       	push   $0x8010805b
80104a27:	e8 34 bc ff ff       	call   80100660 <cprintf>
          cprintf("%d", syscalls_history.sf[i].date.second);
80104a2c:	58                   	pop    %eax
80104a2d:	5a                   	pop    %edx
80104a2e:	ff 73 0c             	pushl  0xc(%ebx)
80104a31:	68 5f 80 10 80       	push   $0x8010805f
80104a36:	e8 25 bc ff ff       	call   80100660 <cprintf>
          cprintf("\n\n");
80104a3b:	c7 04 24 62 80 10 80 	movl   $0x80108062,(%esp)
80104a42:	e8 19 bc ff ff       	call   80100660 <cprintf>
80104a47:	83 c4 10             	add    $0x10,%esp
80104a4a:	e9 d5 fe ff ff       	jmp    80104924 <invoked_syscalls+0x54>
80104a4f:	90                   	nop

80104a50 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
80104a54:	83 ec 0c             	sub    $0xc,%esp
80104a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a5a:	68 f6 81 10 80       	push   $0x801081f6
80104a5f:	8d 43 04             	lea    0x4(%ebx),%eax
80104a62:	50                   	push   %eax
80104a63:	e8 18 01 00 00       	call   80104b80 <initlock>
  lk->name = name;
80104a68:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104a6b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104a71:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104a74:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104a7b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a81:	c9                   	leave  
80104a82:	c3                   	ret    
80104a83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	53                   	push   %ebx
80104a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a98:	83 ec 0c             	sub    $0xc,%esp
80104a9b:	8d 73 04             	lea    0x4(%ebx),%esi
80104a9e:	56                   	push   %esi
80104a9f:	e8 1c 02 00 00       	call   80104cc0 <acquire>
  while (lk->locked) {
80104aa4:	8b 13                	mov    (%ebx),%edx
80104aa6:	83 c4 10             	add    $0x10,%esp
80104aa9:	85 d2                	test   %edx,%edx
80104aab:	74 16                	je     80104ac3 <acquiresleep+0x33>
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104ab0:	83 ec 08             	sub    $0x8,%esp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
80104ab5:	e8 b6 f9 ff ff       	call   80104470 <sleep>
  while (lk->locked) {
80104aba:	8b 03                	mov    (%ebx),%eax
80104abc:	83 c4 10             	add    $0x10,%esp
80104abf:	85 c0                	test   %eax,%eax
80104ac1:	75 ed                	jne    80104ab0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104ac3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104ac9:	e8 22 f3 ff ff       	call   80103df0 <myproc>
80104ace:	8b 40 10             	mov    0x10(%eax),%eax
80104ad1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104ad4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104ad7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ada:	5b                   	pop    %ebx
80104adb:	5e                   	pop    %esi
80104adc:	5d                   	pop    %ebp
  release(&lk->lk);
80104add:	e9 9e 02 00 00       	jmp    80104d80 <release>
80104ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104af0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104af8:	83 ec 0c             	sub    $0xc,%esp
80104afb:	8d 73 04             	lea    0x4(%ebx),%esi
80104afe:	56                   	push   %esi
80104aff:	e8 bc 01 00 00       	call   80104cc0 <acquire>
  lk->locked = 0;
80104b04:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b0a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b11:	89 1c 24             	mov    %ebx,(%esp)
80104b14:	e8 17 fb ff ff       	call   80104630 <wakeup>
  release(&lk->lk);
80104b19:	89 75 08             	mov    %esi,0x8(%ebp)
80104b1c:	83 c4 10             	add    $0x10,%esp
}
80104b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b22:	5b                   	pop    %ebx
80104b23:	5e                   	pop    %esi
80104b24:	5d                   	pop    %ebp
  release(&lk->lk);
80104b25:	e9 56 02 00 00       	jmp    80104d80 <release>
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b30 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	57                   	push   %edi
80104b34:	56                   	push   %esi
80104b35:	53                   	push   %ebx
80104b36:	31 ff                	xor    %edi,%edi
80104b38:	83 ec 18             	sub    $0x18,%esp
80104b3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104b3e:	8d 73 04             	lea    0x4(%ebx),%esi
80104b41:	56                   	push   %esi
80104b42:	e8 79 01 00 00       	call   80104cc0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104b47:	8b 03                	mov    (%ebx),%eax
80104b49:	83 c4 10             	add    $0x10,%esp
80104b4c:	85 c0                	test   %eax,%eax
80104b4e:	74 13                	je     80104b63 <holdingsleep+0x33>
80104b50:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104b53:	e8 98 f2 ff ff       	call   80103df0 <myproc>
80104b58:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b5b:	0f 94 c0             	sete   %al
80104b5e:	0f b6 c0             	movzbl %al,%eax
80104b61:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104b63:	83 ec 0c             	sub    $0xc,%esp
80104b66:	56                   	push   %esi
80104b67:	e8 14 02 00 00       	call   80104d80 <release>
  return r;
}
80104b6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b6f:	89 f8                	mov    %edi,%eax
80104b71:	5b                   	pop    %ebx
80104b72:	5e                   	pop    %esi
80104b73:	5f                   	pop    %edi
80104b74:	5d                   	pop    %ebp
80104b75:	c3                   	ret    
80104b76:	66 90                	xchg   %ax,%ax
80104b78:	66 90                	xchg   %ax,%ax
80104b7a:	66 90                	xchg   %ax,%ax
80104b7c:	66 90                	xchg   %ax,%ax
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104b89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104b8f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104b92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104b99:	5d                   	pop    %ebp
80104b9a:	c3                   	ret    
80104b9b:	90                   	nop
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ba0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ba0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ba1:	31 d2                	xor    %edx,%edx
{
80104ba3:	89 e5                	mov    %esp,%ebp
80104ba5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104ba6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ba9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104bac:	83 e8 08             	sub    $0x8,%eax
80104baf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bb0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104bb6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104bbc:	77 1a                	ja     80104bd8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104bbe:	8b 58 04             	mov    0x4(%eax),%ebx
80104bc1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104bc4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104bc7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104bc9:	83 fa 0a             	cmp    $0xa,%edx
80104bcc:	75 e2                	jne    80104bb0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104bce:	5b                   	pop    %ebx
80104bcf:	5d                   	pop    %ebp
80104bd0:	c3                   	ret    
80104bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bd8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104bdb:	83 c1 28             	add    $0x28,%ecx
80104bde:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104be0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104be6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104be9:	39 c1                	cmp    %eax,%ecx
80104beb:	75 f3                	jne    80104be0 <getcallerpcs+0x40>
}
80104bed:	5b                   	pop    %ebx
80104bee:	5d                   	pop    %ebp
80104bef:	c3                   	ret    

80104bf0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	53                   	push   %ebx
80104bf4:	83 ec 04             	sub    $0x4,%esp
80104bf7:	9c                   	pushf  
80104bf8:	5b                   	pop    %ebx
  asm volatile("cli");
80104bf9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104bfa:	e8 51 f1 ff ff       	call   80103d50 <mycpu>
80104bff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c05:	85 c0                	test   %eax,%eax
80104c07:	75 11                	jne    80104c1a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104c09:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104c0f:	e8 3c f1 ff ff       	call   80103d50 <mycpu>
80104c14:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104c1a:	e8 31 f1 ff ff       	call   80103d50 <mycpu>
80104c1f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c26:	83 c4 04             	add    $0x4,%esp
80104c29:	5b                   	pop    %ebx
80104c2a:	5d                   	pop    %ebp
80104c2b:	c3                   	ret    
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c30 <popcli>:

void
popcli(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c36:	9c                   	pushf  
80104c37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c38:	f6 c4 02             	test   $0x2,%ah
80104c3b:	75 35                	jne    80104c72 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c3d:	e8 0e f1 ff ff       	call   80103d50 <mycpu>
80104c42:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c49:	78 34                	js     80104c7f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c4b:	e8 00 f1 ff ff       	call   80103d50 <mycpu>
80104c50:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104c56:	85 d2                	test   %edx,%edx
80104c58:	74 06                	je     80104c60 <popcli+0x30>
    sti();
}
80104c5a:	c9                   	leave  
80104c5b:	c3                   	ret    
80104c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c60:	e8 eb f0 ff ff       	call   80103d50 <mycpu>
80104c65:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104c6b:	85 c0                	test   %eax,%eax
80104c6d:	74 eb                	je     80104c5a <popcli+0x2a>
  asm volatile("sti");
80104c6f:	fb                   	sti    
}
80104c70:	c9                   	leave  
80104c71:	c3                   	ret    
    panic("popcli - interruptible");
80104c72:	83 ec 0c             	sub    $0xc,%esp
80104c75:	68 01 82 10 80       	push   $0x80108201
80104c7a:	e8 11 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104c7f:	83 ec 0c             	sub    $0xc,%esp
80104c82:	68 18 82 10 80       	push   $0x80108218
80104c87:	e8 04 b7 ff ff       	call   80100390 <panic>
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c90 <holding>:
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
80104c95:	8b 75 08             	mov    0x8(%ebp),%esi
80104c98:	31 db                	xor    %ebx,%ebx
  pushcli();
80104c9a:	e8 51 ff ff ff       	call   80104bf0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104c9f:	8b 06                	mov    (%esi),%eax
80104ca1:	85 c0                	test   %eax,%eax
80104ca3:	74 10                	je     80104cb5 <holding+0x25>
80104ca5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104ca8:	e8 a3 f0 ff ff       	call   80103d50 <mycpu>
80104cad:	39 c3                	cmp    %eax,%ebx
80104caf:	0f 94 c3             	sete   %bl
80104cb2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104cb5:	e8 76 ff ff ff       	call   80104c30 <popcli>
}
80104cba:	89 d8                	mov    %ebx,%eax
80104cbc:	5b                   	pop    %ebx
80104cbd:	5e                   	pop    %esi
80104cbe:	5d                   	pop    %ebp
80104cbf:	c3                   	ret    

80104cc0 <acquire>:
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104cc5:	e8 26 ff ff ff       	call   80104bf0 <pushcli>
  if(holding(lk))
80104cca:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ccd:	83 ec 0c             	sub    $0xc,%esp
80104cd0:	53                   	push   %ebx
80104cd1:	e8 ba ff ff ff       	call   80104c90 <holding>
80104cd6:	83 c4 10             	add    $0x10,%esp
80104cd9:	85 c0                	test   %eax,%eax
80104cdb:	0f 85 83 00 00 00    	jne    80104d64 <acquire+0xa4>
80104ce1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104ce3:	ba 01 00 00 00       	mov    $0x1,%edx
80104ce8:	eb 09                	jmp    80104cf3 <acquire+0x33>
80104cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cf0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cf3:	89 d0                	mov    %edx,%eax
80104cf5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104cf8:	85 c0                	test   %eax,%eax
80104cfa:	75 f4                	jne    80104cf0 <acquire+0x30>
  __sync_synchronize();
80104cfc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104d01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d04:	e8 47 f0 ff ff       	call   80103d50 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104d09:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104d0c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104d0f:	89 e8                	mov    %ebp,%eax
80104d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d18:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104d1e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104d24:	77 1a                	ja     80104d40 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104d26:	8b 48 04             	mov    0x4(%eax),%ecx
80104d29:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104d2c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104d2f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d31:	83 fe 0a             	cmp    $0xa,%esi
80104d34:	75 e2                	jne    80104d18 <acquire+0x58>
}
80104d36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d39:	5b                   	pop    %ebx
80104d3a:	5e                   	pop    %esi
80104d3b:	5d                   	pop    %ebp
80104d3c:	c3                   	ret    
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi
80104d40:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104d43:	83 c2 28             	add    $0x28,%edx
80104d46:	8d 76 00             	lea    0x0(%esi),%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104d50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d56:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104d59:	39 d0                	cmp    %edx,%eax
80104d5b:	75 f3                	jne    80104d50 <acquire+0x90>
}
80104d5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d60:	5b                   	pop    %ebx
80104d61:	5e                   	pop    %esi
80104d62:	5d                   	pop    %ebp
80104d63:	c3                   	ret    
    panic("acquire");
80104d64:	83 ec 0c             	sub    $0xc,%esp
80104d67:	68 1f 82 10 80       	push   $0x8010821f
80104d6c:	e8 1f b6 ff ff       	call   80100390 <panic>
80104d71:	eb 0d                	jmp    80104d80 <release>
80104d73:	90                   	nop
80104d74:	90                   	nop
80104d75:	90                   	nop
80104d76:	90                   	nop
80104d77:	90                   	nop
80104d78:	90                   	nop
80104d79:	90                   	nop
80104d7a:	90                   	nop
80104d7b:	90                   	nop
80104d7c:	90                   	nop
80104d7d:	90                   	nop
80104d7e:	90                   	nop
80104d7f:	90                   	nop

80104d80 <release>:
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	53                   	push   %ebx
80104d84:	83 ec 10             	sub    $0x10,%esp
80104d87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104d8a:	53                   	push   %ebx
80104d8b:	e8 00 ff ff ff       	call   80104c90 <holding>
80104d90:	83 c4 10             	add    $0x10,%esp
80104d93:	85 c0                	test   %eax,%eax
80104d95:	74 22                	je     80104db9 <release+0x39>
  lk->pcs[0] = 0;
80104d97:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d9e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104da5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104daa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104db0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104db3:	c9                   	leave  
  popcli();
80104db4:	e9 77 fe ff ff       	jmp    80104c30 <popcli>
    panic("release");
80104db9:	83 ec 0c             	sub    $0xc,%esp
80104dbc:	68 27 82 10 80       	push   $0x80108227
80104dc1:	e8 ca b5 ff ff       	call   80100390 <panic>
80104dc6:	66 90                	xchg   %ax,%ax
80104dc8:	66 90                	xchg   %ax,%ax
80104dca:	66 90                	xchg   %ax,%ax
80104dcc:	66 90                	xchg   %ax,%ax
80104dce:	66 90                	xchg   %ax,%ax

80104dd0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	57                   	push   %edi
80104dd4:	53                   	push   %ebx
80104dd5:	8b 55 08             	mov    0x8(%ebp),%edx
80104dd8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104ddb:	f6 c2 03             	test   $0x3,%dl
80104dde:	75 05                	jne    80104de5 <memset+0x15>
80104de0:	f6 c1 03             	test   $0x3,%cl
80104de3:	74 13                	je     80104df8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104de5:	89 d7                	mov    %edx,%edi
80104de7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dea:	fc                   	cld    
80104deb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104ded:	5b                   	pop    %ebx
80104dee:	89 d0                	mov    %edx,%eax
80104df0:	5f                   	pop    %edi
80104df1:	5d                   	pop    %ebp
80104df2:	c3                   	ret    
80104df3:	90                   	nop
80104df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104df8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104dfc:	c1 e9 02             	shr    $0x2,%ecx
80104dff:	89 f8                	mov    %edi,%eax
80104e01:	89 fb                	mov    %edi,%ebx
80104e03:	c1 e0 18             	shl    $0x18,%eax
80104e06:	c1 e3 10             	shl    $0x10,%ebx
80104e09:	09 d8                	or     %ebx,%eax
80104e0b:	09 f8                	or     %edi,%eax
80104e0d:	c1 e7 08             	shl    $0x8,%edi
80104e10:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104e12:	89 d7                	mov    %edx,%edi
80104e14:	fc                   	cld    
80104e15:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104e17:	5b                   	pop    %ebx
80104e18:	89 d0                	mov    %edx,%eax
80104e1a:	5f                   	pop    %edi
80104e1b:	5d                   	pop    %ebp
80104e1c:	c3                   	ret    
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi

80104e20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
80104e25:	53                   	push   %ebx
80104e26:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104e29:	8b 75 08             	mov    0x8(%ebp),%esi
80104e2c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e2f:	85 db                	test   %ebx,%ebx
80104e31:	74 29                	je     80104e5c <memcmp+0x3c>
    if(*s1 != *s2)
80104e33:	0f b6 16             	movzbl (%esi),%edx
80104e36:	0f b6 0f             	movzbl (%edi),%ecx
80104e39:	38 d1                	cmp    %dl,%cl
80104e3b:	75 2b                	jne    80104e68 <memcmp+0x48>
80104e3d:	b8 01 00 00 00       	mov    $0x1,%eax
80104e42:	eb 14                	jmp    80104e58 <memcmp+0x38>
80104e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e48:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104e4c:	83 c0 01             	add    $0x1,%eax
80104e4f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104e54:	38 ca                	cmp    %cl,%dl
80104e56:	75 10                	jne    80104e68 <memcmp+0x48>
  while(n-- > 0){
80104e58:	39 d8                	cmp    %ebx,%eax
80104e5a:	75 ec                	jne    80104e48 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104e5c:	5b                   	pop    %ebx
  return 0;
80104e5d:	31 c0                	xor    %eax,%eax
}
80104e5f:	5e                   	pop    %esi
80104e60:	5f                   	pop    %edi
80104e61:	5d                   	pop    %ebp
80104e62:	c3                   	ret    
80104e63:	90                   	nop
80104e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104e68:	0f b6 c2             	movzbl %dl,%eax
}
80104e6b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104e6c:	29 c8                	sub    %ecx,%eax
}
80104e6e:	5e                   	pop    %esi
80104e6f:	5f                   	pop    %edi
80104e70:	5d                   	pop    %ebp
80104e71:	c3                   	ret    
80104e72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	56                   	push   %esi
80104e84:	53                   	push   %ebx
80104e85:	8b 45 08             	mov    0x8(%ebp),%eax
80104e88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e8b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104e8e:	39 c3                	cmp    %eax,%ebx
80104e90:	73 26                	jae    80104eb8 <memmove+0x38>
80104e92:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104e95:	39 c8                	cmp    %ecx,%eax
80104e97:	73 1f                	jae    80104eb8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104e99:	85 f6                	test   %esi,%esi
80104e9b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104e9e:	74 0f                	je     80104eaf <memmove+0x2f>
      *--d = *--s;
80104ea0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ea4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104ea7:	83 ea 01             	sub    $0x1,%edx
80104eaa:	83 fa ff             	cmp    $0xffffffff,%edx
80104ead:	75 f1                	jne    80104ea0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104eaf:	5b                   	pop    %ebx
80104eb0:	5e                   	pop    %esi
80104eb1:	5d                   	pop    %ebp
80104eb2:	c3                   	ret    
80104eb3:	90                   	nop
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104eb8:	31 d2                	xor    %edx,%edx
80104eba:	85 f6                	test   %esi,%esi
80104ebc:	74 f1                	je     80104eaf <memmove+0x2f>
80104ebe:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104ec0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ec4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ec7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104eca:	39 d6                	cmp    %edx,%esi
80104ecc:	75 f2                	jne    80104ec0 <memmove+0x40>
}
80104ece:	5b                   	pop    %ebx
80104ecf:	5e                   	pop    %esi
80104ed0:	5d                   	pop    %ebp
80104ed1:	c3                   	ret    
80104ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104ee3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104ee4:	eb 9a                	jmp    80104e80 <memmove>
80104ee6:	8d 76 00             	lea    0x0(%esi),%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ef0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	57                   	push   %edi
80104ef4:	56                   	push   %esi
80104ef5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104ef8:	53                   	push   %ebx
80104ef9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104efc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104eff:	85 ff                	test   %edi,%edi
80104f01:	74 2f                	je     80104f32 <strncmp+0x42>
80104f03:	0f b6 01             	movzbl (%ecx),%eax
80104f06:	0f b6 1e             	movzbl (%esi),%ebx
80104f09:	84 c0                	test   %al,%al
80104f0b:	74 37                	je     80104f44 <strncmp+0x54>
80104f0d:	38 c3                	cmp    %al,%bl
80104f0f:	75 33                	jne    80104f44 <strncmp+0x54>
80104f11:	01 f7                	add    %esi,%edi
80104f13:	eb 13                	jmp    80104f28 <strncmp+0x38>
80104f15:	8d 76 00             	lea    0x0(%esi),%esi
80104f18:	0f b6 01             	movzbl (%ecx),%eax
80104f1b:	84 c0                	test   %al,%al
80104f1d:	74 21                	je     80104f40 <strncmp+0x50>
80104f1f:	0f b6 1a             	movzbl (%edx),%ebx
80104f22:	89 d6                	mov    %edx,%esi
80104f24:	38 d8                	cmp    %bl,%al
80104f26:	75 1c                	jne    80104f44 <strncmp+0x54>
    n--, p++, q++;
80104f28:	8d 56 01             	lea    0x1(%esi),%edx
80104f2b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104f2e:	39 fa                	cmp    %edi,%edx
80104f30:	75 e6                	jne    80104f18 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104f32:	5b                   	pop    %ebx
    return 0;
80104f33:	31 c0                	xor    %eax,%eax
}
80104f35:	5e                   	pop    %esi
80104f36:	5f                   	pop    %edi
80104f37:	5d                   	pop    %ebp
80104f38:	c3                   	ret    
80104f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f40:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104f44:	29 d8                	sub    %ebx,%eax
}
80104f46:	5b                   	pop    %ebx
80104f47:	5e                   	pop    %esi
80104f48:	5f                   	pop    %edi
80104f49:	5d                   	pop    %ebp
80104f4a:	c3                   	ret    
80104f4b:	90                   	nop
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
80104f55:	8b 45 08             	mov    0x8(%ebp),%eax
80104f58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104f5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104f5e:	89 c2                	mov    %eax,%edx
80104f60:	eb 19                	jmp    80104f7b <strncpy+0x2b>
80104f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f68:	83 c3 01             	add    $0x1,%ebx
80104f6b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104f6f:	83 c2 01             	add    $0x1,%edx
80104f72:	84 c9                	test   %cl,%cl
80104f74:	88 4a ff             	mov    %cl,-0x1(%edx)
80104f77:	74 09                	je     80104f82 <strncpy+0x32>
80104f79:	89 f1                	mov    %esi,%ecx
80104f7b:	85 c9                	test   %ecx,%ecx
80104f7d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104f80:	7f e6                	jg     80104f68 <strncpy+0x18>
    ;
  while(n-- > 0)
80104f82:	31 c9                	xor    %ecx,%ecx
80104f84:	85 f6                	test   %esi,%esi
80104f86:	7e 17                	jle    80104f9f <strncpy+0x4f>
80104f88:	90                   	nop
80104f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104f90:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104f94:	89 f3                	mov    %esi,%ebx
80104f96:	83 c1 01             	add    $0x1,%ecx
80104f99:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104f9b:	85 db                	test   %ebx,%ebx
80104f9d:	7f f1                	jg     80104f90 <strncpy+0x40>
  return os;
}
80104f9f:	5b                   	pop    %ebx
80104fa0:	5e                   	pop    %esi
80104fa1:	5d                   	pop    %ebp
80104fa2:	c3                   	ret    
80104fa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fb0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	53                   	push   %ebx
80104fb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104fb8:	8b 45 08             	mov    0x8(%ebp),%eax
80104fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104fbe:	85 c9                	test   %ecx,%ecx
80104fc0:	7e 26                	jle    80104fe8 <safestrcpy+0x38>
80104fc2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104fc6:	89 c1                	mov    %eax,%ecx
80104fc8:	eb 17                	jmp    80104fe1 <safestrcpy+0x31>
80104fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104fd0:	83 c2 01             	add    $0x1,%edx
80104fd3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104fd7:	83 c1 01             	add    $0x1,%ecx
80104fda:	84 db                	test   %bl,%bl
80104fdc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104fdf:	74 04                	je     80104fe5 <safestrcpy+0x35>
80104fe1:	39 f2                	cmp    %esi,%edx
80104fe3:	75 eb                	jne    80104fd0 <safestrcpy+0x20>
    ;
  *s = 0;
80104fe5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104fe8:	5b                   	pop    %ebx
80104fe9:	5e                   	pop    %esi
80104fea:	5d                   	pop    %ebp
80104feb:	c3                   	ret    
80104fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ff0 <strlen>:

int
strlen(const char *s)
{
80104ff0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ff1:	31 c0                	xor    %eax,%eax
{
80104ff3:	89 e5                	mov    %esp,%ebp
80104ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ff8:	80 3a 00             	cmpb   $0x0,(%edx)
80104ffb:	74 0c                	je     80105009 <strlen+0x19>
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
80105000:	83 c0 01             	add    $0x1,%eax
80105003:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105007:	75 f7                	jne    80105000 <strlen+0x10>
    ;
  return n;
}
80105009:	5d                   	pop    %ebp
8010500a:	c3                   	ret    

8010500b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010500b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010500f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105013:	55                   	push   %ebp
  pushl %ebx
80105014:	53                   	push   %ebx
  pushl %esi
80105015:	56                   	push   %esi
  pushl %edi
80105016:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105017:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105019:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010501b:	5f                   	pop    %edi
  popl %esi
8010501c:	5e                   	pop    %esi
  popl %ebx
8010501d:	5b                   	pop    %ebx
  popl %ebp
8010501e:	5d                   	pop    %ebp
  ret
8010501f:	c3                   	ret    

80105020 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	53                   	push   %ebx
80105024:	83 ec 04             	sub    $0x4,%esp
80105027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010502a:	e8 c1 ed ff ff       	call   80103df0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010502f:	8b 00                	mov    (%eax),%eax
80105031:	39 d8                	cmp    %ebx,%eax
80105033:	76 1b                	jbe    80105050 <fetchint+0x30>
80105035:	8d 53 04             	lea    0x4(%ebx),%edx
80105038:	39 d0                	cmp    %edx,%eax
8010503a:	72 14                	jb     80105050 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010503c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010503f:	8b 13                	mov    (%ebx),%edx
80105041:	89 10                	mov    %edx,(%eax)
  return 0;
80105043:	31 c0                	xor    %eax,%eax
}
80105045:	83 c4 04             	add    $0x4,%esp
80105048:	5b                   	pop    %ebx
80105049:	5d                   	pop    %ebp
8010504a:	c3                   	ret    
8010504b:	90                   	nop
8010504c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105055:	eb ee                	jmp    80105045 <fetchint+0x25>
80105057:	89 f6                	mov    %esi,%esi
80105059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105060 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	53                   	push   %ebx
80105064:	83 ec 04             	sub    $0x4,%esp
80105067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010506a:	e8 81 ed ff ff       	call   80103df0 <myproc>

  if(addr >= curproc->sz)
8010506f:	39 18                	cmp    %ebx,(%eax)
80105071:	76 29                	jbe    8010509c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105073:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105076:	89 da                	mov    %ebx,%edx
80105078:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010507a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010507c:	39 c3                	cmp    %eax,%ebx
8010507e:	73 1c                	jae    8010509c <fetchstr+0x3c>
    if(*s == 0)
80105080:	80 3b 00             	cmpb   $0x0,(%ebx)
80105083:	75 10                	jne    80105095 <fetchstr+0x35>
80105085:	eb 39                	jmp    801050c0 <fetchstr+0x60>
80105087:	89 f6                	mov    %esi,%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105090:	80 3a 00             	cmpb   $0x0,(%edx)
80105093:	74 1b                	je     801050b0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105095:	83 c2 01             	add    $0x1,%edx
80105098:	39 d0                	cmp    %edx,%eax
8010509a:	77 f4                	ja     80105090 <fetchstr+0x30>
    return -1;
8010509c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801050a1:	83 c4 04             	add    $0x4,%esp
801050a4:	5b                   	pop    %ebx
801050a5:	5d                   	pop    %ebp
801050a6:	c3                   	ret    
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801050b0:	83 c4 04             	add    $0x4,%esp
801050b3:	89 d0                	mov    %edx,%eax
801050b5:	29 d8                	sub    %ebx,%eax
801050b7:	5b                   	pop    %ebx
801050b8:	5d                   	pop    %ebp
801050b9:	c3                   	ret    
801050ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801050c0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801050c2:	eb dd                	jmp    801050a1 <fetchstr+0x41>
801050c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801050d0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	56                   	push   %esi
801050d4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050d5:	e8 16 ed ff ff       	call   80103df0 <myproc>
801050da:	8b 40 18             	mov    0x18(%eax),%eax
801050dd:	8b 55 08             	mov    0x8(%ebp),%edx
801050e0:	8b 40 44             	mov    0x44(%eax),%eax
801050e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801050e6:	e8 05 ed ff ff       	call   80103df0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050eb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801050ed:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050f0:	39 c6                	cmp    %eax,%esi
801050f2:	73 1c                	jae    80105110 <argint+0x40>
801050f4:	8d 53 08             	lea    0x8(%ebx),%edx
801050f7:	39 d0                	cmp    %edx,%eax
801050f9:	72 15                	jb     80105110 <argint+0x40>
  *ip = *(int*)(addr);
801050fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801050fe:	8b 53 04             	mov    0x4(%ebx),%edx
80105101:	89 10                	mov    %edx,(%eax)
  return 0;
80105103:	31 c0                	xor    %eax,%eax
}
80105105:	5b                   	pop    %ebx
80105106:	5e                   	pop    %esi
80105107:	5d                   	pop    %ebp
80105108:	c3                   	ret    
80105109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105115:	eb ee                	jmp    80105105 <argint+0x35>
80105117:	89 f6                	mov    %esi,%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	83 ec 10             	sub    $0x10,%esp
80105128:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010512b:	e8 c0 ec ff ff       	call   80103df0 <myproc>
80105130:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105132:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105135:	83 ec 08             	sub    $0x8,%esp
80105138:	50                   	push   %eax
80105139:	ff 75 08             	pushl  0x8(%ebp)
8010513c:	e8 8f ff ff ff       	call   801050d0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105141:	83 c4 10             	add    $0x10,%esp
80105144:	85 c0                	test   %eax,%eax
80105146:	78 28                	js     80105170 <argptr+0x50>
80105148:	85 db                	test   %ebx,%ebx
8010514a:	78 24                	js     80105170 <argptr+0x50>
8010514c:	8b 16                	mov    (%esi),%edx
8010514e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105151:	39 c2                	cmp    %eax,%edx
80105153:	76 1b                	jbe    80105170 <argptr+0x50>
80105155:	01 c3                	add    %eax,%ebx
80105157:	39 da                	cmp    %ebx,%edx
80105159:	72 15                	jb     80105170 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010515b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010515e:	89 02                	mov    %eax,(%edx)
  return 0;
80105160:	31 c0                	xor    %eax,%eax
}
80105162:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105165:	5b                   	pop    %ebx
80105166:	5e                   	pop    %esi
80105167:	5d                   	pop    %ebp
80105168:	c3                   	ret    
80105169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105175:	eb eb                	jmp    80105162 <argptr+0x42>
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105186:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105189:	50                   	push   %eax
8010518a:	ff 75 08             	pushl  0x8(%ebp)
8010518d:	e8 3e ff ff ff       	call   801050d0 <argint>
80105192:	83 c4 10             	add    $0x10,%esp
80105195:	85 c0                	test   %eax,%eax
80105197:	78 17                	js     801051b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105199:	83 ec 08             	sub    $0x8,%esp
8010519c:	ff 75 0c             	pushl  0xc(%ebp)
8010519f:	ff 75 f4             	pushl  -0xc(%ebp)
801051a2:	e8 b9 fe ff ff       	call   80105060 <fetchstr>
801051a7:	83 c4 10             	add    $0x10,%esp
}
801051aa:	c9                   	leave  
801051ab:	c3                   	ret    
801051ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801051b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051b5:	c9                   	leave  
801051b6:	c3                   	ret    
801051b7:	89 f6                	mov    %esi,%esi
801051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051c0 <syscall>:
[SYS_log_syscalls]   sys_log_syscalls,
};

void
syscall(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	56                   	push   %esi
801051c4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801051c5:	e8 26 ec ff ff       	call   80103df0 <myproc>
801051ca:	89 c3                	mov    %eax,%ebx
// put time here?
  num = curproc->tf->eax;
801051cc:	8b 40 18             	mov    0x18(%eax),%eax
801051cf:	8b 70 1c             	mov    0x1c(%eax),%esi
  if (num > 0 && num < NELEM(syscalls) && syscalls[num])
801051d2:	8d 46 ff             	lea    -0x1(%esi),%eax
801051d5:	83 f8 16             	cmp    $0x16,%eax
801051d8:	77 36                	ja     80105210 <syscall+0x50>
801051da:	8b 04 b5 60 82 10 80 	mov    -0x7fef7da0(,%esi,4),%eax
801051e1:	85 c0                	test   %eax,%eax
801051e3:	74 2b                	je     80105210 <syscall+0x50>
  {
    curproc->tf->eax = syscalls[num]();
801051e5:	ff d0                	call   *%eax
801051e7:	8b 53 18             	mov    0x18(%ebx),%edx
    register_syscall(curproc->pid, num, getName(num));
801051ea:	83 ec 0c             	sub    $0xc,%esp
    curproc->tf->eax = syscalls[num]();
801051ed:	89 42 1c             	mov    %eax,0x1c(%edx)
    register_syscall(curproc->pid, num, getName(num));
801051f0:	56                   	push   %esi
801051f1:	e8 9a e5 ff ff       	call   80103790 <getName>
801051f6:	83 c4 0c             	add    $0xc,%esp
801051f9:	50                   	push   %eax
801051fa:	56                   	push   %esi
801051fb:	ff 73 10             	pushl  0x10(%ebx)
801051fe:	e8 cd e9 ff ff       	call   80103bd0 <register_syscall>
80105203:	83 c4 10             	add    $0x10,%esp
  {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105206:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105209:	5b                   	pop    %ebx
8010520a:	5e                   	pop    %esi
8010520b:	5d                   	pop    %ebp
8010520c:	c3                   	ret    
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
            curproc->pid, curproc->name, num);
80105210:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105213:	56                   	push   %esi
80105214:	50                   	push   %eax
80105215:	ff 73 10             	pushl  0x10(%ebx)
80105218:	68 2f 82 10 80       	push   $0x8010822f
8010521d:	e8 3e b4 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80105222:	8b 43 18             	mov    0x18(%ebx),%eax
80105225:	83 c4 10             	add    $0x10,%esp
80105228:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010522f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105232:	5b                   	pop    %ebx
80105233:	5e                   	pop    %esi
80105234:	5d                   	pop    %ebp
80105235:	c3                   	ret    
80105236:	66 90                	xchg   %ax,%ax
80105238:	66 90                	xchg   %ax,%ax
8010523a:	66 90                	xchg   %ax,%ax
8010523c:	66 90                	xchg   %ax,%ax
8010523e:	66 90                	xchg   %ax,%ax

80105240 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	57                   	push   %edi
80105244:	56                   	push   %esi
80105245:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105246:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105249:	83 ec 44             	sub    $0x44,%esp
8010524c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010524f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105252:	56                   	push   %esi
80105253:	50                   	push   %eax
{
80105254:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105257:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010525a:	e8 b1 cc ff ff       	call   80101f10 <nameiparent>
8010525f:	83 c4 10             	add    $0x10,%esp
80105262:	85 c0                	test   %eax,%eax
80105264:	0f 84 46 01 00 00    	je     801053b0 <create+0x170>
    return 0;
  ilock(dp);
8010526a:	83 ec 0c             	sub    $0xc,%esp
8010526d:	89 c3                	mov    %eax,%ebx
8010526f:	50                   	push   %eax
80105270:	e8 1b c4 ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105275:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105278:	83 c4 0c             	add    $0xc,%esp
8010527b:	50                   	push   %eax
8010527c:	56                   	push   %esi
8010527d:	53                   	push   %ebx
8010527e:	e8 3d c9 ff ff       	call   80101bc0 <dirlookup>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	89 c7                	mov    %eax,%edi
8010528a:	74 34                	je     801052c0 <create+0x80>
    iunlockput(dp);
8010528c:	83 ec 0c             	sub    $0xc,%esp
8010528f:	53                   	push   %ebx
80105290:	e8 8b c6 ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80105295:	89 3c 24             	mov    %edi,(%esp)
80105298:	e8 f3 c3 ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010529d:	83 c4 10             	add    $0x10,%esp
801052a0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801052a5:	0f 85 95 00 00 00    	jne    80105340 <create+0x100>
801052ab:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801052b0:	0f 85 8a 00 00 00    	jne    80105340 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801052b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052b9:	89 f8                	mov    %edi,%eax
801052bb:	5b                   	pop    %ebx
801052bc:	5e                   	pop    %esi
801052bd:	5f                   	pop    %edi
801052be:	5d                   	pop    %ebp
801052bf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801052c0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801052c4:	83 ec 08             	sub    $0x8,%esp
801052c7:	50                   	push   %eax
801052c8:	ff 33                	pushl  (%ebx)
801052ca:	e8 51 c2 ff ff       	call   80101520 <ialloc>
801052cf:	83 c4 10             	add    $0x10,%esp
801052d2:	85 c0                	test   %eax,%eax
801052d4:	89 c7                	mov    %eax,%edi
801052d6:	0f 84 e8 00 00 00    	je     801053c4 <create+0x184>
  ilock(ip);
801052dc:	83 ec 0c             	sub    $0xc,%esp
801052df:	50                   	push   %eax
801052e0:	e8 ab c3 ff ff       	call   80101690 <ilock>
  ip->major = major;
801052e5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801052e9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801052ed:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801052f1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
801052f5:	b8 01 00 00 00       	mov    $0x1,%eax
801052fa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
801052fe:	89 3c 24             	mov    %edi,(%esp)
80105301:	e8 da c2 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105306:	83 c4 10             	add    $0x10,%esp
80105309:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010530e:	74 50                	je     80105360 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105310:	83 ec 04             	sub    $0x4,%esp
80105313:	ff 77 04             	pushl  0x4(%edi)
80105316:	56                   	push   %esi
80105317:	53                   	push   %ebx
80105318:	e8 13 cb ff ff       	call   80101e30 <dirlink>
8010531d:	83 c4 10             	add    $0x10,%esp
80105320:	85 c0                	test   %eax,%eax
80105322:	0f 88 8f 00 00 00    	js     801053b7 <create+0x177>
  iunlockput(dp);
80105328:	83 ec 0c             	sub    $0xc,%esp
8010532b:	53                   	push   %ebx
8010532c:	e8 ef c5 ff ff       	call   80101920 <iunlockput>
  return ip;
80105331:	83 c4 10             	add    $0x10,%esp
}
80105334:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105337:	89 f8                	mov    %edi,%eax
80105339:	5b                   	pop    %ebx
8010533a:	5e                   	pop    %esi
8010533b:	5f                   	pop    %edi
8010533c:	5d                   	pop    %ebp
8010533d:	c3                   	ret    
8010533e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	57                   	push   %edi
    return 0;
80105344:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105346:	e8 d5 c5 ff ff       	call   80101920 <iunlockput>
    return 0;
8010534b:	83 c4 10             	add    $0x10,%esp
}
8010534e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105351:	89 f8                	mov    %edi,%eax
80105353:	5b                   	pop    %ebx
80105354:	5e                   	pop    %esi
80105355:	5f                   	pop    %edi
80105356:	5d                   	pop    %ebp
80105357:	c3                   	ret    
80105358:	90                   	nop
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105360:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105365:	83 ec 0c             	sub    $0xc,%esp
80105368:	53                   	push   %ebx
80105369:	e8 72 c2 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010536e:	83 c4 0c             	add    $0xc,%esp
80105371:	ff 77 04             	pushl  0x4(%edi)
80105374:	68 dc 82 10 80       	push   $0x801082dc
80105379:	57                   	push   %edi
8010537a:	e8 b1 ca ff ff       	call   80101e30 <dirlink>
8010537f:	83 c4 10             	add    $0x10,%esp
80105382:	85 c0                	test   %eax,%eax
80105384:	78 1c                	js     801053a2 <create+0x162>
80105386:	83 ec 04             	sub    $0x4,%esp
80105389:	ff 73 04             	pushl  0x4(%ebx)
8010538c:	68 db 82 10 80       	push   $0x801082db
80105391:	57                   	push   %edi
80105392:	e8 99 ca ff ff       	call   80101e30 <dirlink>
80105397:	83 c4 10             	add    $0x10,%esp
8010539a:	85 c0                	test   %eax,%eax
8010539c:	0f 89 6e ff ff ff    	jns    80105310 <create+0xd0>
      panic("create dots");
801053a2:	83 ec 0c             	sub    $0xc,%esp
801053a5:	68 cf 82 10 80       	push   $0x801082cf
801053aa:	e8 e1 af ff ff       	call   80100390 <panic>
801053af:	90                   	nop
    return 0;
801053b0:	31 ff                	xor    %edi,%edi
801053b2:	e9 ff fe ff ff       	jmp    801052b6 <create+0x76>
    panic("create: dirlink");
801053b7:	83 ec 0c             	sub    $0xc,%esp
801053ba:	68 de 82 10 80       	push   $0x801082de
801053bf:	e8 cc af ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801053c4:	83 ec 0c             	sub    $0xc,%esp
801053c7:	68 c0 82 10 80       	push   $0x801082c0
801053cc:	e8 bf af ff ff       	call   80100390 <panic>
801053d1:	eb 0d                	jmp    801053e0 <argfd.constprop.0>
801053d3:	90                   	nop
801053d4:	90                   	nop
801053d5:	90                   	nop
801053d6:	90                   	nop
801053d7:	90                   	nop
801053d8:	90                   	nop
801053d9:	90                   	nop
801053da:	90                   	nop
801053db:	90                   	nop
801053dc:	90                   	nop
801053dd:	90                   	nop
801053de:	90                   	nop
801053df:	90                   	nop

801053e0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	53                   	push   %ebx
801053e5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801053e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801053ea:	89 d6                	mov    %edx,%esi
801053ec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801053ef:	50                   	push   %eax
801053f0:	6a 00                	push   $0x0
801053f2:	e8 d9 fc ff ff       	call   801050d0 <argint>
801053f7:	83 c4 10             	add    $0x10,%esp
801053fa:	85 c0                	test   %eax,%eax
801053fc:	78 2a                	js     80105428 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053fe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105402:	77 24                	ja     80105428 <argfd.constprop.0+0x48>
80105404:	e8 e7 e9 ff ff       	call   80103df0 <myproc>
80105409:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010540c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105410:	85 c0                	test   %eax,%eax
80105412:	74 14                	je     80105428 <argfd.constprop.0+0x48>
  if(pfd)
80105414:	85 db                	test   %ebx,%ebx
80105416:	74 02                	je     8010541a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105418:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010541a:	89 06                	mov    %eax,(%esi)
  return 0;
8010541c:	31 c0                	xor    %eax,%eax
}
8010541e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105421:	5b                   	pop    %ebx
80105422:	5e                   	pop    %esi
80105423:	5d                   	pop    %ebp
80105424:	c3                   	ret    
80105425:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010542d:	eb ef                	jmp    8010541e <argfd.constprop.0+0x3e>
8010542f:	90                   	nop

80105430 <sys_dup>:
{
80105430:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105431:	31 c0                	xor    %eax,%eax
{
80105433:	89 e5                	mov    %esp,%ebp
80105435:	56                   	push   %esi
80105436:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105437:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010543a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010543d:	e8 9e ff ff ff       	call   801053e0 <argfd.constprop.0>
80105442:	85 c0                	test   %eax,%eax
80105444:	78 42                	js     80105488 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105446:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105449:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010544b:	e8 a0 e9 ff ff       	call   80103df0 <myproc>
80105450:	eb 0e                	jmp    80105460 <sys_dup+0x30>
80105452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105458:	83 c3 01             	add    $0x1,%ebx
8010545b:	83 fb 10             	cmp    $0x10,%ebx
8010545e:	74 28                	je     80105488 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105460:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105464:	85 d2                	test   %edx,%edx
80105466:	75 f0                	jne    80105458 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105468:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010546c:	83 ec 0c             	sub    $0xc,%esp
8010546f:	ff 75 f4             	pushl  -0xc(%ebp)
80105472:	e8 79 b9 ff ff       	call   80100df0 <filedup>
  return fd;
80105477:	83 c4 10             	add    $0x10,%esp
}
8010547a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010547d:	89 d8                	mov    %ebx,%eax
8010547f:	5b                   	pop    %ebx
80105480:	5e                   	pop    %esi
80105481:	5d                   	pop    %ebp
80105482:	c3                   	ret    
80105483:	90                   	nop
80105484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105488:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010548b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105490:	89 d8                	mov    %ebx,%eax
80105492:	5b                   	pop    %ebx
80105493:	5e                   	pop    %esi
80105494:	5d                   	pop    %ebp
80105495:	c3                   	ret    
80105496:	8d 76 00             	lea    0x0(%esi),%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054a0 <itoa>:
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	57                   	push   %edi
801054a4:	56                   	push   %esi
801054a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801054a8:	53                   	push   %ebx
801054a9:	8b 75 08             	mov    0x8(%ebp),%esi
  while (num>0)
801054ac:	85 c9                	test   %ecx,%ecx
801054ae:	7e 2f                	jle    801054df <itoa+0x3f>
  int index=0;
801054b0:	31 db                	xor    %ebx,%ebx
    string[index] = num%10 + '0';
801054b2:	bf cd cc cc cc       	mov    $0xcccccccd,%edi
801054b7:	89 f6                	mov    %esi,%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801054c0:	89 c8                	mov    %ecx,%eax
801054c2:	f7 e7                	mul    %edi
801054c4:	c1 ea 03             	shr    $0x3,%edx
801054c7:	8d 04 92             	lea    (%edx,%edx,4),%eax
801054ca:	01 c0                	add    %eax,%eax
801054cc:	29 c1                	sub    %eax,%ecx
801054ce:	83 c1 30             	add    $0x30,%ecx
801054d1:	88 0c 1e             	mov    %cl,(%esi,%ebx,1)
    index++;
801054d4:	83 c3 01             	add    $0x1,%ebx
  while (num>0)
801054d7:	85 d2                	test   %edx,%edx
    num/=10;
801054d9:	89 d1                	mov    %edx,%ecx
  while (num>0)
801054db:	75 e3                	jne    801054c0 <itoa+0x20>
801054dd:	01 de                	add    %ebx,%esi
  string[index]='\0';
801054df:	c6 06 00             	movb   $0x0,(%esi)
}
801054e2:	5b                   	pop    %ebx
801054e3:	5e                   	pop    %esi
801054e4:	5f                   	pop    %edi
801054e5:	5d                   	pop    %ebp
801054e6:	c3                   	ret    
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054f0 <sys_read>:
{
801054f0:	55                   	push   %ebp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054f1:	31 c0                	xor    %eax,%eax
{
801054f3:	89 e5                	mov    %esp,%ebp
801054f5:	56                   	push   %esi
801054f6:	53                   	push   %ebx
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054f7:	8d 55 ec             	lea    -0x14(%ebp),%edx
{
801054fa:	83 ec 10             	sub    $0x10,%esp
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054fd:	e8 de fe ff ff       	call   801053e0 <argfd.constprop.0>
80105502:	85 c0                	test   %eax,%eax
80105504:	0f 88 e6 00 00 00    	js     801055f0 <sys_read+0x100>
8010550a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010550d:	83 ec 08             	sub    $0x8,%esp
80105510:	50                   	push   %eax
80105511:	6a 02                	push   $0x2
80105513:	e8 b8 fb ff ff       	call   801050d0 <argint>
80105518:	83 c4 10             	add    $0x10,%esp
8010551b:	85 c0                	test   %eax,%eax
8010551d:	0f 88 cd 00 00 00    	js     801055f0 <sys_read+0x100>
80105523:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105526:	83 ec 04             	sub    $0x4,%esp
80105529:	ff 75 f0             	pushl  -0x10(%ebp)
8010552c:	50                   	push   %eax
8010552d:	6a 01                	push   $0x1
8010552f:	e8 ec fb ff ff       	call   80105120 <argptr>
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	85 c0                	test   %eax,%eax
80105539:	0f 88 b1 00 00 00    	js     801055f0 <sys_read+0x100>
  set_last_syscall_info("fd: ");
8010553f:	83 ec 0c             	sub    $0xc,%esp
80105542:	68 ee 82 10 80       	push   $0x801082ee
80105547:	e8 b4 e5 ff ff       	call   80103b00 <set_last_syscall_info>
  set_last_syscall_info("Inode");
8010554c:	c7 04 24 f3 82 10 80 	movl   $0x801082f3,(%esp)
80105553:	e8 a8 e5 ff ff       	call   80103b00 <set_last_syscall_info>
  set_last_syscall_info("ptr: ");
80105558:	c7 04 24 f9 82 10 80 	movl   $0x801082f9,(%esp)
8010555f:	e8 9c e5 ff ff       	call   80103b00 <set_last_syscall_info>
  set_last_syscall_info((char*)p);
80105564:	58                   	pop    %eax
80105565:	ff 75 f4             	pushl  -0xc(%ebp)
80105568:	e8 93 e5 ff ff       	call   80103b00 <set_last_syscall_info>
  set_last_syscall_info("int");
8010556d:	c7 04 24 ff 82 10 80 	movl   $0x801082ff,(%esp)
80105574:	e8 87 e5 ff ff       	call   80103b00 <set_last_syscall_info>
  itoa(temp, n);
80105579:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  while (num>0)
8010557c:	83 c4 10             	add    $0x10,%esp
8010557f:	85 c9                	test   %ecx,%ecx
80105581:	7e 65                	jle    801055e8 <sys_read+0xf8>
  int index=0;
80105583:	31 db                	xor    %ebx,%ebx
    string[index] = num%10 + '0';
80105585:	be cd cc cc cc       	mov    $0xcccccccd,%esi
8010558a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105590:	89 c8                	mov    %ecx,%eax
    index++;
80105592:	83 c3 01             	add    $0x1,%ebx
    string[index] = num%10 + '0';
80105595:	f7 e6                	mul    %esi
80105597:	c1 ea 03             	shr    $0x3,%edx
8010559a:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010559d:	01 c0                	add    %eax,%eax
8010559f:	29 c1                	sub    %eax,%ecx
801055a1:	83 c1 30             	add    $0x30,%ecx
801055a4:	88 8b 0b b0 10 80    	mov    %cl,-0x7fef4ff5(%ebx)
  while (num>0)
801055aa:	85 d2                	test   %edx,%edx
    num/=10;
801055ac:	89 d1                	mov    %edx,%ecx
  while (num>0)
801055ae:	75 e0                	jne    80105590 <sys_read+0xa0>
801055b0:	81 c3 0c b0 10 80    	add    $0x8010b00c,%ebx
  set_last_syscall_info(temp);
801055b6:	83 ec 0c             	sub    $0xc,%esp
  string[index]='\0';
801055b9:	c6 03 00             	movb   $0x0,(%ebx)
  set_last_syscall_info(temp);
801055bc:	68 0c b0 10 80       	push   $0x8010b00c
801055c1:	e8 3a e5 ff ff       	call   80103b00 <set_last_syscall_info>
  return fileread(f, p, n);
801055c6:	83 c4 0c             	add    $0xc,%esp
801055c9:	ff 75 f0             	pushl  -0x10(%ebp)
801055cc:	ff 75 f4             	pushl  -0xc(%ebp)
801055cf:	ff 75 ec             	pushl  -0x14(%ebp)
801055d2:	e8 89 b9 ff ff       	call   80100f60 <fileread>
801055d7:	83 c4 10             	add    $0x10,%esp
}
801055da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055dd:	5b                   	pop    %ebx
801055de:	5e                   	pop    %esi
801055df:	5d                   	pop    %ebp
801055e0:	c3                   	ret    
801055e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while (num>0)
801055e8:	bb 0c b0 10 80       	mov    $0x8010b00c,%ebx
801055ed:	eb c7                	jmp    801055b6 <sys_read+0xc6>
801055ef:	90                   	nop
    return -1;
801055f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f5:	eb e3                	jmp    801055da <sys_read+0xea>
801055f7:	89 f6                	mov    %esi,%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105600 <sys_write>:
{
80105600:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105601:	31 c0                	xor    %eax,%eax
{
80105603:	89 e5                	mov    %esp,%ebp
80105605:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105608:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010560b:	e8 d0 fd ff ff       	call   801053e0 <argfd.constprop.0>
80105610:	85 c0                	test   %eax,%eax
80105612:	78 4c                	js     80105660 <sys_write+0x60>
80105614:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105617:	83 ec 08             	sub    $0x8,%esp
8010561a:	50                   	push   %eax
8010561b:	6a 02                	push   $0x2
8010561d:	e8 ae fa ff ff       	call   801050d0 <argint>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	78 37                	js     80105660 <sys_write+0x60>
80105629:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010562c:	83 ec 04             	sub    $0x4,%esp
8010562f:	ff 75 f0             	pushl  -0x10(%ebp)
80105632:	50                   	push   %eax
80105633:	6a 01                	push   $0x1
80105635:	e8 e6 fa ff ff       	call   80105120 <argptr>
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	85 c0                	test   %eax,%eax
8010563f:	78 1f                	js     80105660 <sys_write+0x60>
  return filewrite(f, p, n);
80105641:	83 ec 04             	sub    $0x4,%esp
80105644:	ff 75 f0             	pushl  -0x10(%ebp)
80105647:	ff 75 f4             	pushl  -0xc(%ebp)
8010564a:	ff 75 ec             	pushl  -0x14(%ebp)
8010564d:	e8 9e b9 ff ff       	call   80100ff0 <filewrite>
80105652:	83 c4 10             	add    $0x10,%esp
}
80105655:	c9                   	leave  
80105656:	c3                   	ret    
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105665:	c9                   	leave  
80105666:	c3                   	ret    
80105667:	89 f6                	mov    %esi,%esi
80105669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105670 <sys_close>:
{
80105670:	55                   	push   %ebp
80105671:	89 e5                	mov    %esp,%ebp
80105673:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105676:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105679:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010567c:	e8 5f fd ff ff       	call   801053e0 <argfd.constprop.0>
80105681:	85 c0                	test   %eax,%eax
80105683:	78 2b                	js     801056b0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105685:	e8 66 e7 ff ff       	call   80103df0 <myproc>
8010568a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010568d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105690:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105697:	00 
  fileclose(f);
80105698:	ff 75 f4             	pushl  -0xc(%ebp)
8010569b:	e8 a0 b7 ff ff       	call   80100e40 <fileclose>
  return 0;
801056a0:	83 c4 10             	add    $0x10,%esp
801056a3:	31 c0                	xor    %eax,%eax
}
801056a5:	c9                   	leave  
801056a6:	c3                   	ret    
801056a7:	89 f6                	mov    %esi,%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801056b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056b5:	c9                   	leave  
801056b6:	c3                   	ret    
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056c0 <sys_fstat>:
{
801056c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056c1:	31 c0                	xor    %eax,%eax
{
801056c3:	89 e5                	mov    %esp,%ebp
801056c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056c8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801056cb:	e8 10 fd ff ff       	call   801053e0 <argfd.constprop.0>
801056d0:	85 c0                	test   %eax,%eax
801056d2:	78 2c                	js     80105700 <sys_fstat+0x40>
801056d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056d7:	83 ec 04             	sub    $0x4,%esp
801056da:	6a 14                	push   $0x14
801056dc:	50                   	push   %eax
801056dd:	6a 01                	push   $0x1
801056df:	e8 3c fa ff ff       	call   80105120 <argptr>
801056e4:	83 c4 10             	add    $0x10,%esp
801056e7:	85 c0                	test   %eax,%eax
801056e9:	78 15                	js     80105700 <sys_fstat+0x40>
  return filestat(f, st);
801056eb:	83 ec 08             	sub    $0x8,%esp
801056ee:	ff 75 f4             	pushl  -0xc(%ebp)
801056f1:	ff 75 f0             	pushl  -0x10(%ebp)
801056f4:	e8 17 b8 ff ff       	call   80100f10 <filestat>
801056f9:	83 c4 10             	add    $0x10,%esp
}
801056fc:	c9                   	leave  
801056fd:	c3                   	ret    
801056fe:	66 90                	xchg   %ax,%ax
    return -1;
80105700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105705:	c9                   	leave  
80105706:	c3                   	ret    
80105707:	89 f6                	mov    %esi,%esi
80105709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105710 <sys_link>:
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	57                   	push   %edi
80105714:	56                   	push   %esi
80105715:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105716:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105719:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010571c:	50                   	push   %eax
8010571d:	6a 00                	push   $0x0
8010571f:	e8 5c fa ff ff       	call   80105180 <argstr>
80105724:	83 c4 10             	add    $0x10,%esp
80105727:	85 c0                	test   %eax,%eax
80105729:	0f 88 fb 00 00 00    	js     8010582a <sys_link+0x11a>
8010572f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105732:	83 ec 08             	sub    $0x8,%esp
80105735:	50                   	push   %eax
80105736:	6a 01                	push   $0x1
80105738:	e8 43 fa ff ff       	call   80105180 <argstr>
8010573d:	83 c4 10             	add    $0x10,%esp
80105740:	85 c0                	test   %eax,%eax
80105742:	0f 88 e2 00 00 00    	js     8010582a <sys_link+0x11a>
  begin_op();
80105748:	e8 63 d4 ff ff       	call   80102bb0 <begin_op>
  if((ip = namei(old)) == 0){
8010574d:	83 ec 0c             	sub    $0xc,%esp
80105750:	ff 75 d4             	pushl  -0x2c(%ebp)
80105753:	e8 98 c7 ff ff       	call   80101ef0 <namei>
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	85 c0                	test   %eax,%eax
8010575d:	89 c3                	mov    %eax,%ebx
8010575f:	0f 84 ea 00 00 00    	je     8010584f <sys_link+0x13f>
  ilock(ip);
80105765:	83 ec 0c             	sub    $0xc,%esp
80105768:	50                   	push   %eax
80105769:	e8 22 bf ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
8010576e:	83 c4 10             	add    $0x10,%esp
80105771:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105776:	0f 84 bb 00 00 00    	je     80105837 <sys_link+0x127>
  ip->nlink++;
8010577c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105781:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105784:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105787:	53                   	push   %ebx
80105788:	e8 53 be ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
8010578d:	89 1c 24             	mov    %ebx,(%esp)
80105790:	e8 db bf ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105795:	58                   	pop    %eax
80105796:	5a                   	pop    %edx
80105797:	57                   	push   %edi
80105798:	ff 75 d0             	pushl  -0x30(%ebp)
8010579b:	e8 70 c7 ff ff       	call   80101f10 <nameiparent>
801057a0:	83 c4 10             	add    $0x10,%esp
801057a3:	85 c0                	test   %eax,%eax
801057a5:	89 c6                	mov    %eax,%esi
801057a7:	74 5b                	je     80105804 <sys_link+0xf4>
  ilock(dp);
801057a9:	83 ec 0c             	sub    $0xc,%esp
801057ac:	50                   	push   %eax
801057ad:	e8 de be ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	8b 03                	mov    (%ebx),%eax
801057b7:	39 06                	cmp    %eax,(%esi)
801057b9:	75 3d                	jne    801057f8 <sys_link+0xe8>
801057bb:	83 ec 04             	sub    $0x4,%esp
801057be:	ff 73 04             	pushl  0x4(%ebx)
801057c1:	57                   	push   %edi
801057c2:	56                   	push   %esi
801057c3:	e8 68 c6 ff ff       	call   80101e30 <dirlink>
801057c8:	83 c4 10             	add    $0x10,%esp
801057cb:	85 c0                	test   %eax,%eax
801057cd:	78 29                	js     801057f8 <sys_link+0xe8>
  iunlockput(dp);
801057cf:	83 ec 0c             	sub    $0xc,%esp
801057d2:	56                   	push   %esi
801057d3:	e8 48 c1 ff ff       	call   80101920 <iunlockput>
  iput(ip);
801057d8:	89 1c 24             	mov    %ebx,(%esp)
801057db:	e8 e0 bf ff ff       	call   801017c0 <iput>
  end_op();
801057e0:	e8 3b d4 ff ff       	call   80102c20 <end_op>
  return 0;
801057e5:	83 c4 10             	add    $0x10,%esp
801057e8:	31 c0                	xor    %eax,%eax
}
801057ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057ed:	5b                   	pop    %ebx
801057ee:	5e                   	pop    %esi
801057ef:	5f                   	pop    %edi
801057f0:	5d                   	pop    %ebp
801057f1:	c3                   	ret    
801057f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801057f8:	83 ec 0c             	sub    $0xc,%esp
801057fb:	56                   	push   %esi
801057fc:	e8 1f c1 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105801:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105804:	83 ec 0c             	sub    $0xc,%esp
80105807:	53                   	push   %ebx
80105808:	e8 83 be ff ff       	call   80101690 <ilock>
  ip->nlink--;
8010580d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105812:	89 1c 24             	mov    %ebx,(%esp)
80105815:	e8 c6 bd ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010581a:	89 1c 24             	mov    %ebx,(%esp)
8010581d:	e8 fe c0 ff ff       	call   80101920 <iunlockput>
  end_op();
80105822:	e8 f9 d3 ff ff       	call   80102c20 <end_op>
  return -1;
80105827:	83 c4 10             	add    $0x10,%esp
}
8010582a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010582d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105832:	5b                   	pop    %ebx
80105833:	5e                   	pop    %esi
80105834:	5f                   	pop    %edi
80105835:	5d                   	pop    %ebp
80105836:	c3                   	ret    
    iunlockput(ip);
80105837:	83 ec 0c             	sub    $0xc,%esp
8010583a:	53                   	push   %ebx
8010583b:	e8 e0 c0 ff ff       	call   80101920 <iunlockput>
    end_op();
80105840:	e8 db d3 ff ff       	call   80102c20 <end_op>
    return -1;
80105845:	83 c4 10             	add    $0x10,%esp
80105848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584d:	eb 9b                	jmp    801057ea <sys_link+0xda>
    end_op();
8010584f:	e8 cc d3 ff ff       	call   80102c20 <end_op>
    return -1;
80105854:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105859:	eb 8f                	jmp    801057ea <sys_link+0xda>
8010585b:	90                   	nop
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_unlink>:
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105866:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105869:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010586c:	50                   	push   %eax
8010586d:	6a 00                	push   $0x0
8010586f:	e8 0c f9 ff ff       	call   80105180 <argstr>
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
80105879:	0f 88 77 01 00 00    	js     801059f6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010587f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105882:	e8 29 d3 ff ff       	call   80102bb0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105887:	83 ec 08             	sub    $0x8,%esp
8010588a:	53                   	push   %ebx
8010588b:	ff 75 c0             	pushl  -0x40(%ebp)
8010588e:	e8 7d c6 ff ff       	call   80101f10 <nameiparent>
80105893:	83 c4 10             	add    $0x10,%esp
80105896:	85 c0                	test   %eax,%eax
80105898:	89 c6                	mov    %eax,%esi
8010589a:	0f 84 60 01 00 00    	je     80105a00 <sys_unlink+0x1a0>
  ilock(dp);
801058a0:	83 ec 0c             	sub    $0xc,%esp
801058a3:	50                   	push   %eax
801058a4:	e8 e7 bd ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058a9:	58                   	pop    %eax
801058aa:	5a                   	pop    %edx
801058ab:	68 dc 82 10 80       	push   $0x801082dc
801058b0:	53                   	push   %ebx
801058b1:	e8 ea c2 ff ff       	call   80101ba0 <namecmp>
801058b6:	83 c4 10             	add    $0x10,%esp
801058b9:	85 c0                	test   %eax,%eax
801058bb:	0f 84 03 01 00 00    	je     801059c4 <sys_unlink+0x164>
801058c1:	83 ec 08             	sub    $0x8,%esp
801058c4:	68 db 82 10 80       	push   $0x801082db
801058c9:	53                   	push   %ebx
801058ca:	e8 d1 c2 ff ff       	call   80101ba0 <namecmp>
801058cf:	83 c4 10             	add    $0x10,%esp
801058d2:	85 c0                	test   %eax,%eax
801058d4:	0f 84 ea 00 00 00    	je     801059c4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801058da:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801058dd:	83 ec 04             	sub    $0x4,%esp
801058e0:	50                   	push   %eax
801058e1:	53                   	push   %ebx
801058e2:	56                   	push   %esi
801058e3:	e8 d8 c2 ff ff       	call   80101bc0 <dirlookup>
801058e8:	83 c4 10             	add    $0x10,%esp
801058eb:	85 c0                	test   %eax,%eax
801058ed:	89 c3                	mov    %eax,%ebx
801058ef:	0f 84 cf 00 00 00    	je     801059c4 <sys_unlink+0x164>
  ilock(ip);
801058f5:	83 ec 0c             	sub    $0xc,%esp
801058f8:	50                   	push   %eax
801058f9:	e8 92 bd ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
801058fe:	83 c4 10             	add    $0x10,%esp
80105901:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105906:	0f 8e 10 01 00 00    	jle    80105a1c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010590c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105911:	74 6d                	je     80105980 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105913:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105916:	83 ec 04             	sub    $0x4,%esp
80105919:	6a 10                	push   $0x10
8010591b:	6a 00                	push   $0x0
8010591d:	50                   	push   %eax
8010591e:	e8 ad f4 ff ff       	call   80104dd0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105923:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105926:	6a 10                	push   $0x10
80105928:	ff 75 c4             	pushl  -0x3c(%ebp)
8010592b:	50                   	push   %eax
8010592c:	56                   	push   %esi
8010592d:	e8 3e c1 ff ff       	call   80101a70 <writei>
80105932:	83 c4 20             	add    $0x20,%esp
80105935:	83 f8 10             	cmp    $0x10,%eax
80105938:	0f 85 eb 00 00 00    	jne    80105a29 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010593e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105943:	0f 84 97 00 00 00    	je     801059e0 <sys_unlink+0x180>
  iunlockput(dp);
80105949:	83 ec 0c             	sub    $0xc,%esp
8010594c:	56                   	push   %esi
8010594d:	e8 ce bf ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80105952:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105957:	89 1c 24             	mov    %ebx,(%esp)
8010595a:	e8 81 bc ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010595f:	89 1c 24             	mov    %ebx,(%esp)
80105962:	e8 b9 bf ff ff       	call   80101920 <iunlockput>
  end_op();
80105967:	e8 b4 d2 ff ff       	call   80102c20 <end_op>
  return 0;
8010596c:	83 c4 10             	add    $0x10,%esp
8010596f:	31 c0                	xor    %eax,%eax
}
80105971:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105974:	5b                   	pop    %ebx
80105975:	5e                   	pop    %esi
80105976:	5f                   	pop    %edi
80105977:	5d                   	pop    %ebp
80105978:	c3                   	ret    
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105980:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105984:	76 8d                	jbe    80105913 <sys_unlink+0xb3>
80105986:	bf 20 00 00 00       	mov    $0x20,%edi
8010598b:	eb 0f                	jmp    8010599c <sys_unlink+0x13c>
8010598d:	8d 76 00             	lea    0x0(%esi),%esi
80105990:	83 c7 10             	add    $0x10,%edi
80105993:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105996:	0f 83 77 ff ff ff    	jae    80105913 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010599c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010599f:	6a 10                	push   $0x10
801059a1:	57                   	push   %edi
801059a2:	50                   	push   %eax
801059a3:	53                   	push   %ebx
801059a4:	e8 c7 bf ff ff       	call   80101970 <readi>
801059a9:	83 c4 10             	add    $0x10,%esp
801059ac:	83 f8 10             	cmp    $0x10,%eax
801059af:	75 5e                	jne    80105a0f <sys_unlink+0x1af>
    if(de.inum != 0)
801059b1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801059b6:	74 d8                	je     80105990 <sys_unlink+0x130>
    iunlockput(ip);
801059b8:	83 ec 0c             	sub    $0xc,%esp
801059bb:	53                   	push   %ebx
801059bc:	e8 5f bf ff ff       	call   80101920 <iunlockput>
    goto bad;
801059c1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801059c4:	83 ec 0c             	sub    $0xc,%esp
801059c7:	56                   	push   %esi
801059c8:	e8 53 bf ff ff       	call   80101920 <iunlockput>
  end_op();
801059cd:	e8 4e d2 ff ff       	call   80102c20 <end_op>
  return -1;
801059d2:	83 c4 10             	add    $0x10,%esp
801059d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059da:	eb 95                	jmp    80105971 <sys_unlink+0x111>
801059dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801059e0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801059e5:	83 ec 0c             	sub    $0xc,%esp
801059e8:	56                   	push   %esi
801059e9:	e8 f2 bb ff ff       	call   801015e0 <iupdate>
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	e9 53 ff ff ff       	jmp    80105949 <sys_unlink+0xe9>
    return -1;
801059f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fb:	e9 71 ff ff ff       	jmp    80105971 <sys_unlink+0x111>
    end_op();
80105a00:	e8 1b d2 ff ff       	call   80102c20 <end_op>
    return -1;
80105a05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0a:	e9 62 ff ff ff       	jmp    80105971 <sys_unlink+0x111>
      panic("isdirempty: readi");
80105a0f:	83 ec 0c             	sub    $0xc,%esp
80105a12:	68 15 83 10 80       	push   $0x80108315
80105a17:	e8 74 a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a1c:	83 ec 0c             	sub    $0xc,%esp
80105a1f:	68 03 83 10 80       	push   $0x80108303
80105a24:	e8 67 a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105a29:	83 ec 0c             	sub    $0xc,%esp
80105a2c:	68 27 83 10 80       	push   $0x80108327
80105a31:	e8 5a a9 ff ff       	call   80100390 <panic>
80105a36:	8d 76 00             	lea    0x0(%esi),%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a40 <sys_open>:

int
sys_open(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	57                   	push   %edi
80105a44:	56                   	push   %esi
80105a45:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a46:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a49:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a4c:	50                   	push   %eax
80105a4d:	6a 00                	push   $0x0
80105a4f:	e8 2c f7 ff ff       	call   80105180 <argstr>
80105a54:	83 c4 10             	add    $0x10,%esp
80105a57:	85 c0                	test   %eax,%eax
80105a59:	0f 88 1d 01 00 00    	js     80105b7c <sys_open+0x13c>
80105a5f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a62:	83 ec 08             	sub    $0x8,%esp
80105a65:	50                   	push   %eax
80105a66:	6a 01                	push   $0x1
80105a68:	e8 63 f6 ff ff       	call   801050d0 <argint>
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	85 c0                	test   %eax,%eax
80105a72:	0f 88 04 01 00 00    	js     80105b7c <sys_open+0x13c>
    return -1;

  begin_op();
80105a78:	e8 33 d1 ff ff       	call   80102bb0 <begin_op>

  if(omode & O_CREATE){
80105a7d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a81:	0f 85 a9 00 00 00    	jne    80105b30 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a87:	83 ec 0c             	sub    $0xc,%esp
80105a8a:	ff 75 e0             	pushl  -0x20(%ebp)
80105a8d:	e8 5e c4 ff ff       	call   80101ef0 <namei>
80105a92:	83 c4 10             	add    $0x10,%esp
80105a95:	85 c0                	test   %eax,%eax
80105a97:	89 c6                	mov    %eax,%esi
80105a99:	0f 84 b2 00 00 00    	je     80105b51 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
80105a9f:	83 ec 0c             	sub    $0xc,%esp
80105aa2:	50                   	push   %eax
80105aa3:	e8 e8 bb ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105aa8:	83 c4 10             	add    $0x10,%esp
80105aab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ab0:	0f 84 aa 00 00 00    	je     80105b60 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105ab6:	e8 c5 b2 ff ff       	call   80100d80 <filealloc>
80105abb:	85 c0                	test   %eax,%eax
80105abd:	89 c7                	mov    %eax,%edi
80105abf:	0f 84 a6 00 00 00    	je     80105b6b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105ac5:	e8 26 e3 ff ff       	call   80103df0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105aca:	31 db                	xor    %ebx,%ebx
80105acc:	eb 0e                	jmp    80105adc <sys_open+0x9c>
80105ace:	66 90                	xchg   %ax,%ax
80105ad0:	83 c3 01             	add    $0x1,%ebx
80105ad3:	83 fb 10             	cmp    $0x10,%ebx
80105ad6:	0f 84 ac 00 00 00    	je     80105b88 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105adc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ae0:	85 d2                	test   %edx,%edx
80105ae2:	75 ec                	jne    80105ad0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ae4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105ae7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105aeb:	56                   	push   %esi
80105aec:	e8 7f bc ff ff       	call   80101770 <iunlock>
  end_op();
80105af1:	e8 2a d1 ff ff       	call   80102c20 <end_op>

  f->type = FD_INODE;
80105af6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105afc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105aff:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b02:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105b05:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b0c:	89 d0                	mov    %edx,%eax
80105b0e:	f7 d0                	not    %eax
80105b10:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b13:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b16:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b19:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b20:	89 d8                	mov    %ebx,%eax
80105b22:	5b                   	pop    %ebx
80105b23:	5e                   	pop    %esi
80105b24:	5f                   	pop    %edi
80105b25:	5d                   	pop    %ebp
80105b26:	c3                   	ret    
80105b27:	89 f6                	mov    %esi,%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b36:	31 c9                	xor    %ecx,%ecx
80105b38:	6a 00                	push   $0x0
80105b3a:	ba 02 00 00 00       	mov    $0x2,%edx
80105b3f:	e8 fc f6 ff ff       	call   80105240 <create>
    if(ip == 0){
80105b44:	83 c4 10             	add    $0x10,%esp
80105b47:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105b49:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b4b:	0f 85 65 ff ff ff    	jne    80105ab6 <sys_open+0x76>
      end_op();
80105b51:	e8 ca d0 ff ff       	call   80102c20 <end_op>
      return -1;
80105b56:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b5b:	eb c0                	jmp    80105b1d <sys_open+0xdd>
80105b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b63:	85 c9                	test   %ecx,%ecx
80105b65:	0f 84 4b ff ff ff    	je     80105ab6 <sys_open+0x76>
    iunlockput(ip);
80105b6b:	83 ec 0c             	sub    $0xc,%esp
80105b6e:	56                   	push   %esi
80105b6f:	e8 ac bd ff ff       	call   80101920 <iunlockput>
    end_op();
80105b74:	e8 a7 d0 ff ff       	call   80102c20 <end_op>
    return -1;
80105b79:	83 c4 10             	add    $0x10,%esp
80105b7c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b81:	eb 9a                	jmp    80105b1d <sys_open+0xdd>
80105b83:	90                   	nop
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105b88:	83 ec 0c             	sub    $0xc,%esp
80105b8b:	57                   	push   %edi
80105b8c:	e8 af b2 ff ff       	call   80100e40 <fileclose>
80105b91:	83 c4 10             	add    $0x10,%esp
80105b94:	eb d5                	jmp    80105b6b <sys_open+0x12b>
80105b96:	8d 76 00             	lea    0x0(%esi),%esi
80105b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ba0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ba6:	e8 05 d0 ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105bab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bae:	83 ec 08             	sub    $0x8,%esp
80105bb1:	50                   	push   %eax
80105bb2:	6a 00                	push   $0x0
80105bb4:	e8 c7 f5 ff ff       	call   80105180 <argstr>
80105bb9:	83 c4 10             	add    $0x10,%esp
80105bbc:	85 c0                	test   %eax,%eax
80105bbe:	78 30                	js     80105bf0 <sys_mkdir+0x50>
80105bc0:	83 ec 0c             	sub    $0xc,%esp
80105bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc6:	31 c9                	xor    %ecx,%ecx
80105bc8:	6a 00                	push   $0x0
80105bca:	ba 01 00 00 00       	mov    $0x1,%edx
80105bcf:	e8 6c f6 ff ff       	call   80105240 <create>
80105bd4:	83 c4 10             	add    $0x10,%esp
80105bd7:	85 c0                	test   %eax,%eax
80105bd9:	74 15                	je     80105bf0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bdb:	83 ec 0c             	sub    $0xc,%esp
80105bde:	50                   	push   %eax
80105bdf:	e8 3c bd ff ff       	call   80101920 <iunlockput>
  end_op();
80105be4:	e8 37 d0 ff ff       	call   80102c20 <end_op>
  return 0;
80105be9:	83 c4 10             	add    $0x10,%esp
80105bec:	31 c0                	xor    %eax,%eax
}
80105bee:	c9                   	leave  
80105bef:	c3                   	ret    
    end_op();
80105bf0:	e8 2b d0 ff ff       	call   80102c20 <end_op>
    return -1;
80105bf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bfa:	c9                   	leave  
80105bfb:	c3                   	ret    
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c00 <sys_mknod>:

int
sys_mknod(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c06:	e8 a5 cf ff ff       	call   80102bb0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c0b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c0e:	83 ec 08             	sub    $0x8,%esp
80105c11:	50                   	push   %eax
80105c12:	6a 00                	push   $0x0
80105c14:	e8 67 f5 ff ff       	call   80105180 <argstr>
80105c19:	83 c4 10             	add    $0x10,%esp
80105c1c:	85 c0                	test   %eax,%eax
80105c1e:	78 60                	js     80105c80 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105c20:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c23:	83 ec 08             	sub    $0x8,%esp
80105c26:	50                   	push   %eax
80105c27:	6a 01                	push   $0x1
80105c29:	e8 a2 f4 ff ff       	call   801050d0 <argint>
  if((argstr(0, &path)) < 0 ||
80105c2e:	83 c4 10             	add    $0x10,%esp
80105c31:	85 c0                	test   %eax,%eax
80105c33:	78 4b                	js     80105c80 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c35:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c38:	83 ec 08             	sub    $0x8,%esp
80105c3b:	50                   	push   %eax
80105c3c:	6a 02                	push   $0x2
80105c3e:	e8 8d f4 ff ff       	call   801050d0 <argint>
     argint(1, &major) < 0 ||
80105c43:	83 c4 10             	add    $0x10,%esp
80105c46:	85 c0                	test   %eax,%eax
80105c48:	78 36                	js     80105c80 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c4a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105c4e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c51:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105c55:	ba 03 00 00 00       	mov    $0x3,%edx
80105c5a:	50                   	push   %eax
80105c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c5e:	e8 dd f5 ff ff       	call   80105240 <create>
80105c63:	83 c4 10             	add    $0x10,%esp
80105c66:	85 c0                	test   %eax,%eax
80105c68:	74 16                	je     80105c80 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c6a:	83 ec 0c             	sub    $0xc,%esp
80105c6d:	50                   	push   %eax
80105c6e:	e8 ad bc ff ff       	call   80101920 <iunlockput>
  end_op();
80105c73:	e8 a8 cf ff ff       	call   80102c20 <end_op>
  return 0;
80105c78:	83 c4 10             	add    $0x10,%esp
80105c7b:	31 c0                	xor    %eax,%eax
}
80105c7d:	c9                   	leave  
80105c7e:	c3                   	ret    
80105c7f:	90                   	nop
    end_op();
80105c80:	e8 9b cf ff ff       	call   80102c20 <end_op>
    return -1;
80105c85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c8a:	c9                   	leave  
80105c8b:	c3                   	ret    
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c90 <sys_chdir>:

int
sys_chdir(void)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	56                   	push   %esi
80105c94:	53                   	push   %ebx
80105c95:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c98:	e8 53 e1 ff ff       	call   80103df0 <myproc>
80105c9d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c9f:	e8 0c cf ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ca4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ca7:	83 ec 08             	sub    $0x8,%esp
80105caa:	50                   	push   %eax
80105cab:	6a 00                	push   $0x0
80105cad:	e8 ce f4 ff ff       	call   80105180 <argstr>
80105cb2:	83 c4 10             	add    $0x10,%esp
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	78 77                	js     80105d30 <sys_chdir+0xa0>
80105cb9:	83 ec 0c             	sub    $0xc,%esp
80105cbc:	ff 75 f4             	pushl  -0xc(%ebp)
80105cbf:	e8 2c c2 ff ff       	call   80101ef0 <namei>
80105cc4:	83 c4 10             	add    $0x10,%esp
80105cc7:	85 c0                	test   %eax,%eax
80105cc9:	89 c3                	mov    %eax,%ebx
80105ccb:	74 63                	je     80105d30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105ccd:	83 ec 0c             	sub    $0xc,%esp
80105cd0:	50                   	push   %eax
80105cd1:	e8 ba b9 ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105cd6:	83 c4 10             	add    $0x10,%esp
80105cd9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cde:	75 30                	jne    80105d10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	53                   	push   %ebx
80105ce4:	e8 87 ba ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105ce9:	58                   	pop    %eax
80105cea:	ff 76 68             	pushl  0x68(%esi)
80105ced:	e8 ce ba ff ff       	call   801017c0 <iput>
  end_op();
80105cf2:	e8 29 cf ff ff       	call   80102c20 <end_op>
  curproc->cwd = ip;
80105cf7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105cfa:	83 c4 10             	add    $0x10,%esp
80105cfd:	31 c0                	xor    %eax,%eax
}
80105cff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d02:	5b                   	pop    %ebx
80105d03:	5e                   	pop    %esi
80105d04:	5d                   	pop    %ebp
80105d05:	c3                   	ret    
80105d06:	8d 76 00             	lea    0x0(%esi),%esi
80105d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105d10:	83 ec 0c             	sub    $0xc,%esp
80105d13:	53                   	push   %ebx
80105d14:	e8 07 bc ff ff       	call   80101920 <iunlockput>
    end_op();
80105d19:	e8 02 cf ff ff       	call   80102c20 <end_op>
    return -1;
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d26:	eb d7                	jmp    80105cff <sys_chdir+0x6f>
80105d28:	90                   	nop
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105d30:	e8 eb ce ff ff       	call   80102c20 <end_op>
    return -1;
80105d35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d3a:	eb c3                	jmp    80105cff <sys_chdir+0x6f>
80105d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d40 <sys_exec>:

int
sys_exec(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	57                   	push   %edi
80105d44:	56                   	push   %esi
80105d45:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d46:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d4c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d52:	50                   	push   %eax
80105d53:	6a 00                	push   $0x0
80105d55:	e8 26 f4 ff ff       	call   80105180 <argstr>
80105d5a:	83 c4 10             	add    $0x10,%esp
80105d5d:	85 c0                	test   %eax,%eax
80105d5f:	0f 88 87 00 00 00    	js     80105dec <sys_exec+0xac>
80105d65:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d6b:	83 ec 08             	sub    $0x8,%esp
80105d6e:	50                   	push   %eax
80105d6f:	6a 01                	push   $0x1
80105d71:	e8 5a f3 ff ff       	call   801050d0 <argint>
80105d76:	83 c4 10             	add    $0x10,%esp
80105d79:	85 c0                	test   %eax,%eax
80105d7b:	78 6f                	js     80105dec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d7d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105d83:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105d86:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d88:	68 80 00 00 00       	push   $0x80
80105d8d:	6a 00                	push   $0x0
80105d8f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105d95:	50                   	push   %eax
80105d96:	e8 35 f0 ff ff       	call   80104dd0 <memset>
80105d9b:	83 c4 10             	add    $0x10,%esp
80105d9e:	eb 2c                	jmp    80105dcc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105da0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105da6:	85 c0                	test   %eax,%eax
80105da8:	74 56                	je     80105e00 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105daa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105db0:	83 ec 08             	sub    $0x8,%esp
80105db3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105db6:	52                   	push   %edx
80105db7:	50                   	push   %eax
80105db8:	e8 a3 f2 ff ff       	call   80105060 <fetchstr>
80105dbd:	83 c4 10             	add    $0x10,%esp
80105dc0:	85 c0                	test   %eax,%eax
80105dc2:	78 28                	js     80105dec <sys_exec+0xac>
  for(i=0;; i++){
80105dc4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105dc7:	83 fb 20             	cmp    $0x20,%ebx
80105dca:	74 20                	je     80105dec <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105dcc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105dd2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105dd9:	83 ec 08             	sub    $0x8,%esp
80105ddc:	57                   	push   %edi
80105ddd:	01 f0                	add    %esi,%eax
80105ddf:	50                   	push   %eax
80105de0:	e8 3b f2 ff ff       	call   80105020 <fetchint>
80105de5:	83 c4 10             	add    $0x10,%esp
80105de8:	85 c0                	test   %eax,%eax
80105dea:	79 b4                	jns    80105da0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105def:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105df4:	5b                   	pop    %ebx
80105df5:	5e                   	pop    %esi
80105df6:	5f                   	pop    %edi
80105df7:	5d                   	pop    %ebp
80105df8:	c3                   	ret    
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105e00:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e06:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105e09:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e10:	00 00 00 00 
  return exec(path, argv);
80105e14:	50                   	push   %eax
80105e15:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e1b:	e8 f0 ab ff ff       	call   80100a10 <exec>
80105e20:	83 c4 10             	add    $0x10,%esp
}
80105e23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e26:	5b                   	pop    %ebx
80105e27:	5e                   	pop    %esi
80105e28:	5f                   	pop    %edi
80105e29:	5d                   	pop    %ebp
80105e2a:	c3                   	ret    
80105e2b:	90                   	nop
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e30 <sys_pipe>:

int
sys_pipe(void)
{
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	57                   	push   %edi
80105e34:	56                   	push   %esi
80105e35:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e36:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e39:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e3c:	6a 08                	push   $0x8
80105e3e:	50                   	push   %eax
80105e3f:	6a 00                	push   $0x0
80105e41:	e8 da f2 ff ff       	call   80105120 <argptr>
80105e46:	83 c4 10             	add    $0x10,%esp
80105e49:	85 c0                	test   %eax,%eax
80105e4b:	0f 88 ae 00 00 00    	js     80105eff <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e51:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e54:	83 ec 08             	sub    $0x8,%esp
80105e57:	50                   	push   %eax
80105e58:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e5b:	50                   	push   %eax
80105e5c:	e8 ef d3 ff ff       	call   80103250 <pipealloc>
80105e61:	83 c4 10             	add    $0x10,%esp
80105e64:	85 c0                	test   %eax,%eax
80105e66:	0f 88 93 00 00 00    	js     80105eff <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e6c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e6f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e71:	e8 7a df ff ff       	call   80103df0 <myproc>
80105e76:	eb 10                	jmp    80105e88 <sys_pipe+0x58>
80105e78:	90                   	nop
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105e80:	83 c3 01             	add    $0x1,%ebx
80105e83:	83 fb 10             	cmp    $0x10,%ebx
80105e86:	74 60                	je     80105ee8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105e88:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e8c:	85 f6                	test   %esi,%esi
80105e8e:	75 f0                	jne    80105e80 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105e90:	8d 73 08             	lea    0x8(%ebx),%esi
80105e93:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e9a:	e8 51 df ff ff       	call   80103df0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e9f:	31 d2                	xor    %edx,%edx
80105ea1:	eb 0d                	jmp    80105eb0 <sys_pipe+0x80>
80105ea3:	90                   	nop
80105ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ea8:	83 c2 01             	add    $0x1,%edx
80105eab:	83 fa 10             	cmp    $0x10,%edx
80105eae:	74 28                	je     80105ed8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105eb0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105eb4:	85 c9                	test   %ecx,%ecx
80105eb6:	75 f0                	jne    80105ea8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105eb8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105ebc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ebf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ec1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ec4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ec7:	31 c0                	xor    %eax,%eax
}
80105ec9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ecc:	5b                   	pop    %ebx
80105ecd:	5e                   	pop    %esi
80105ece:	5f                   	pop    %edi
80105ecf:	5d                   	pop    %ebp
80105ed0:	c3                   	ret    
80105ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105ed8:	e8 13 df ff ff       	call   80103df0 <myproc>
80105edd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ee4:	00 
80105ee5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105ee8:	83 ec 0c             	sub    $0xc,%esp
80105eeb:	ff 75 e0             	pushl  -0x20(%ebp)
80105eee:	e8 4d af ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105ef3:	58                   	pop    %eax
80105ef4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ef7:	e8 44 af ff ff       	call   80100e40 <fileclose>
    return -1;
80105efc:	83 c4 10             	add    $0x10,%esp
80105eff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f04:	eb c3                	jmp    80105ec9 <sys_pipe+0x99>
80105f06:	66 90                	xchg   %ax,%ax
80105f08:	66 90                	xchg   %ax,%ax
80105f0a:	66 90                	xchg   %ax,%ax
80105f0c:	66 90                	xchg   %ax,%ax
80105f0e:	66 90                	xchg   %ax,%ax

80105f10 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105f13:	5d                   	pop    %ebp
  return fork();
80105f14:	e9 77 e0 ff ff       	jmp    80103f90 <fork>
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f20 <sys_exit>:

int
sys_exit(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f26:	e8 75 e3 ff ff       	call   801042a0 <exit>
  return 0;  // not reached
}
80105f2b:	31 c0                	xor    %eax,%eax
80105f2d:	c9                   	leave  
80105f2e:	c3                   	ret    
80105f2f:	90                   	nop

80105f30 <sys_wait>:

int
sys_wait(void)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105f33:	5d                   	pop    %ebp
  return wait();
80105f34:	e9 f7 e5 ff ff       	jmp    80104530 <wait>
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f40 <sys_kill>:

int
sys_kill(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f49:	50                   	push   %eax
80105f4a:	6a 00                	push   $0x0
80105f4c:	e8 7f f1 ff ff       	call   801050d0 <argint>
80105f51:	83 c4 10             	add    $0x10,%esp
80105f54:	85 c0                	test   %eax,%eax
80105f56:	78 18                	js     80105f70 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f58:	83 ec 0c             	sub    $0xc,%esp
80105f5b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f5e:	e8 2d e7 ff ff       	call   80104690 <kill>
80105f63:	83 c4 10             	add    $0x10,%esp
}
80105f66:	c9                   	leave  
80105f67:	c3                   	ret    
80105f68:	90                   	nop
80105f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f75:	c9                   	leave  
80105f76:	c3                   	ret    
80105f77:	89 f6                	mov    %esi,%esi
80105f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f80 <sys_getpid>:

int
sys_getpid(void)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f86:	e8 65 de ff ff       	call   80103df0 <myproc>
80105f8b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f8e:	c9                   	leave  
80105f8f:	c3                   	ret    

80105f90 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f90:	55                   	push   %ebp
80105f91:	89 e5                	mov    %esp,%ebp
80105f93:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f9a:	50                   	push   %eax
80105f9b:	6a 00                	push   $0x0
80105f9d:	e8 2e f1 ff ff       	call   801050d0 <argint>
80105fa2:	83 c4 10             	add    $0x10,%esp
80105fa5:	85 c0                	test   %eax,%eax
80105fa7:	78 27                	js     80105fd0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105fa9:	e8 42 de ff ff       	call   80103df0 <myproc>
  if(growproc(n) < 0)
80105fae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105fb1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105fb3:	ff 75 f4             	pushl  -0xc(%ebp)
80105fb6:	e8 55 df ff ff       	call   80103f10 <growproc>
80105fbb:	83 c4 10             	add    $0x10,%esp
80105fbe:	85 c0                	test   %eax,%eax
80105fc0:	78 0e                	js     80105fd0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105fc2:	89 d8                	mov    %ebx,%eax
80105fc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fc7:	c9                   	leave  
80105fc8:	c3                   	ret    
80105fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fd0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fd5:	eb eb                	jmp    80105fc2 <sys_sbrk+0x32>
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fe0 <sys_sleep>:

int
sys_sleep(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105fe4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fe7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105fea:	50                   	push   %eax
80105feb:	6a 00                	push   $0x0
80105fed:	e8 de f0 ff ff       	call   801050d0 <argint>
80105ff2:	83 c4 10             	add    $0x10,%esp
80105ff5:	85 c0                	test   %eax,%eax
80105ff7:	0f 88 8a 00 00 00    	js     80106087 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105ffd:	83 ec 0c             	sub    $0xc,%esp
80106000:	68 60 b8 11 80       	push   $0x8011b860
80106005:	e8 b6 ec ff ff       	call   80104cc0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010600a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010600d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106010:	8b 1d a0 c0 11 80    	mov    0x8011c0a0,%ebx
  while(ticks - ticks0 < n){
80106016:	85 d2                	test   %edx,%edx
80106018:	75 27                	jne    80106041 <sys_sleep+0x61>
8010601a:	eb 54                	jmp    80106070 <sys_sleep+0x90>
8010601c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106020:	83 ec 08             	sub    $0x8,%esp
80106023:	68 60 b8 11 80       	push   $0x8011b860
80106028:	68 a0 c0 11 80       	push   $0x8011c0a0
8010602d:	e8 3e e4 ff ff       	call   80104470 <sleep>
  while(ticks - ticks0 < n){
80106032:	a1 a0 c0 11 80       	mov    0x8011c0a0,%eax
80106037:	83 c4 10             	add    $0x10,%esp
8010603a:	29 d8                	sub    %ebx,%eax
8010603c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010603f:	73 2f                	jae    80106070 <sys_sleep+0x90>
    if(myproc()->killed){
80106041:	e8 aa dd ff ff       	call   80103df0 <myproc>
80106046:	8b 40 24             	mov    0x24(%eax),%eax
80106049:	85 c0                	test   %eax,%eax
8010604b:	74 d3                	je     80106020 <sys_sleep+0x40>
      release(&tickslock);
8010604d:	83 ec 0c             	sub    $0xc,%esp
80106050:	68 60 b8 11 80       	push   $0x8011b860
80106055:	e8 26 ed ff ff       	call   80104d80 <release>
      return -1;
8010605a:	83 c4 10             	add    $0x10,%esp
8010605d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106062:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106065:	c9                   	leave  
80106066:	c3                   	ret    
80106067:	89 f6                	mov    %esi,%esi
80106069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106070:	83 ec 0c             	sub    $0xc,%esp
80106073:	68 60 b8 11 80       	push   $0x8011b860
80106078:	e8 03 ed ff ff       	call   80104d80 <release>
  return 0;
8010607d:	83 c4 10             	add    $0x10,%esp
80106080:	31 c0                	xor    %eax,%eax
}
80106082:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106085:	c9                   	leave  
80106086:	c3                   	ret    
    return -1;
80106087:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010608c:	eb f4                	jmp    80106082 <sys_sleep+0xa2>
8010608e:	66 90                	xchg   %ax,%ax

80106090 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	53                   	push   %ebx
80106094:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106097:	68 60 b8 11 80       	push   $0x8011b860
8010609c:	e8 1f ec ff ff       	call   80104cc0 <acquire>
  xticks = ticks;
801060a1:	8b 1d a0 c0 11 80    	mov    0x8011c0a0,%ebx
  release(&tickslock);
801060a7:	c7 04 24 60 b8 11 80 	movl   $0x8011b860,(%esp)
801060ae:	e8 cd ec ff ff       	call   80104d80 <release>
  return xticks;
}
801060b3:	89 d8                	mov    %ebx,%eax
801060b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060b8:	c9                   	leave  
801060b9:	c3                   	ret    
801060ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060c0 <sys_invoked_syscalls>:

int
sys_invoked_syscalls(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	83 ec 20             	sub    $0x20,%esp
    // TODO read pid from stack and pass to function
   int pid;
   argint(0, &pid);
801060c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060c9:	50                   	push   %eax
801060ca:	6a 00                	push   $0x0
801060cc:	e8 ff ef ff ff       	call   801050d0 <argint>
    
   invoked_syscalls(pid);
801060d1:	58                   	pop    %eax
801060d2:	ff 75 f4             	pushl  -0xc(%ebp)
801060d5:	e8 f6 e7 ff ff       	call   801048d0 <invoked_syscalls>
   return 22; 
}
801060da:	b8 16 00 00 00       	mov    $0x16,%eax
801060df:	c9                   	leave  
801060e0:	c3                   	ret    
801060e1:	eb 0d                	jmp    801060f0 <sys_log_syscalls>
801060e3:	90                   	nop
801060e4:	90                   	nop
801060e5:	90                   	nop
801060e6:	90                   	nop
801060e7:	90                   	nop
801060e8:	90                   	nop
801060e9:	90                   	nop
801060ea:	90                   	nop
801060eb:	90                   	nop
801060ec:	90                   	nop
801060ed:	90                   	nop
801060ee:	90                   	nop
801060ef:	90                   	nop

801060f0 <sys_log_syscalls>:
int
sys_log_syscalls(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 08             	sub    $0x8,%esp
    // TODO read pid from stack and pass to function
   
   log_syscalls();
801060f6:	e8 e5 e6 ff ff       	call   801047e0 <log_syscalls>
   return 23; 

}
801060fb:	b8 17 00 00 00       	mov    $0x17,%eax
80106100:	c9                   	leave  
80106101:	c3                   	ret    

80106102 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106102:	1e                   	push   %ds
  pushl %es
80106103:	06                   	push   %es
  pushl %fs
80106104:	0f a0                	push   %fs
  pushl %gs
80106106:	0f a8                	push   %gs
  pushal
80106108:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106109:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010610d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010610f:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106111:	54                   	push   %esp
  call trap
80106112:	e8 c9 00 00 00       	call   801061e0 <trap>
  addl $4, %esp
80106117:	83 c4 04             	add    $0x4,%esp

8010611a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010611a:	61                   	popa   
  popl %gs
8010611b:	0f a9                	pop    %gs
  popl %fs
8010611d:	0f a1                	pop    %fs
  popl %es
8010611f:	07                   	pop    %es
  popl %ds
80106120:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106121:	83 c4 08             	add    $0x8,%esp
  iret
80106124:	cf                   	iret   
80106125:	66 90                	xchg   %ax,%ax
80106127:	66 90                	xchg   %ax,%ax
80106129:	66 90                	xchg   %ax,%ax
8010612b:	66 90                	xchg   %ax,%ax
8010612d:	66 90                	xchg   %ax,%ax
8010612f:	90                   	nop

80106130 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106130:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106131:	31 c0                	xor    %eax,%eax
{
80106133:	89 e5                	mov    %esp,%ebp
80106135:	83 ec 08             	sub    $0x8,%esp
80106138:	90                   	nop
80106139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106140:	8b 14 85 16 b0 10 80 	mov    -0x7fef4fea(,%eax,4),%edx
80106147:	c7 04 c5 a2 b8 11 80 	movl   $0x8e000008,-0x7fee475e(,%eax,8)
8010614e:	08 00 00 8e 
80106152:	66 89 14 c5 a0 b8 11 	mov    %dx,-0x7fee4760(,%eax,8)
80106159:	80 
8010615a:	c1 ea 10             	shr    $0x10,%edx
8010615d:	66 89 14 c5 a6 b8 11 	mov    %dx,-0x7fee475a(,%eax,8)
80106164:	80 
  for(i = 0; i < 256; i++)
80106165:	83 c0 01             	add    $0x1,%eax
80106168:	3d 00 01 00 00       	cmp    $0x100,%eax
8010616d:	75 d1                	jne    80106140 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010616f:	a1 16 b1 10 80       	mov    0x8010b116,%eax

  initlock(&tickslock, "time");
80106174:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106177:	c7 05 a2 ba 11 80 08 	movl   $0xef000008,0x8011baa2
8010617e:	00 00 ef 
  initlock(&tickslock, "time");
80106181:	68 29 7f 10 80       	push   $0x80107f29
80106186:	68 60 b8 11 80       	push   $0x8011b860
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010618b:	66 a3 a0 ba 11 80    	mov    %ax,0x8011baa0
80106191:	c1 e8 10             	shr    $0x10,%eax
80106194:	66 a3 a6 ba 11 80    	mov    %ax,0x8011baa6
  initlock(&tickslock, "time");
8010619a:	e8 e1 e9 ff ff       	call   80104b80 <initlock>
}
8010619f:	83 c4 10             	add    $0x10,%esp
801061a2:	c9                   	leave  
801061a3:	c3                   	ret    
801061a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801061aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801061b0 <idtinit>:

void
idtinit(void)
{
801061b0:	55                   	push   %ebp
  pd[0] = size-1;
801061b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061b6:	89 e5                	mov    %esp,%ebp
801061b8:	83 ec 10             	sub    $0x10,%esp
801061bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061bf:	b8 a0 b8 11 80       	mov    $0x8011b8a0,%eax
801061c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061c8:	c1 e8 10             	shr    $0x10,%eax
801061cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801061d5:	c9                   	leave  
801061d6:	c3                   	ret    
801061d7:	89 f6                	mov    %esi,%esi
801061d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	57                   	push   %edi
801061e4:	56                   	push   %esi
801061e5:	53                   	push   %ebx
801061e6:	83 ec 1c             	sub    $0x1c,%esp
801061e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801061ec:	8b 47 30             	mov    0x30(%edi),%eax
801061ef:	83 f8 40             	cmp    $0x40,%eax
801061f2:	0f 84 f0 00 00 00    	je     801062e8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801061f8:	83 e8 20             	sub    $0x20,%eax
801061fb:	83 f8 1f             	cmp    $0x1f,%eax
801061fe:	77 10                	ja     80106210 <trap+0x30>
80106200:	ff 24 85 d8 83 10 80 	jmp    *-0x7fef7c28(,%eax,4)
80106207:	89 f6                	mov    %esi,%esi
80106209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106210:	e8 db db ff ff       	call   80103df0 <myproc>
80106215:	85 c0                	test   %eax,%eax
80106217:	8b 5f 38             	mov    0x38(%edi),%ebx
8010621a:	0f 84 14 02 00 00    	je     80106434 <trap+0x254>
80106220:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106224:	0f 84 0a 02 00 00    	je     80106434 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010622a:	0f 20 d1             	mov    %cr2,%ecx
8010622d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106230:	e8 9b db ff ff       	call   80103dd0 <cpuid>
80106235:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106238:	8b 47 34             	mov    0x34(%edi),%eax
8010623b:	8b 77 30             	mov    0x30(%edi),%esi
8010623e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106241:	e8 aa db ff ff       	call   80103df0 <myproc>
80106246:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106249:	e8 a2 db ff ff       	call   80103df0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010624e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106251:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106254:	51                   	push   %ecx
80106255:	53                   	push   %ebx
80106256:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106257:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010625a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010625d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010625e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106261:	52                   	push   %edx
80106262:	ff 70 10             	pushl  0x10(%eax)
80106265:	68 94 83 10 80       	push   $0x80108394
8010626a:	e8 f1 a3 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010626f:	83 c4 20             	add    $0x20,%esp
80106272:	e8 79 db ff ff       	call   80103df0 <myproc>
80106277:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010627e:	e8 6d db ff ff       	call   80103df0 <myproc>
80106283:	85 c0                	test   %eax,%eax
80106285:	74 1d                	je     801062a4 <trap+0xc4>
80106287:	e8 64 db ff ff       	call   80103df0 <myproc>
8010628c:	8b 50 24             	mov    0x24(%eax),%edx
8010628f:	85 d2                	test   %edx,%edx
80106291:	74 11                	je     801062a4 <trap+0xc4>
80106293:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106297:	83 e0 03             	and    $0x3,%eax
8010629a:	66 83 f8 03          	cmp    $0x3,%ax
8010629e:	0f 84 4c 01 00 00    	je     801063f0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801062a4:	e8 47 db ff ff       	call   80103df0 <myproc>
801062a9:	85 c0                	test   %eax,%eax
801062ab:	74 0b                	je     801062b8 <trap+0xd8>
801062ad:	e8 3e db ff ff       	call   80103df0 <myproc>
801062b2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062b6:	74 68                	je     80106320 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062b8:	e8 33 db ff ff       	call   80103df0 <myproc>
801062bd:	85 c0                	test   %eax,%eax
801062bf:	74 19                	je     801062da <trap+0xfa>
801062c1:	e8 2a db ff ff       	call   80103df0 <myproc>
801062c6:	8b 40 24             	mov    0x24(%eax),%eax
801062c9:	85 c0                	test   %eax,%eax
801062cb:	74 0d                	je     801062da <trap+0xfa>
801062cd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801062d1:	83 e0 03             	and    $0x3,%eax
801062d4:	66 83 f8 03          	cmp    $0x3,%ax
801062d8:	74 37                	je     80106311 <trap+0x131>
    exit();
}
801062da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062dd:	5b                   	pop    %ebx
801062de:	5e                   	pop    %esi
801062df:	5f                   	pop    %edi
801062e0:	5d                   	pop    %ebp
801062e1:	c3                   	ret    
801062e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801062e8:	e8 03 db ff ff       	call   80103df0 <myproc>
801062ed:	8b 58 24             	mov    0x24(%eax),%ebx
801062f0:	85 db                	test   %ebx,%ebx
801062f2:	0f 85 e8 00 00 00    	jne    801063e0 <trap+0x200>
    myproc()->tf = tf;
801062f8:	e8 f3 da ff ff       	call   80103df0 <myproc>
801062fd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106300:	e8 bb ee ff ff       	call   801051c0 <syscall>
    if(myproc()->killed)
80106305:	e8 e6 da ff ff       	call   80103df0 <myproc>
8010630a:	8b 48 24             	mov    0x24(%eax),%ecx
8010630d:	85 c9                	test   %ecx,%ecx
8010630f:	74 c9                	je     801062da <trap+0xfa>
}
80106311:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106314:	5b                   	pop    %ebx
80106315:	5e                   	pop    %esi
80106316:	5f                   	pop    %edi
80106317:	5d                   	pop    %ebp
      exit();
80106318:	e9 83 df ff ff       	jmp    801042a0 <exit>
8010631d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106320:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106324:	75 92                	jne    801062b8 <trap+0xd8>
    yield();
80106326:	e8 f5 e0 ff ff       	call   80104420 <yield>
8010632b:	eb 8b                	jmp    801062b8 <trap+0xd8>
8010632d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106330:	e8 9b da ff ff       	call   80103dd0 <cpuid>
80106335:	85 c0                	test   %eax,%eax
80106337:	0f 84 c3 00 00 00    	je     80106400 <trap+0x220>
    lapiceoi();
8010633d:	e8 1e c4 ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106342:	e8 a9 da ff ff       	call   80103df0 <myproc>
80106347:	85 c0                	test   %eax,%eax
80106349:	0f 85 38 ff ff ff    	jne    80106287 <trap+0xa7>
8010634f:	e9 50 ff ff ff       	jmp    801062a4 <trap+0xc4>
80106354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106358:	e8 c3 c2 ff ff       	call   80102620 <kbdintr>
    lapiceoi();
8010635d:	e8 fe c3 ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106362:	e8 89 da ff ff       	call   80103df0 <myproc>
80106367:	85 c0                	test   %eax,%eax
80106369:	0f 85 18 ff ff ff    	jne    80106287 <trap+0xa7>
8010636f:	e9 30 ff ff ff       	jmp    801062a4 <trap+0xc4>
80106374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106378:	e8 53 02 00 00       	call   801065d0 <uartintr>
    lapiceoi();
8010637d:	e8 de c3 ff ff       	call   80102760 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106382:	e8 69 da ff ff       	call   80103df0 <myproc>
80106387:	85 c0                	test   %eax,%eax
80106389:	0f 85 f8 fe ff ff    	jne    80106287 <trap+0xa7>
8010638f:	e9 10 ff ff ff       	jmp    801062a4 <trap+0xc4>
80106394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106398:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010639c:	8b 77 38             	mov    0x38(%edi),%esi
8010639f:	e8 2c da ff ff       	call   80103dd0 <cpuid>
801063a4:	56                   	push   %esi
801063a5:	53                   	push   %ebx
801063a6:	50                   	push   %eax
801063a7:	68 3c 83 10 80       	push   $0x8010833c
801063ac:	e8 af a2 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801063b1:	e8 aa c3 ff ff       	call   80102760 <lapiceoi>
    break;
801063b6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063b9:	e8 32 da ff ff       	call   80103df0 <myproc>
801063be:	85 c0                	test   %eax,%eax
801063c0:	0f 85 c1 fe ff ff    	jne    80106287 <trap+0xa7>
801063c6:	e9 d9 fe ff ff       	jmp    801062a4 <trap+0xc4>
801063cb:	90                   	nop
801063cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801063d0:	e8 bb bc ff ff       	call   80102090 <ideintr>
801063d5:	e9 63 ff ff ff       	jmp    8010633d <trap+0x15d>
801063da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801063e0:	e8 bb de ff ff       	call   801042a0 <exit>
801063e5:	e9 0e ff ff ff       	jmp    801062f8 <trap+0x118>
801063ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801063f0:	e8 ab de ff ff       	call   801042a0 <exit>
801063f5:	e9 aa fe ff ff       	jmp    801062a4 <trap+0xc4>
801063fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106400:	83 ec 0c             	sub    $0xc,%esp
80106403:	68 60 b8 11 80       	push   $0x8011b860
80106408:	e8 b3 e8 ff ff       	call   80104cc0 <acquire>
      wakeup(&ticks);
8010640d:	c7 04 24 a0 c0 11 80 	movl   $0x8011c0a0,(%esp)
      ticks++;
80106414:	83 05 a0 c0 11 80 01 	addl   $0x1,0x8011c0a0
      wakeup(&ticks);
8010641b:	e8 10 e2 ff ff       	call   80104630 <wakeup>
      release(&tickslock);
80106420:	c7 04 24 60 b8 11 80 	movl   $0x8011b860,(%esp)
80106427:	e8 54 e9 ff ff       	call   80104d80 <release>
8010642c:	83 c4 10             	add    $0x10,%esp
8010642f:	e9 09 ff ff ff       	jmp    8010633d <trap+0x15d>
80106434:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106437:	e8 94 d9 ff ff       	call   80103dd0 <cpuid>
8010643c:	83 ec 0c             	sub    $0xc,%esp
8010643f:	56                   	push   %esi
80106440:	53                   	push   %ebx
80106441:	50                   	push   %eax
80106442:	ff 77 30             	pushl  0x30(%edi)
80106445:	68 60 83 10 80       	push   $0x80108360
8010644a:	e8 11 a2 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010644f:	83 c4 14             	add    $0x14,%esp
80106452:	68 36 83 10 80       	push   $0x80108336
80106457:	e8 34 9f ff ff       	call   80100390 <panic>
8010645c:	66 90                	xchg   %ax,%ax
8010645e:	66 90                	xchg   %ax,%ax

80106460 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106460:	a1 a0 bf 10 80       	mov    0x8010bfa0,%eax
{
80106465:	55                   	push   %ebp
80106466:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106468:	85 c0                	test   %eax,%eax
8010646a:	74 1c                	je     80106488 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010646c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106471:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106472:	a8 01                	test   $0x1,%al
80106474:	74 12                	je     80106488 <uartgetc+0x28>
80106476:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010647b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010647c:	0f b6 c0             	movzbl %al,%eax
}
8010647f:	5d                   	pop    %ebp
80106480:	c3                   	ret    
80106481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010648d:	5d                   	pop    %ebp
8010648e:	c3                   	ret    
8010648f:	90                   	nop

80106490 <uartputc.part.0>:
uartputc(int c)
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	57                   	push   %edi
80106494:	56                   	push   %esi
80106495:	53                   	push   %ebx
80106496:	89 c7                	mov    %eax,%edi
80106498:	bb 80 00 00 00       	mov    $0x80,%ebx
8010649d:	be fd 03 00 00       	mov    $0x3fd,%esi
801064a2:	83 ec 0c             	sub    $0xc,%esp
801064a5:	eb 1b                	jmp    801064c2 <uartputc.part.0+0x32>
801064a7:	89 f6                	mov    %esi,%esi
801064a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801064b0:	83 ec 0c             	sub    $0xc,%esp
801064b3:	6a 0a                	push   $0xa
801064b5:	e8 c6 c2 ff ff       	call   80102780 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064ba:	83 c4 10             	add    $0x10,%esp
801064bd:	83 eb 01             	sub    $0x1,%ebx
801064c0:	74 07                	je     801064c9 <uartputc.part.0+0x39>
801064c2:	89 f2                	mov    %esi,%edx
801064c4:	ec                   	in     (%dx),%al
801064c5:	a8 20                	test   $0x20,%al
801064c7:	74 e7                	je     801064b0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064c9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064ce:	89 f8                	mov    %edi,%eax
801064d0:	ee                   	out    %al,(%dx)
}
801064d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064d4:	5b                   	pop    %ebx
801064d5:	5e                   	pop    %esi
801064d6:	5f                   	pop    %edi
801064d7:	5d                   	pop    %ebp
801064d8:	c3                   	ret    
801064d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064e0 <uartinit>:
{
801064e0:	55                   	push   %ebp
801064e1:	31 c9                	xor    %ecx,%ecx
801064e3:	89 c8                	mov    %ecx,%eax
801064e5:	89 e5                	mov    %esp,%ebp
801064e7:	57                   	push   %edi
801064e8:	56                   	push   %esi
801064e9:	53                   	push   %ebx
801064ea:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801064ef:	89 da                	mov    %ebx,%edx
801064f1:	83 ec 0c             	sub    $0xc,%esp
801064f4:	ee                   	out    %al,(%dx)
801064f5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801064fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801064ff:	89 fa                	mov    %edi,%edx
80106501:	ee                   	out    %al,(%dx)
80106502:	b8 0c 00 00 00       	mov    $0xc,%eax
80106507:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010650c:	ee                   	out    %al,(%dx)
8010650d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106512:	89 c8                	mov    %ecx,%eax
80106514:	89 f2                	mov    %esi,%edx
80106516:	ee                   	out    %al,(%dx)
80106517:	b8 03 00 00 00       	mov    $0x3,%eax
8010651c:	89 fa                	mov    %edi,%edx
8010651e:	ee                   	out    %al,(%dx)
8010651f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106524:	89 c8                	mov    %ecx,%eax
80106526:	ee                   	out    %al,(%dx)
80106527:	b8 01 00 00 00       	mov    $0x1,%eax
8010652c:	89 f2                	mov    %esi,%edx
8010652e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010652f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106534:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106535:	3c ff                	cmp    $0xff,%al
80106537:	74 5a                	je     80106593 <uartinit+0xb3>
  uart = 1;
80106539:	c7 05 a0 bf 10 80 01 	movl   $0x1,0x8010bfa0
80106540:	00 00 00 
80106543:	89 da                	mov    %ebx,%edx
80106545:	ec                   	in     (%dx),%al
80106546:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010654b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010654c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010654f:	bb 58 84 10 80       	mov    $0x80108458,%ebx
  ioapicenable(IRQ_COM1, 0);
80106554:	6a 00                	push   $0x0
80106556:	6a 04                	push   $0x4
80106558:	e8 83 bd ff ff       	call   801022e0 <ioapicenable>
8010655d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106560:	b8 78 00 00 00       	mov    $0x78,%eax
80106565:	eb 13                	jmp    8010657a <uartinit+0x9a>
80106567:	89 f6                	mov    %esi,%esi
80106569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106570:	83 c3 01             	add    $0x1,%ebx
80106573:	0f be 03             	movsbl (%ebx),%eax
80106576:	84 c0                	test   %al,%al
80106578:	74 19                	je     80106593 <uartinit+0xb3>
  if(!uart)
8010657a:	8b 15 a0 bf 10 80    	mov    0x8010bfa0,%edx
80106580:	85 d2                	test   %edx,%edx
80106582:	74 ec                	je     80106570 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106584:	83 c3 01             	add    $0x1,%ebx
80106587:	e8 04 ff ff ff       	call   80106490 <uartputc.part.0>
8010658c:	0f be 03             	movsbl (%ebx),%eax
8010658f:	84 c0                	test   %al,%al
80106591:	75 e7                	jne    8010657a <uartinit+0x9a>
}
80106593:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106596:	5b                   	pop    %ebx
80106597:	5e                   	pop    %esi
80106598:	5f                   	pop    %edi
80106599:	5d                   	pop    %ebp
8010659a:	c3                   	ret    
8010659b:	90                   	nop
8010659c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801065a0 <uartputc>:
  if(!uart)
801065a0:	8b 15 a0 bf 10 80    	mov    0x8010bfa0,%edx
{
801065a6:	55                   	push   %ebp
801065a7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801065a9:	85 d2                	test   %edx,%edx
{
801065ab:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801065ae:	74 10                	je     801065c0 <uartputc+0x20>
}
801065b0:	5d                   	pop    %ebp
801065b1:	e9 da fe ff ff       	jmp    80106490 <uartputc.part.0>
801065b6:	8d 76 00             	lea    0x0(%esi),%esi
801065b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801065c0:	5d                   	pop    %ebp
801065c1:	c3                   	ret    
801065c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065d0 <uartintr>:

void
uartintr(void)
{
801065d0:	55                   	push   %ebp
801065d1:	89 e5                	mov    %esp,%ebp
801065d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065d6:	68 60 64 10 80       	push   $0x80106460
801065db:	e8 30 a2 ff ff       	call   80100810 <consoleintr>
}
801065e0:	83 c4 10             	add    $0x10,%esp
801065e3:	c9                   	leave  
801065e4:	c3                   	ret    

801065e5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $0
801065e7:	6a 00                	push   $0x0
  jmp alltraps
801065e9:	e9 14 fb ff ff       	jmp    80106102 <alltraps>

801065ee <vector1>:
.globl vector1
vector1:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $1
801065f0:	6a 01                	push   $0x1
  jmp alltraps
801065f2:	e9 0b fb ff ff       	jmp    80106102 <alltraps>

801065f7 <vector2>:
.globl vector2
vector2:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $2
801065f9:	6a 02                	push   $0x2
  jmp alltraps
801065fb:	e9 02 fb ff ff       	jmp    80106102 <alltraps>

80106600 <vector3>:
.globl vector3
vector3:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $3
80106602:	6a 03                	push   $0x3
  jmp alltraps
80106604:	e9 f9 fa ff ff       	jmp    80106102 <alltraps>

80106609 <vector4>:
.globl vector4
vector4:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $4
8010660b:	6a 04                	push   $0x4
  jmp alltraps
8010660d:	e9 f0 fa ff ff       	jmp    80106102 <alltraps>

80106612 <vector5>:
.globl vector5
vector5:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $5
80106614:	6a 05                	push   $0x5
  jmp alltraps
80106616:	e9 e7 fa ff ff       	jmp    80106102 <alltraps>

8010661b <vector6>:
.globl vector6
vector6:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $6
8010661d:	6a 06                	push   $0x6
  jmp alltraps
8010661f:	e9 de fa ff ff       	jmp    80106102 <alltraps>

80106624 <vector7>:
.globl vector7
vector7:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $7
80106626:	6a 07                	push   $0x7
  jmp alltraps
80106628:	e9 d5 fa ff ff       	jmp    80106102 <alltraps>

8010662d <vector8>:
.globl vector8
vector8:
  pushl $8
8010662d:	6a 08                	push   $0x8
  jmp alltraps
8010662f:	e9 ce fa ff ff       	jmp    80106102 <alltraps>

80106634 <vector9>:
.globl vector9
vector9:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $9
80106636:	6a 09                	push   $0x9
  jmp alltraps
80106638:	e9 c5 fa ff ff       	jmp    80106102 <alltraps>

8010663d <vector10>:
.globl vector10
vector10:
  pushl $10
8010663d:	6a 0a                	push   $0xa
  jmp alltraps
8010663f:	e9 be fa ff ff       	jmp    80106102 <alltraps>

80106644 <vector11>:
.globl vector11
vector11:
  pushl $11
80106644:	6a 0b                	push   $0xb
  jmp alltraps
80106646:	e9 b7 fa ff ff       	jmp    80106102 <alltraps>

8010664b <vector12>:
.globl vector12
vector12:
  pushl $12
8010664b:	6a 0c                	push   $0xc
  jmp alltraps
8010664d:	e9 b0 fa ff ff       	jmp    80106102 <alltraps>

80106652 <vector13>:
.globl vector13
vector13:
  pushl $13
80106652:	6a 0d                	push   $0xd
  jmp alltraps
80106654:	e9 a9 fa ff ff       	jmp    80106102 <alltraps>

80106659 <vector14>:
.globl vector14
vector14:
  pushl $14
80106659:	6a 0e                	push   $0xe
  jmp alltraps
8010665b:	e9 a2 fa ff ff       	jmp    80106102 <alltraps>

80106660 <vector15>:
.globl vector15
vector15:
  pushl $0
80106660:	6a 00                	push   $0x0
  pushl $15
80106662:	6a 0f                	push   $0xf
  jmp alltraps
80106664:	e9 99 fa ff ff       	jmp    80106102 <alltraps>

80106669 <vector16>:
.globl vector16
vector16:
  pushl $0
80106669:	6a 00                	push   $0x0
  pushl $16
8010666b:	6a 10                	push   $0x10
  jmp alltraps
8010666d:	e9 90 fa ff ff       	jmp    80106102 <alltraps>

80106672 <vector17>:
.globl vector17
vector17:
  pushl $17
80106672:	6a 11                	push   $0x11
  jmp alltraps
80106674:	e9 89 fa ff ff       	jmp    80106102 <alltraps>

80106679 <vector18>:
.globl vector18
vector18:
  pushl $0
80106679:	6a 00                	push   $0x0
  pushl $18
8010667b:	6a 12                	push   $0x12
  jmp alltraps
8010667d:	e9 80 fa ff ff       	jmp    80106102 <alltraps>

80106682 <vector19>:
.globl vector19
vector19:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $19
80106684:	6a 13                	push   $0x13
  jmp alltraps
80106686:	e9 77 fa ff ff       	jmp    80106102 <alltraps>

8010668b <vector20>:
.globl vector20
vector20:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $20
8010668d:	6a 14                	push   $0x14
  jmp alltraps
8010668f:	e9 6e fa ff ff       	jmp    80106102 <alltraps>

80106694 <vector21>:
.globl vector21
vector21:
  pushl $0
80106694:	6a 00                	push   $0x0
  pushl $21
80106696:	6a 15                	push   $0x15
  jmp alltraps
80106698:	e9 65 fa ff ff       	jmp    80106102 <alltraps>

8010669d <vector22>:
.globl vector22
vector22:
  pushl $0
8010669d:	6a 00                	push   $0x0
  pushl $22
8010669f:	6a 16                	push   $0x16
  jmp alltraps
801066a1:	e9 5c fa ff ff       	jmp    80106102 <alltraps>

801066a6 <vector23>:
.globl vector23
vector23:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $23
801066a8:	6a 17                	push   $0x17
  jmp alltraps
801066aa:	e9 53 fa ff ff       	jmp    80106102 <alltraps>

801066af <vector24>:
.globl vector24
vector24:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $24
801066b1:	6a 18                	push   $0x18
  jmp alltraps
801066b3:	e9 4a fa ff ff       	jmp    80106102 <alltraps>

801066b8 <vector25>:
.globl vector25
vector25:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $25
801066ba:	6a 19                	push   $0x19
  jmp alltraps
801066bc:	e9 41 fa ff ff       	jmp    80106102 <alltraps>

801066c1 <vector26>:
.globl vector26
vector26:
  pushl $0
801066c1:	6a 00                	push   $0x0
  pushl $26
801066c3:	6a 1a                	push   $0x1a
  jmp alltraps
801066c5:	e9 38 fa ff ff       	jmp    80106102 <alltraps>

801066ca <vector27>:
.globl vector27
vector27:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $27
801066cc:	6a 1b                	push   $0x1b
  jmp alltraps
801066ce:	e9 2f fa ff ff       	jmp    80106102 <alltraps>

801066d3 <vector28>:
.globl vector28
vector28:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $28
801066d5:	6a 1c                	push   $0x1c
  jmp alltraps
801066d7:	e9 26 fa ff ff       	jmp    80106102 <alltraps>

801066dc <vector29>:
.globl vector29
vector29:
  pushl $0
801066dc:	6a 00                	push   $0x0
  pushl $29
801066de:	6a 1d                	push   $0x1d
  jmp alltraps
801066e0:	e9 1d fa ff ff       	jmp    80106102 <alltraps>

801066e5 <vector30>:
.globl vector30
vector30:
  pushl $0
801066e5:	6a 00                	push   $0x0
  pushl $30
801066e7:	6a 1e                	push   $0x1e
  jmp alltraps
801066e9:	e9 14 fa ff ff       	jmp    80106102 <alltraps>

801066ee <vector31>:
.globl vector31
vector31:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $31
801066f0:	6a 1f                	push   $0x1f
  jmp alltraps
801066f2:	e9 0b fa ff ff       	jmp    80106102 <alltraps>

801066f7 <vector32>:
.globl vector32
vector32:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $32
801066f9:	6a 20                	push   $0x20
  jmp alltraps
801066fb:	e9 02 fa ff ff       	jmp    80106102 <alltraps>

80106700 <vector33>:
.globl vector33
vector33:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $33
80106702:	6a 21                	push   $0x21
  jmp alltraps
80106704:	e9 f9 f9 ff ff       	jmp    80106102 <alltraps>

80106709 <vector34>:
.globl vector34
vector34:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $34
8010670b:	6a 22                	push   $0x22
  jmp alltraps
8010670d:	e9 f0 f9 ff ff       	jmp    80106102 <alltraps>

80106712 <vector35>:
.globl vector35
vector35:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $35
80106714:	6a 23                	push   $0x23
  jmp alltraps
80106716:	e9 e7 f9 ff ff       	jmp    80106102 <alltraps>

8010671b <vector36>:
.globl vector36
vector36:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $36
8010671d:	6a 24                	push   $0x24
  jmp alltraps
8010671f:	e9 de f9 ff ff       	jmp    80106102 <alltraps>

80106724 <vector37>:
.globl vector37
vector37:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $37
80106726:	6a 25                	push   $0x25
  jmp alltraps
80106728:	e9 d5 f9 ff ff       	jmp    80106102 <alltraps>

8010672d <vector38>:
.globl vector38
vector38:
  pushl $0
8010672d:	6a 00                	push   $0x0
  pushl $38
8010672f:	6a 26                	push   $0x26
  jmp alltraps
80106731:	e9 cc f9 ff ff       	jmp    80106102 <alltraps>

80106736 <vector39>:
.globl vector39
vector39:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $39
80106738:	6a 27                	push   $0x27
  jmp alltraps
8010673a:	e9 c3 f9 ff ff       	jmp    80106102 <alltraps>

8010673f <vector40>:
.globl vector40
vector40:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $40
80106741:	6a 28                	push   $0x28
  jmp alltraps
80106743:	e9 ba f9 ff ff       	jmp    80106102 <alltraps>

80106748 <vector41>:
.globl vector41
vector41:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $41
8010674a:	6a 29                	push   $0x29
  jmp alltraps
8010674c:	e9 b1 f9 ff ff       	jmp    80106102 <alltraps>

80106751 <vector42>:
.globl vector42
vector42:
  pushl $0
80106751:	6a 00                	push   $0x0
  pushl $42
80106753:	6a 2a                	push   $0x2a
  jmp alltraps
80106755:	e9 a8 f9 ff ff       	jmp    80106102 <alltraps>

8010675a <vector43>:
.globl vector43
vector43:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $43
8010675c:	6a 2b                	push   $0x2b
  jmp alltraps
8010675e:	e9 9f f9 ff ff       	jmp    80106102 <alltraps>

80106763 <vector44>:
.globl vector44
vector44:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $44
80106765:	6a 2c                	push   $0x2c
  jmp alltraps
80106767:	e9 96 f9 ff ff       	jmp    80106102 <alltraps>

8010676c <vector45>:
.globl vector45
vector45:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $45
8010676e:	6a 2d                	push   $0x2d
  jmp alltraps
80106770:	e9 8d f9 ff ff       	jmp    80106102 <alltraps>

80106775 <vector46>:
.globl vector46
vector46:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $46
80106777:	6a 2e                	push   $0x2e
  jmp alltraps
80106779:	e9 84 f9 ff ff       	jmp    80106102 <alltraps>

8010677e <vector47>:
.globl vector47
vector47:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $47
80106780:	6a 2f                	push   $0x2f
  jmp alltraps
80106782:	e9 7b f9 ff ff       	jmp    80106102 <alltraps>

80106787 <vector48>:
.globl vector48
vector48:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $48
80106789:	6a 30                	push   $0x30
  jmp alltraps
8010678b:	e9 72 f9 ff ff       	jmp    80106102 <alltraps>

80106790 <vector49>:
.globl vector49
vector49:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $49
80106792:	6a 31                	push   $0x31
  jmp alltraps
80106794:	e9 69 f9 ff ff       	jmp    80106102 <alltraps>

80106799 <vector50>:
.globl vector50
vector50:
  pushl $0
80106799:	6a 00                	push   $0x0
  pushl $50
8010679b:	6a 32                	push   $0x32
  jmp alltraps
8010679d:	e9 60 f9 ff ff       	jmp    80106102 <alltraps>

801067a2 <vector51>:
.globl vector51
vector51:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $51
801067a4:	6a 33                	push   $0x33
  jmp alltraps
801067a6:	e9 57 f9 ff ff       	jmp    80106102 <alltraps>

801067ab <vector52>:
.globl vector52
vector52:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $52
801067ad:	6a 34                	push   $0x34
  jmp alltraps
801067af:	e9 4e f9 ff ff       	jmp    80106102 <alltraps>

801067b4 <vector53>:
.globl vector53
vector53:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $53
801067b6:	6a 35                	push   $0x35
  jmp alltraps
801067b8:	e9 45 f9 ff ff       	jmp    80106102 <alltraps>

801067bd <vector54>:
.globl vector54
vector54:
  pushl $0
801067bd:	6a 00                	push   $0x0
  pushl $54
801067bf:	6a 36                	push   $0x36
  jmp alltraps
801067c1:	e9 3c f9 ff ff       	jmp    80106102 <alltraps>

801067c6 <vector55>:
.globl vector55
vector55:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $55
801067c8:	6a 37                	push   $0x37
  jmp alltraps
801067ca:	e9 33 f9 ff ff       	jmp    80106102 <alltraps>

801067cf <vector56>:
.globl vector56
vector56:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $56
801067d1:	6a 38                	push   $0x38
  jmp alltraps
801067d3:	e9 2a f9 ff ff       	jmp    80106102 <alltraps>

801067d8 <vector57>:
.globl vector57
vector57:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $57
801067da:	6a 39                	push   $0x39
  jmp alltraps
801067dc:	e9 21 f9 ff ff       	jmp    80106102 <alltraps>

801067e1 <vector58>:
.globl vector58
vector58:
  pushl $0
801067e1:	6a 00                	push   $0x0
  pushl $58
801067e3:	6a 3a                	push   $0x3a
  jmp alltraps
801067e5:	e9 18 f9 ff ff       	jmp    80106102 <alltraps>

801067ea <vector59>:
.globl vector59
vector59:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $59
801067ec:	6a 3b                	push   $0x3b
  jmp alltraps
801067ee:	e9 0f f9 ff ff       	jmp    80106102 <alltraps>

801067f3 <vector60>:
.globl vector60
vector60:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $60
801067f5:	6a 3c                	push   $0x3c
  jmp alltraps
801067f7:	e9 06 f9 ff ff       	jmp    80106102 <alltraps>

801067fc <vector61>:
.globl vector61
vector61:
  pushl $0
801067fc:	6a 00                	push   $0x0
  pushl $61
801067fe:	6a 3d                	push   $0x3d
  jmp alltraps
80106800:	e9 fd f8 ff ff       	jmp    80106102 <alltraps>

80106805 <vector62>:
.globl vector62
vector62:
  pushl $0
80106805:	6a 00                	push   $0x0
  pushl $62
80106807:	6a 3e                	push   $0x3e
  jmp alltraps
80106809:	e9 f4 f8 ff ff       	jmp    80106102 <alltraps>

8010680e <vector63>:
.globl vector63
vector63:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $63
80106810:	6a 3f                	push   $0x3f
  jmp alltraps
80106812:	e9 eb f8 ff ff       	jmp    80106102 <alltraps>

80106817 <vector64>:
.globl vector64
vector64:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $64
80106819:	6a 40                	push   $0x40
  jmp alltraps
8010681b:	e9 e2 f8 ff ff       	jmp    80106102 <alltraps>

80106820 <vector65>:
.globl vector65
vector65:
  pushl $0
80106820:	6a 00                	push   $0x0
  pushl $65
80106822:	6a 41                	push   $0x41
  jmp alltraps
80106824:	e9 d9 f8 ff ff       	jmp    80106102 <alltraps>

80106829 <vector66>:
.globl vector66
vector66:
  pushl $0
80106829:	6a 00                	push   $0x0
  pushl $66
8010682b:	6a 42                	push   $0x42
  jmp alltraps
8010682d:	e9 d0 f8 ff ff       	jmp    80106102 <alltraps>

80106832 <vector67>:
.globl vector67
vector67:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $67
80106834:	6a 43                	push   $0x43
  jmp alltraps
80106836:	e9 c7 f8 ff ff       	jmp    80106102 <alltraps>

8010683b <vector68>:
.globl vector68
vector68:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $68
8010683d:	6a 44                	push   $0x44
  jmp alltraps
8010683f:	e9 be f8 ff ff       	jmp    80106102 <alltraps>

80106844 <vector69>:
.globl vector69
vector69:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $69
80106846:	6a 45                	push   $0x45
  jmp alltraps
80106848:	e9 b5 f8 ff ff       	jmp    80106102 <alltraps>

8010684d <vector70>:
.globl vector70
vector70:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $70
8010684f:	6a 46                	push   $0x46
  jmp alltraps
80106851:	e9 ac f8 ff ff       	jmp    80106102 <alltraps>

80106856 <vector71>:
.globl vector71
vector71:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $71
80106858:	6a 47                	push   $0x47
  jmp alltraps
8010685a:	e9 a3 f8 ff ff       	jmp    80106102 <alltraps>

8010685f <vector72>:
.globl vector72
vector72:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $72
80106861:	6a 48                	push   $0x48
  jmp alltraps
80106863:	e9 9a f8 ff ff       	jmp    80106102 <alltraps>

80106868 <vector73>:
.globl vector73
vector73:
  pushl $0
80106868:	6a 00                	push   $0x0
  pushl $73
8010686a:	6a 49                	push   $0x49
  jmp alltraps
8010686c:	e9 91 f8 ff ff       	jmp    80106102 <alltraps>

80106871 <vector74>:
.globl vector74
vector74:
  pushl $0
80106871:	6a 00                	push   $0x0
  pushl $74
80106873:	6a 4a                	push   $0x4a
  jmp alltraps
80106875:	e9 88 f8 ff ff       	jmp    80106102 <alltraps>

8010687a <vector75>:
.globl vector75
vector75:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $75
8010687c:	6a 4b                	push   $0x4b
  jmp alltraps
8010687e:	e9 7f f8 ff ff       	jmp    80106102 <alltraps>

80106883 <vector76>:
.globl vector76
vector76:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $76
80106885:	6a 4c                	push   $0x4c
  jmp alltraps
80106887:	e9 76 f8 ff ff       	jmp    80106102 <alltraps>

8010688c <vector77>:
.globl vector77
vector77:
  pushl $0
8010688c:	6a 00                	push   $0x0
  pushl $77
8010688e:	6a 4d                	push   $0x4d
  jmp alltraps
80106890:	e9 6d f8 ff ff       	jmp    80106102 <alltraps>

80106895 <vector78>:
.globl vector78
vector78:
  pushl $0
80106895:	6a 00                	push   $0x0
  pushl $78
80106897:	6a 4e                	push   $0x4e
  jmp alltraps
80106899:	e9 64 f8 ff ff       	jmp    80106102 <alltraps>

8010689e <vector79>:
.globl vector79
vector79:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $79
801068a0:	6a 4f                	push   $0x4f
  jmp alltraps
801068a2:	e9 5b f8 ff ff       	jmp    80106102 <alltraps>

801068a7 <vector80>:
.globl vector80
vector80:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $80
801068a9:	6a 50                	push   $0x50
  jmp alltraps
801068ab:	e9 52 f8 ff ff       	jmp    80106102 <alltraps>

801068b0 <vector81>:
.globl vector81
vector81:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $81
801068b2:	6a 51                	push   $0x51
  jmp alltraps
801068b4:	e9 49 f8 ff ff       	jmp    80106102 <alltraps>

801068b9 <vector82>:
.globl vector82
vector82:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $82
801068bb:	6a 52                	push   $0x52
  jmp alltraps
801068bd:	e9 40 f8 ff ff       	jmp    80106102 <alltraps>

801068c2 <vector83>:
.globl vector83
vector83:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $83
801068c4:	6a 53                	push   $0x53
  jmp alltraps
801068c6:	e9 37 f8 ff ff       	jmp    80106102 <alltraps>

801068cb <vector84>:
.globl vector84
vector84:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $84
801068cd:	6a 54                	push   $0x54
  jmp alltraps
801068cf:	e9 2e f8 ff ff       	jmp    80106102 <alltraps>

801068d4 <vector85>:
.globl vector85
vector85:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $85
801068d6:	6a 55                	push   $0x55
  jmp alltraps
801068d8:	e9 25 f8 ff ff       	jmp    80106102 <alltraps>

801068dd <vector86>:
.globl vector86
vector86:
  pushl $0
801068dd:	6a 00                	push   $0x0
  pushl $86
801068df:	6a 56                	push   $0x56
  jmp alltraps
801068e1:	e9 1c f8 ff ff       	jmp    80106102 <alltraps>

801068e6 <vector87>:
.globl vector87
vector87:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $87
801068e8:	6a 57                	push   $0x57
  jmp alltraps
801068ea:	e9 13 f8 ff ff       	jmp    80106102 <alltraps>

801068ef <vector88>:
.globl vector88
vector88:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $88
801068f1:	6a 58                	push   $0x58
  jmp alltraps
801068f3:	e9 0a f8 ff ff       	jmp    80106102 <alltraps>

801068f8 <vector89>:
.globl vector89
vector89:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $89
801068fa:	6a 59                	push   $0x59
  jmp alltraps
801068fc:	e9 01 f8 ff ff       	jmp    80106102 <alltraps>

80106901 <vector90>:
.globl vector90
vector90:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $90
80106903:	6a 5a                	push   $0x5a
  jmp alltraps
80106905:	e9 f8 f7 ff ff       	jmp    80106102 <alltraps>

8010690a <vector91>:
.globl vector91
vector91:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $91
8010690c:	6a 5b                	push   $0x5b
  jmp alltraps
8010690e:	e9 ef f7 ff ff       	jmp    80106102 <alltraps>

80106913 <vector92>:
.globl vector92
vector92:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $92
80106915:	6a 5c                	push   $0x5c
  jmp alltraps
80106917:	e9 e6 f7 ff ff       	jmp    80106102 <alltraps>

8010691c <vector93>:
.globl vector93
vector93:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $93
8010691e:	6a 5d                	push   $0x5d
  jmp alltraps
80106920:	e9 dd f7 ff ff       	jmp    80106102 <alltraps>

80106925 <vector94>:
.globl vector94
vector94:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $94
80106927:	6a 5e                	push   $0x5e
  jmp alltraps
80106929:	e9 d4 f7 ff ff       	jmp    80106102 <alltraps>

8010692e <vector95>:
.globl vector95
vector95:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $95
80106930:	6a 5f                	push   $0x5f
  jmp alltraps
80106932:	e9 cb f7 ff ff       	jmp    80106102 <alltraps>

80106937 <vector96>:
.globl vector96
vector96:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $96
80106939:	6a 60                	push   $0x60
  jmp alltraps
8010693b:	e9 c2 f7 ff ff       	jmp    80106102 <alltraps>

80106940 <vector97>:
.globl vector97
vector97:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $97
80106942:	6a 61                	push   $0x61
  jmp alltraps
80106944:	e9 b9 f7 ff ff       	jmp    80106102 <alltraps>

80106949 <vector98>:
.globl vector98
vector98:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $98
8010694b:	6a 62                	push   $0x62
  jmp alltraps
8010694d:	e9 b0 f7 ff ff       	jmp    80106102 <alltraps>

80106952 <vector99>:
.globl vector99
vector99:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $99
80106954:	6a 63                	push   $0x63
  jmp alltraps
80106956:	e9 a7 f7 ff ff       	jmp    80106102 <alltraps>

8010695b <vector100>:
.globl vector100
vector100:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $100
8010695d:	6a 64                	push   $0x64
  jmp alltraps
8010695f:	e9 9e f7 ff ff       	jmp    80106102 <alltraps>

80106964 <vector101>:
.globl vector101
vector101:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $101
80106966:	6a 65                	push   $0x65
  jmp alltraps
80106968:	e9 95 f7 ff ff       	jmp    80106102 <alltraps>

8010696d <vector102>:
.globl vector102
vector102:
  pushl $0
8010696d:	6a 00                	push   $0x0
  pushl $102
8010696f:	6a 66                	push   $0x66
  jmp alltraps
80106971:	e9 8c f7 ff ff       	jmp    80106102 <alltraps>

80106976 <vector103>:
.globl vector103
vector103:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $103
80106978:	6a 67                	push   $0x67
  jmp alltraps
8010697a:	e9 83 f7 ff ff       	jmp    80106102 <alltraps>

8010697f <vector104>:
.globl vector104
vector104:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $104
80106981:	6a 68                	push   $0x68
  jmp alltraps
80106983:	e9 7a f7 ff ff       	jmp    80106102 <alltraps>

80106988 <vector105>:
.globl vector105
vector105:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $105
8010698a:	6a 69                	push   $0x69
  jmp alltraps
8010698c:	e9 71 f7 ff ff       	jmp    80106102 <alltraps>

80106991 <vector106>:
.globl vector106
vector106:
  pushl $0
80106991:	6a 00                	push   $0x0
  pushl $106
80106993:	6a 6a                	push   $0x6a
  jmp alltraps
80106995:	e9 68 f7 ff ff       	jmp    80106102 <alltraps>

8010699a <vector107>:
.globl vector107
vector107:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $107
8010699c:	6a 6b                	push   $0x6b
  jmp alltraps
8010699e:	e9 5f f7 ff ff       	jmp    80106102 <alltraps>

801069a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $108
801069a5:	6a 6c                	push   $0x6c
  jmp alltraps
801069a7:	e9 56 f7 ff ff       	jmp    80106102 <alltraps>

801069ac <vector109>:
.globl vector109
vector109:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $109
801069ae:	6a 6d                	push   $0x6d
  jmp alltraps
801069b0:	e9 4d f7 ff ff       	jmp    80106102 <alltraps>

801069b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801069b5:	6a 00                	push   $0x0
  pushl $110
801069b7:	6a 6e                	push   $0x6e
  jmp alltraps
801069b9:	e9 44 f7 ff ff       	jmp    80106102 <alltraps>

801069be <vector111>:
.globl vector111
vector111:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $111
801069c0:	6a 6f                	push   $0x6f
  jmp alltraps
801069c2:	e9 3b f7 ff ff       	jmp    80106102 <alltraps>

801069c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $112
801069c9:	6a 70                	push   $0x70
  jmp alltraps
801069cb:	e9 32 f7 ff ff       	jmp    80106102 <alltraps>

801069d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $113
801069d2:	6a 71                	push   $0x71
  jmp alltraps
801069d4:	e9 29 f7 ff ff       	jmp    80106102 <alltraps>

801069d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $114
801069db:	6a 72                	push   $0x72
  jmp alltraps
801069dd:	e9 20 f7 ff ff       	jmp    80106102 <alltraps>

801069e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $115
801069e4:	6a 73                	push   $0x73
  jmp alltraps
801069e6:	e9 17 f7 ff ff       	jmp    80106102 <alltraps>

801069eb <vector116>:
.globl vector116
vector116:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $116
801069ed:	6a 74                	push   $0x74
  jmp alltraps
801069ef:	e9 0e f7 ff ff       	jmp    80106102 <alltraps>

801069f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $117
801069f6:	6a 75                	push   $0x75
  jmp alltraps
801069f8:	e9 05 f7 ff ff       	jmp    80106102 <alltraps>

801069fd <vector118>:
.globl vector118
vector118:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $118
801069ff:	6a 76                	push   $0x76
  jmp alltraps
80106a01:	e9 fc f6 ff ff       	jmp    80106102 <alltraps>

80106a06 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $119
80106a08:	6a 77                	push   $0x77
  jmp alltraps
80106a0a:	e9 f3 f6 ff ff       	jmp    80106102 <alltraps>

80106a0f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $120
80106a11:	6a 78                	push   $0x78
  jmp alltraps
80106a13:	e9 ea f6 ff ff       	jmp    80106102 <alltraps>

80106a18 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $121
80106a1a:	6a 79                	push   $0x79
  jmp alltraps
80106a1c:	e9 e1 f6 ff ff       	jmp    80106102 <alltraps>

80106a21 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $122
80106a23:	6a 7a                	push   $0x7a
  jmp alltraps
80106a25:	e9 d8 f6 ff ff       	jmp    80106102 <alltraps>

80106a2a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $123
80106a2c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a2e:	e9 cf f6 ff ff       	jmp    80106102 <alltraps>

80106a33 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $124
80106a35:	6a 7c                	push   $0x7c
  jmp alltraps
80106a37:	e9 c6 f6 ff ff       	jmp    80106102 <alltraps>

80106a3c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $125
80106a3e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a40:	e9 bd f6 ff ff       	jmp    80106102 <alltraps>

80106a45 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $126
80106a47:	6a 7e                	push   $0x7e
  jmp alltraps
80106a49:	e9 b4 f6 ff ff       	jmp    80106102 <alltraps>

80106a4e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $127
80106a50:	6a 7f                	push   $0x7f
  jmp alltraps
80106a52:	e9 ab f6 ff ff       	jmp    80106102 <alltraps>

80106a57 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $128
80106a59:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a5e:	e9 9f f6 ff ff       	jmp    80106102 <alltraps>

80106a63 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $129
80106a65:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a6a:	e9 93 f6 ff ff       	jmp    80106102 <alltraps>

80106a6f <vector130>:
.globl vector130
vector130:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $130
80106a71:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a76:	e9 87 f6 ff ff       	jmp    80106102 <alltraps>

80106a7b <vector131>:
.globl vector131
vector131:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $131
80106a7d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a82:	e9 7b f6 ff ff       	jmp    80106102 <alltraps>

80106a87 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $132
80106a89:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a8e:	e9 6f f6 ff ff       	jmp    80106102 <alltraps>

80106a93 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $133
80106a95:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a9a:	e9 63 f6 ff ff       	jmp    80106102 <alltraps>

80106a9f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $134
80106aa1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106aa6:	e9 57 f6 ff ff       	jmp    80106102 <alltraps>

80106aab <vector135>:
.globl vector135
vector135:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $135
80106aad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ab2:	e9 4b f6 ff ff       	jmp    80106102 <alltraps>

80106ab7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $136
80106ab9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106abe:	e9 3f f6 ff ff       	jmp    80106102 <alltraps>

80106ac3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $137
80106ac5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106aca:	e9 33 f6 ff ff       	jmp    80106102 <alltraps>

80106acf <vector138>:
.globl vector138
vector138:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $138
80106ad1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ad6:	e9 27 f6 ff ff       	jmp    80106102 <alltraps>

80106adb <vector139>:
.globl vector139
vector139:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $139
80106add:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ae2:	e9 1b f6 ff ff       	jmp    80106102 <alltraps>

80106ae7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $140
80106ae9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106aee:	e9 0f f6 ff ff       	jmp    80106102 <alltraps>

80106af3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $141
80106af5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106afa:	e9 03 f6 ff ff       	jmp    80106102 <alltraps>

80106aff <vector142>:
.globl vector142
vector142:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $142
80106b01:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b06:	e9 f7 f5 ff ff       	jmp    80106102 <alltraps>

80106b0b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $143
80106b0d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b12:	e9 eb f5 ff ff       	jmp    80106102 <alltraps>

80106b17 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $144
80106b19:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b1e:	e9 df f5 ff ff       	jmp    80106102 <alltraps>

80106b23 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $145
80106b25:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b2a:	e9 d3 f5 ff ff       	jmp    80106102 <alltraps>

80106b2f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $146
80106b31:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b36:	e9 c7 f5 ff ff       	jmp    80106102 <alltraps>

80106b3b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $147
80106b3d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b42:	e9 bb f5 ff ff       	jmp    80106102 <alltraps>

80106b47 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $148
80106b49:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b4e:	e9 af f5 ff ff       	jmp    80106102 <alltraps>

80106b53 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $149
80106b55:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b5a:	e9 a3 f5 ff ff       	jmp    80106102 <alltraps>

80106b5f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $150
80106b61:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b66:	e9 97 f5 ff ff       	jmp    80106102 <alltraps>

80106b6b <vector151>:
.globl vector151
vector151:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $151
80106b6d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b72:	e9 8b f5 ff ff       	jmp    80106102 <alltraps>

80106b77 <vector152>:
.globl vector152
vector152:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $152
80106b79:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b7e:	e9 7f f5 ff ff       	jmp    80106102 <alltraps>

80106b83 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $153
80106b85:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b8a:	e9 73 f5 ff ff       	jmp    80106102 <alltraps>

80106b8f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $154
80106b91:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b96:	e9 67 f5 ff ff       	jmp    80106102 <alltraps>

80106b9b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $155
80106b9d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ba2:	e9 5b f5 ff ff       	jmp    80106102 <alltraps>

80106ba7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $156
80106ba9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bae:	e9 4f f5 ff ff       	jmp    80106102 <alltraps>

80106bb3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $157
80106bb5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bba:	e9 43 f5 ff ff       	jmp    80106102 <alltraps>

80106bbf <vector158>:
.globl vector158
vector158:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $158
80106bc1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bc6:	e9 37 f5 ff ff       	jmp    80106102 <alltraps>

80106bcb <vector159>:
.globl vector159
vector159:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $159
80106bcd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bd2:	e9 2b f5 ff ff       	jmp    80106102 <alltraps>

80106bd7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $160
80106bd9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106bde:	e9 1f f5 ff ff       	jmp    80106102 <alltraps>

80106be3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $161
80106be5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bea:	e9 13 f5 ff ff       	jmp    80106102 <alltraps>

80106bef <vector162>:
.globl vector162
vector162:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $162
80106bf1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106bf6:	e9 07 f5 ff ff       	jmp    80106102 <alltraps>

80106bfb <vector163>:
.globl vector163
vector163:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $163
80106bfd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c02:	e9 fb f4 ff ff       	jmp    80106102 <alltraps>

80106c07 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $164
80106c09:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c0e:	e9 ef f4 ff ff       	jmp    80106102 <alltraps>

80106c13 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $165
80106c15:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c1a:	e9 e3 f4 ff ff       	jmp    80106102 <alltraps>

80106c1f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $166
80106c21:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c26:	e9 d7 f4 ff ff       	jmp    80106102 <alltraps>

80106c2b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $167
80106c2d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c32:	e9 cb f4 ff ff       	jmp    80106102 <alltraps>

80106c37 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $168
80106c39:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c3e:	e9 bf f4 ff ff       	jmp    80106102 <alltraps>

80106c43 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $169
80106c45:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c4a:	e9 b3 f4 ff ff       	jmp    80106102 <alltraps>

80106c4f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $170
80106c51:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c56:	e9 a7 f4 ff ff       	jmp    80106102 <alltraps>

80106c5b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $171
80106c5d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c62:	e9 9b f4 ff ff       	jmp    80106102 <alltraps>

80106c67 <vector172>:
.globl vector172
vector172:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $172
80106c69:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c6e:	e9 8f f4 ff ff       	jmp    80106102 <alltraps>

80106c73 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $173
80106c75:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c7a:	e9 83 f4 ff ff       	jmp    80106102 <alltraps>

80106c7f <vector174>:
.globl vector174
vector174:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $174
80106c81:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c86:	e9 77 f4 ff ff       	jmp    80106102 <alltraps>

80106c8b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $175
80106c8d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c92:	e9 6b f4 ff ff       	jmp    80106102 <alltraps>

80106c97 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $176
80106c99:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c9e:	e9 5f f4 ff ff       	jmp    80106102 <alltraps>

80106ca3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $177
80106ca5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106caa:	e9 53 f4 ff ff       	jmp    80106102 <alltraps>

80106caf <vector178>:
.globl vector178
vector178:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $178
80106cb1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cb6:	e9 47 f4 ff ff       	jmp    80106102 <alltraps>

80106cbb <vector179>:
.globl vector179
vector179:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $179
80106cbd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106cc2:	e9 3b f4 ff ff       	jmp    80106102 <alltraps>

80106cc7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $180
80106cc9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cce:	e9 2f f4 ff ff       	jmp    80106102 <alltraps>

80106cd3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $181
80106cd5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cda:	e9 23 f4 ff ff       	jmp    80106102 <alltraps>

80106cdf <vector182>:
.globl vector182
vector182:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $182
80106ce1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ce6:	e9 17 f4 ff ff       	jmp    80106102 <alltraps>

80106ceb <vector183>:
.globl vector183
vector183:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $183
80106ced:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106cf2:	e9 0b f4 ff ff       	jmp    80106102 <alltraps>

80106cf7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $184
80106cf9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106cfe:	e9 ff f3 ff ff       	jmp    80106102 <alltraps>

80106d03 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $185
80106d05:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d0a:	e9 f3 f3 ff ff       	jmp    80106102 <alltraps>

80106d0f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $186
80106d11:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d16:	e9 e7 f3 ff ff       	jmp    80106102 <alltraps>

80106d1b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $187
80106d1d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d22:	e9 db f3 ff ff       	jmp    80106102 <alltraps>

80106d27 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $188
80106d29:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d2e:	e9 cf f3 ff ff       	jmp    80106102 <alltraps>

80106d33 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $189
80106d35:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d3a:	e9 c3 f3 ff ff       	jmp    80106102 <alltraps>

80106d3f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $190
80106d41:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d46:	e9 b7 f3 ff ff       	jmp    80106102 <alltraps>

80106d4b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $191
80106d4d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d52:	e9 ab f3 ff ff       	jmp    80106102 <alltraps>

80106d57 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $192
80106d59:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d5e:	e9 9f f3 ff ff       	jmp    80106102 <alltraps>

80106d63 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $193
80106d65:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d6a:	e9 93 f3 ff ff       	jmp    80106102 <alltraps>

80106d6f <vector194>:
.globl vector194
vector194:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $194
80106d71:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d76:	e9 87 f3 ff ff       	jmp    80106102 <alltraps>

80106d7b <vector195>:
.globl vector195
vector195:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $195
80106d7d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d82:	e9 7b f3 ff ff       	jmp    80106102 <alltraps>

80106d87 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $196
80106d89:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d8e:	e9 6f f3 ff ff       	jmp    80106102 <alltraps>

80106d93 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $197
80106d95:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d9a:	e9 63 f3 ff ff       	jmp    80106102 <alltraps>

80106d9f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $198
80106da1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106da6:	e9 57 f3 ff ff       	jmp    80106102 <alltraps>

80106dab <vector199>:
.globl vector199
vector199:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $199
80106dad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106db2:	e9 4b f3 ff ff       	jmp    80106102 <alltraps>

80106db7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $200
80106db9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106dbe:	e9 3f f3 ff ff       	jmp    80106102 <alltraps>

80106dc3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $201
80106dc5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dca:	e9 33 f3 ff ff       	jmp    80106102 <alltraps>

80106dcf <vector202>:
.globl vector202
vector202:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $202
80106dd1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106dd6:	e9 27 f3 ff ff       	jmp    80106102 <alltraps>

80106ddb <vector203>:
.globl vector203
vector203:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $203
80106ddd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106de2:	e9 1b f3 ff ff       	jmp    80106102 <alltraps>

80106de7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $204
80106de9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106dee:	e9 0f f3 ff ff       	jmp    80106102 <alltraps>

80106df3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $205
80106df5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106dfa:	e9 03 f3 ff ff       	jmp    80106102 <alltraps>

80106dff <vector206>:
.globl vector206
vector206:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $206
80106e01:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e06:	e9 f7 f2 ff ff       	jmp    80106102 <alltraps>

80106e0b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $207
80106e0d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e12:	e9 eb f2 ff ff       	jmp    80106102 <alltraps>

80106e17 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $208
80106e19:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e1e:	e9 df f2 ff ff       	jmp    80106102 <alltraps>

80106e23 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $209
80106e25:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e2a:	e9 d3 f2 ff ff       	jmp    80106102 <alltraps>

80106e2f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $210
80106e31:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e36:	e9 c7 f2 ff ff       	jmp    80106102 <alltraps>

80106e3b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $211
80106e3d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e42:	e9 bb f2 ff ff       	jmp    80106102 <alltraps>

80106e47 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $212
80106e49:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e4e:	e9 af f2 ff ff       	jmp    80106102 <alltraps>

80106e53 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $213
80106e55:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e5a:	e9 a3 f2 ff ff       	jmp    80106102 <alltraps>

80106e5f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $214
80106e61:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e66:	e9 97 f2 ff ff       	jmp    80106102 <alltraps>

80106e6b <vector215>:
.globl vector215
vector215:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $215
80106e6d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e72:	e9 8b f2 ff ff       	jmp    80106102 <alltraps>

80106e77 <vector216>:
.globl vector216
vector216:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $216
80106e79:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e7e:	e9 7f f2 ff ff       	jmp    80106102 <alltraps>

80106e83 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $217
80106e85:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e8a:	e9 73 f2 ff ff       	jmp    80106102 <alltraps>

80106e8f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $218
80106e91:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e96:	e9 67 f2 ff ff       	jmp    80106102 <alltraps>

80106e9b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $219
80106e9d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ea2:	e9 5b f2 ff ff       	jmp    80106102 <alltraps>

80106ea7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $220
80106ea9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106eae:	e9 4f f2 ff ff       	jmp    80106102 <alltraps>

80106eb3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $221
80106eb5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106eba:	e9 43 f2 ff ff       	jmp    80106102 <alltraps>

80106ebf <vector222>:
.globl vector222
vector222:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $222
80106ec1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ec6:	e9 37 f2 ff ff       	jmp    80106102 <alltraps>

80106ecb <vector223>:
.globl vector223
vector223:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $223
80106ecd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ed2:	e9 2b f2 ff ff       	jmp    80106102 <alltraps>

80106ed7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $224
80106ed9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ede:	e9 1f f2 ff ff       	jmp    80106102 <alltraps>

80106ee3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $225
80106ee5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106eea:	e9 13 f2 ff ff       	jmp    80106102 <alltraps>

80106eef <vector226>:
.globl vector226
vector226:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $226
80106ef1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ef6:	e9 07 f2 ff ff       	jmp    80106102 <alltraps>

80106efb <vector227>:
.globl vector227
vector227:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $227
80106efd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f02:	e9 fb f1 ff ff       	jmp    80106102 <alltraps>

80106f07 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $228
80106f09:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f0e:	e9 ef f1 ff ff       	jmp    80106102 <alltraps>

80106f13 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $229
80106f15:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f1a:	e9 e3 f1 ff ff       	jmp    80106102 <alltraps>

80106f1f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $230
80106f21:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f26:	e9 d7 f1 ff ff       	jmp    80106102 <alltraps>

80106f2b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $231
80106f2d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f32:	e9 cb f1 ff ff       	jmp    80106102 <alltraps>

80106f37 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $232
80106f39:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f3e:	e9 bf f1 ff ff       	jmp    80106102 <alltraps>

80106f43 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $233
80106f45:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f4a:	e9 b3 f1 ff ff       	jmp    80106102 <alltraps>

80106f4f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $234
80106f51:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f56:	e9 a7 f1 ff ff       	jmp    80106102 <alltraps>

80106f5b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $235
80106f5d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f62:	e9 9b f1 ff ff       	jmp    80106102 <alltraps>

80106f67 <vector236>:
.globl vector236
vector236:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $236
80106f69:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f6e:	e9 8f f1 ff ff       	jmp    80106102 <alltraps>

80106f73 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $237
80106f75:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f7a:	e9 83 f1 ff ff       	jmp    80106102 <alltraps>

80106f7f <vector238>:
.globl vector238
vector238:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $238
80106f81:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f86:	e9 77 f1 ff ff       	jmp    80106102 <alltraps>

80106f8b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $239
80106f8d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f92:	e9 6b f1 ff ff       	jmp    80106102 <alltraps>

80106f97 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $240
80106f99:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f9e:	e9 5f f1 ff ff       	jmp    80106102 <alltraps>

80106fa3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $241
80106fa5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106faa:	e9 53 f1 ff ff       	jmp    80106102 <alltraps>

80106faf <vector242>:
.globl vector242
vector242:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $242
80106fb1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106fb6:	e9 47 f1 ff ff       	jmp    80106102 <alltraps>

80106fbb <vector243>:
.globl vector243
vector243:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $243
80106fbd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fc2:	e9 3b f1 ff ff       	jmp    80106102 <alltraps>

80106fc7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $244
80106fc9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fce:	e9 2f f1 ff ff       	jmp    80106102 <alltraps>

80106fd3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $245
80106fd5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fda:	e9 23 f1 ff ff       	jmp    80106102 <alltraps>

80106fdf <vector246>:
.globl vector246
vector246:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $246
80106fe1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106fe6:	e9 17 f1 ff ff       	jmp    80106102 <alltraps>

80106feb <vector247>:
.globl vector247
vector247:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $247
80106fed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ff2:	e9 0b f1 ff ff       	jmp    80106102 <alltraps>

80106ff7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $248
80106ff9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106ffe:	e9 ff f0 ff ff       	jmp    80106102 <alltraps>

80107003 <vector249>:
.globl vector249
vector249:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $249
80107005:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010700a:	e9 f3 f0 ff ff       	jmp    80106102 <alltraps>

8010700f <vector250>:
.globl vector250
vector250:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $250
80107011:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107016:	e9 e7 f0 ff ff       	jmp    80106102 <alltraps>

8010701b <vector251>:
.globl vector251
vector251:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $251
8010701d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107022:	e9 db f0 ff ff       	jmp    80106102 <alltraps>

80107027 <vector252>:
.globl vector252
vector252:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $252
80107029:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010702e:	e9 cf f0 ff ff       	jmp    80106102 <alltraps>

80107033 <vector253>:
.globl vector253
vector253:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $253
80107035:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010703a:	e9 c3 f0 ff ff       	jmp    80106102 <alltraps>

8010703f <vector254>:
.globl vector254
vector254:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $254
80107041:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107046:	e9 b7 f0 ff ff       	jmp    80106102 <alltraps>

8010704b <vector255>:
.globl vector255
vector255:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $255
8010704d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107052:	e9 ab f0 ff ff       	jmp    80106102 <alltraps>
80107057:	66 90                	xchg   %ax,%ax
80107059:	66 90                	xchg   %ax,%ax
8010705b:	66 90                	xchg   %ax,%ax
8010705d:	66 90                	xchg   %ax,%ax
8010705f:	90                   	nop

80107060 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107066:	89 d3                	mov    %edx,%ebx
{
80107068:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010706a:	c1 eb 16             	shr    $0x16,%ebx
8010706d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107070:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107073:	8b 06                	mov    (%esi),%eax
80107075:	a8 01                	test   $0x1,%al
80107077:	74 27                	je     801070a0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107079:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010707e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107084:	c1 ef 0a             	shr    $0xa,%edi
}
80107087:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010708a:	89 fa                	mov    %edi,%edx
8010708c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107092:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107095:	5b                   	pop    %ebx
80107096:	5e                   	pop    %esi
80107097:	5f                   	pop    %edi
80107098:	5d                   	pop    %ebp
80107099:	c3                   	ret    
8010709a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801070a0:	85 c9                	test   %ecx,%ecx
801070a2:	74 2c                	je     801070d0 <walkpgdir+0x70>
801070a4:	e8 27 b4 ff ff       	call   801024d0 <kalloc>
801070a9:	85 c0                	test   %eax,%eax
801070ab:	89 c3                	mov    %eax,%ebx
801070ad:	74 21                	je     801070d0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801070af:	83 ec 04             	sub    $0x4,%esp
801070b2:	68 00 10 00 00       	push   $0x1000
801070b7:	6a 00                	push   $0x0
801070b9:	50                   	push   %eax
801070ba:	e8 11 dd ff ff       	call   80104dd0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070bf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070c5:	83 c4 10             	add    $0x10,%esp
801070c8:	83 c8 07             	or     $0x7,%eax
801070cb:	89 06                	mov    %eax,(%esi)
801070cd:	eb b5                	jmp    80107084 <walkpgdir+0x24>
801070cf:	90                   	nop
}
801070d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801070d3:	31 c0                	xor    %eax,%eax
}
801070d5:	5b                   	pop    %ebx
801070d6:	5e                   	pop    %esi
801070d7:	5f                   	pop    %edi
801070d8:	5d                   	pop    %ebp
801070d9:	c3                   	ret    
801070da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801070e6:	89 d3                	mov    %edx,%ebx
801070e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801070ee:	83 ec 1c             	sub    $0x1c,%esp
801070f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070f4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801070f8:	8b 7d 08             	mov    0x8(%ebp),%edi
801070fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107100:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107103:	8b 45 0c             	mov    0xc(%ebp),%eax
80107106:	29 df                	sub    %ebx,%edi
80107108:	83 c8 01             	or     $0x1,%eax
8010710b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010710e:	eb 15                	jmp    80107125 <mappages+0x45>
    if(*pte & PTE_P)
80107110:	f6 00 01             	testb  $0x1,(%eax)
80107113:	75 45                	jne    8010715a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107115:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107118:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010711b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010711d:	74 31                	je     80107150 <mappages+0x70>
      break;
    a += PGSIZE;
8010711f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107125:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107128:	b9 01 00 00 00       	mov    $0x1,%ecx
8010712d:	89 da                	mov    %ebx,%edx
8010712f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107132:	e8 29 ff ff ff       	call   80107060 <walkpgdir>
80107137:	85 c0                	test   %eax,%eax
80107139:	75 d5                	jne    80107110 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010713b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010713e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107143:	5b                   	pop    %ebx
80107144:	5e                   	pop    %esi
80107145:	5f                   	pop    %edi
80107146:	5d                   	pop    %ebp
80107147:	c3                   	ret    
80107148:	90                   	nop
80107149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107150:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107153:	31 c0                	xor    %eax,%eax
}
80107155:	5b                   	pop    %ebx
80107156:	5e                   	pop    %esi
80107157:	5f                   	pop    %edi
80107158:	5d                   	pop    %ebp
80107159:	c3                   	ret    
      panic("remap");
8010715a:	83 ec 0c             	sub    $0xc,%esp
8010715d:	68 60 84 10 80       	push   $0x80108460
80107162:	e8 29 92 ff ff       	call   80100390 <panic>
80107167:	89 f6                	mov    %esi,%esi
80107169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107170 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107176:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010717c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010717e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107184:	83 ec 1c             	sub    $0x1c,%esp
80107187:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010718a:	39 d3                	cmp    %edx,%ebx
8010718c:	73 66                	jae    801071f4 <deallocuvm.part.0+0x84>
8010718e:	89 d6                	mov    %edx,%esi
80107190:	eb 3d                	jmp    801071cf <deallocuvm.part.0+0x5f>
80107192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107198:	8b 10                	mov    (%eax),%edx
8010719a:	f6 c2 01             	test   $0x1,%dl
8010719d:	74 26                	je     801071c5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010719f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801071a5:	74 58                	je     801071ff <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801071a7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801071aa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801071b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801071b3:	52                   	push   %edx
801071b4:	e8 67 b1 ff ff       	call   80102320 <kfree>
      *pte = 0;
801071b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071bc:	83 c4 10             	add    $0x10,%esp
801071bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801071c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071cb:	39 f3                	cmp    %esi,%ebx
801071cd:	73 25                	jae    801071f4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801071cf:	31 c9                	xor    %ecx,%ecx
801071d1:	89 da                	mov    %ebx,%edx
801071d3:	89 f8                	mov    %edi,%eax
801071d5:	e8 86 fe ff ff       	call   80107060 <walkpgdir>
    if(!pte)
801071da:	85 c0                	test   %eax,%eax
801071dc:	75 ba                	jne    80107198 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801071de:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801071e4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801071ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071f0:	39 f3                	cmp    %esi,%ebx
801071f2:	72 db                	jb     801071cf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801071f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071fa:	5b                   	pop    %ebx
801071fb:	5e                   	pop    %esi
801071fc:	5f                   	pop    %edi
801071fd:	5d                   	pop    %ebp
801071fe:	c3                   	ret    
        panic("kfree");
801071ff:	83 ec 0c             	sub    $0xc,%esp
80107202:	68 06 7c 10 80       	push   $0x80107c06
80107207:	e8 84 91 ff ff       	call   80100390 <panic>
8010720c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107210 <seginit>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107216:	e8 b5 cb ff ff       	call   80103dd0 <cpuid>
8010721b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107221:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107226:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010722a:	c7 80 f8 41 11 80 ff 	movl   $0xffff,-0x7feebe08(%eax)
80107231:	ff 00 00 
80107234:	c7 80 fc 41 11 80 00 	movl   $0xcf9a00,-0x7feebe04(%eax)
8010723b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010723e:	c7 80 00 42 11 80 ff 	movl   $0xffff,-0x7feebe00(%eax)
80107245:	ff 00 00 
80107248:	c7 80 04 42 11 80 00 	movl   $0xcf9200,-0x7feebdfc(%eax)
8010724f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107252:	c7 80 08 42 11 80 ff 	movl   $0xffff,-0x7feebdf8(%eax)
80107259:	ff 00 00 
8010725c:	c7 80 0c 42 11 80 00 	movl   $0xcffa00,-0x7feebdf4(%eax)
80107263:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107266:	c7 80 10 42 11 80 ff 	movl   $0xffff,-0x7feebdf0(%eax)
8010726d:	ff 00 00 
80107270:	c7 80 14 42 11 80 00 	movl   $0xcff200,-0x7feebdec(%eax)
80107277:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010727a:	05 f0 41 11 80       	add    $0x801141f0,%eax
  pd[1] = (uint)p;
8010727f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107283:	c1 e8 10             	shr    $0x10,%eax
80107286:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010728a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010728d:	0f 01 10             	lgdtl  (%eax)
}
80107290:	c9                   	leave  
80107291:	c3                   	ret    
80107292:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072a0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072a0:	a1 a4 c0 11 80       	mov    0x8011c0a4,%eax
{
801072a5:	55                   	push   %ebp
801072a6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072a8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072ad:	0f 22 d8             	mov    %eax,%cr3
}
801072b0:	5d                   	pop    %ebp
801072b1:	c3                   	ret    
801072b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072c0 <switchuvm>:
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	57                   	push   %edi
801072c4:	56                   	push   %esi
801072c5:	53                   	push   %ebx
801072c6:	83 ec 1c             	sub    $0x1c,%esp
801072c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801072cc:	85 db                	test   %ebx,%ebx
801072ce:	0f 84 cb 00 00 00    	je     8010739f <switchuvm+0xdf>
  if(p->kstack == 0)
801072d4:	8b 43 08             	mov    0x8(%ebx),%eax
801072d7:	85 c0                	test   %eax,%eax
801072d9:	0f 84 da 00 00 00    	je     801073b9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801072df:	8b 43 04             	mov    0x4(%ebx),%eax
801072e2:	85 c0                	test   %eax,%eax
801072e4:	0f 84 c2 00 00 00    	je     801073ac <switchuvm+0xec>
  pushcli();
801072ea:	e8 01 d9 ff ff       	call   80104bf0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072ef:	e8 5c ca ff ff       	call   80103d50 <mycpu>
801072f4:	89 c6                	mov    %eax,%esi
801072f6:	e8 55 ca ff ff       	call   80103d50 <mycpu>
801072fb:	89 c7                	mov    %eax,%edi
801072fd:	e8 4e ca ff ff       	call   80103d50 <mycpu>
80107302:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107305:	83 c7 08             	add    $0x8,%edi
80107308:	e8 43 ca ff ff       	call   80103d50 <mycpu>
8010730d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107310:	83 c0 08             	add    $0x8,%eax
80107313:	ba 67 00 00 00       	mov    $0x67,%edx
80107318:	c1 e8 18             	shr    $0x18,%eax
8010731b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107322:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107329:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010732f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107334:	83 c1 08             	add    $0x8,%ecx
80107337:	c1 e9 10             	shr    $0x10,%ecx
8010733a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107340:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107345:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010734c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107351:	e8 fa c9 ff ff       	call   80103d50 <mycpu>
80107356:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010735d:	e8 ee c9 ff ff       	call   80103d50 <mycpu>
80107362:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107366:	8b 73 08             	mov    0x8(%ebx),%esi
80107369:	e8 e2 c9 ff ff       	call   80103d50 <mycpu>
8010736e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107374:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107377:	e8 d4 c9 ff ff       	call   80103d50 <mycpu>
8010737c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107380:	b8 28 00 00 00       	mov    $0x28,%eax
80107385:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107388:	8b 43 04             	mov    0x4(%ebx),%eax
8010738b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107390:	0f 22 d8             	mov    %eax,%cr3
}
80107393:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107396:	5b                   	pop    %ebx
80107397:	5e                   	pop    %esi
80107398:	5f                   	pop    %edi
80107399:	5d                   	pop    %ebp
  popcli();
8010739a:	e9 91 d8 ff ff       	jmp    80104c30 <popcli>
    panic("switchuvm: no process");
8010739f:	83 ec 0c             	sub    $0xc,%esp
801073a2:	68 66 84 10 80       	push   $0x80108466
801073a7:	e8 e4 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801073ac:	83 ec 0c             	sub    $0xc,%esp
801073af:	68 91 84 10 80       	push   $0x80108491
801073b4:	e8 d7 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801073b9:	83 ec 0c             	sub    $0xc,%esp
801073bc:	68 7c 84 10 80       	push   $0x8010847c
801073c1:	e8 ca 8f ff ff       	call   80100390 <panic>
801073c6:	8d 76 00             	lea    0x0(%esi),%esi
801073c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073d0 <inituvm>:
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	57                   	push   %edi
801073d4:	56                   	push   %esi
801073d5:	53                   	push   %ebx
801073d6:	83 ec 1c             	sub    $0x1c,%esp
801073d9:	8b 75 10             	mov    0x10(%ebp),%esi
801073dc:	8b 45 08             	mov    0x8(%ebp),%eax
801073df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801073e2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801073e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801073eb:	77 49                	ja     80107436 <inituvm+0x66>
  mem = kalloc();
801073ed:	e8 de b0 ff ff       	call   801024d0 <kalloc>
  memset(mem, 0, PGSIZE);
801073f2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801073f5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801073f7:	68 00 10 00 00       	push   $0x1000
801073fc:	6a 00                	push   $0x0
801073fe:	50                   	push   %eax
801073ff:	e8 cc d9 ff ff       	call   80104dd0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107404:	58                   	pop    %eax
80107405:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010740b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107410:	5a                   	pop    %edx
80107411:	6a 06                	push   $0x6
80107413:	50                   	push   %eax
80107414:	31 d2                	xor    %edx,%edx
80107416:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107419:	e8 c2 fc ff ff       	call   801070e0 <mappages>
  memmove(mem, init, sz);
8010741e:	89 75 10             	mov    %esi,0x10(%ebp)
80107421:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107424:	83 c4 10             	add    $0x10,%esp
80107427:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010742a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010742d:	5b                   	pop    %ebx
8010742e:	5e                   	pop    %esi
8010742f:	5f                   	pop    %edi
80107430:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107431:	e9 4a da ff ff       	jmp    80104e80 <memmove>
    panic("inituvm: more than a page");
80107436:	83 ec 0c             	sub    $0xc,%esp
80107439:	68 a5 84 10 80       	push   $0x801084a5
8010743e:	e8 4d 8f ff ff       	call   80100390 <panic>
80107443:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107450 <loaduvm>:
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	57                   	push   %edi
80107454:	56                   	push   %esi
80107455:	53                   	push   %ebx
80107456:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107459:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107460:	0f 85 91 00 00 00    	jne    801074f7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107466:	8b 75 18             	mov    0x18(%ebp),%esi
80107469:	31 db                	xor    %ebx,%ebx
8010746b:	85 f6                	test   %esi,%esi
8010746d:	75 1a                	jne    80107489 <loaduvm+0x39>
8010746f:	eb 6f                	jmp    801074e0 <loaduvm+0x90>
80107471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107478:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010747e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107484:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107487:	76 57                	jbe    801074e0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107489:	8b 55 0c             	mov    0xc(%ebp),%edx
8010748c:	8b 45 08             	mov    0x8(%ebp),%eax
8010748f:	31 c9                	xor    %ecx,%ecx
80107491:	01 da                	add    %ebx,%edx
80107493:	e8 c8 fb ff ff       	call   80107060 <walkpgdir>
80107498:	85 c0                	test   %eax,%eax
8010749a:	74 4e                	je     801074ea <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010749c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010749e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801074a1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801074a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801074ab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801074b1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074b4:	01 d9                	add    %ebx,%ecx
801074b6:	05 00 00 00 80       	add    $0x80000000,%eax
801074bb:	57                   	push   %edi
801074bc:	51                   	push   %ecx
801074bd:	50                   	push   %eax
801074be:	ff 75 10             	pushl  0x10(%ebp)
801074c1:	e8 aa a4 ff ff       	call   80101970 <readi>
801074c6:	83 c4 10             	add    $0x10,%esp
801074c9:	39 f8                	cmp    %edi,%eax
801074cb:	74 ab                	je     80107478 <loaduvm+0x28>
}
801074cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074d5:	5b                   	pop    %ebx
801074d6:	5e                   	pop    %esi
801074d7:	5f                   	pop    %edi
801074d8:	5d                   	pop    %ebp
801074d9:	c3                   	ret    
801074da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074e3:	31 c0                	xor    %eax,%eax
}
801074e5:	5b                   	pop    %ebx
801074e6:	5e                   	pop    %esi
801074e7:	5f                   	pop    %edi
801074e8:	5d                   	pop    %ebp
801074e9:	c3                   	ret    
      panic("loaduvm: address should exist");
801074ea:	83 ec 0c             	sub    $0xc,%esp
801074ed:	68 bf 84 10 80       	push   $0x801084bf
801074f2:	e8 99 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801074f7:	83 ec 0c             	sub    $0xc,%esp
801074fa:	68 60 85 10 80       	push   $0x80108560
801074ff:	e8 8c 8e ff ff       	call   80100390 <panic>
80107504:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010750a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107510 <allocuvm>:
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	57                   	push   %edi
80107514:	56                   	push   %esi
80107515:	53                   	push   %ebx
80107516:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107519:	8b 7d 10             	mov    0x10(%ebp),%edi
8010751c:	85 ff                	test   %edi,%edi
8010751e:	0f 88 8e 00 00 00    	js     801075b2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107524:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107527:	0f 82 93 00 00 00    	jb     801075c0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010752d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107530:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107536:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010753c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010753f:	0f 86 7e 00 00 00    	jbe    801075c3 <allocuvm+0xb3>
80107545:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107548:	8b 7d 08             	mov    0x8(%ebp),%edi
8010754b:	eb 42                	jmp    8010758f <allocuvm+0x7f>
8010754d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107550:	83 ec 04             	sub    $0x4,%esp
80107553:	68 00 10 00 00       	push   $0x1000
80107558:	6a 00                	push   $0x0
8010755a:	50                   	push   %eax
8010755b:	e8 70 d8 ff ff       	call   80104dd0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107560:	58                   	pop    %eax
80107561:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107567:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010756c:	5a                   	pop    %edx
8010756d:	6a 06                	push   $0x6
8010756f:	50                   	push   %eax
80107570:	89 da                	mov    %ebx,%edx
80107572:	89 f8                	mov    %edi,%eax
80107574:	e8 67 fb ff ff       	call   801070e0 <mappages>
80107579:	83 c4 10             	add    $0x10,%esp
8010757c:	85 c0                	test   %eax,%eax
8010757e:	78 50                	js     801075d0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107580:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107586:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107589:	0f 86 81 00 00 00    	jbe    80107610 <allocuvm+0x100>
    mem = kalloc();
8010758f:	e8 3c af ff ff       	call   801024d0 <kalloc>
    if(mem == 0){
80107594:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107596:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107598:	75 b6                	jne    80107550 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010759a:	83 ec 0c             	sub    $0xc,%esp
8010759d:	68 dd 84 10 80       	push   $0x801084dd
801075a2:	e8 b9 90 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801075a7:	83 c4 10             	add    $0x10,%esp
801075aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801075ad:	39 45 10             	cmp    %eax,0x10(%ebp)
801075b0:	77 6e                	ja     80107620 <allocuvm+0x110>
}
801075b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801075b5:	31 ff                	xor    %edi,%edi
}
801075b7:	89 f8                	mov    %edi,%eax
801075b9:	5b                   	pop    %ebx
801075ba:	5e                   	pop    %esi
801075bb:	5f                   	pop    %edi
801075bc:	5d                   	pop    %ebp
801075bd:	c3                   	ret    
801075be:	66 90                	xchg   %ax,%ax
    return oldsz;
801075c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801075c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075c6:	89 f8                	mov    %edi,%eax
801075c8:	5b                   	pop    %ebx
801075c9:	5e                   	pop    %esi
801075ca:	5f                   	pop    %edi
801075cb:	5d                   	pop    %ebp
801075cc:	c3                   	ret    
801075cd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801075d0:	83 ec 0c             	sub    $0xc,%esp
801075d3:	68 f5 84 10 80       	push   $0x801084f5
801075d8:	e8 83 90 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801075dd:	83 c4 10             	add    $0x10,%esp
801075e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801075e3:	39 45 10             	cmp    %eax,0x10(%ebp)
801075e6:	76 0d                	jbe    801075f5 <allocuvm+0xe5>
801075e8:	89 c1                	mov    %eax,%ecx
801075ea:	8b 55 10             	mov    0x10(%ebp),%edx
801075ed:	8b 45 08             	mov    0x8(%ebp),%eax
801075f0:	e8 7b fb ff ff       	call   80107170 <deallocuvm.part.0>
      kfree(mem);
801075f5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801075f8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801075fa:	56                   	push   %esi
801075fb:	e8 20 ad ff ff       	call   80102320 <kfree>
      return 0;
80107600:	83 c4 10             	add    $0x10,%esp
}
80107603:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107606:	89 f8                	mov    %edi,%eax
80107608:	5b                   	pop    %ebx
80107609:	5e                   	pop    %esi
8010760a:	5f                   	pop    %edi
8010760b:	5d                   	pop    %ebp
8010760c:	c3                   	ret    
8010760d:	8d 76 00             	lea    0x0(%esi),%esi
80107610:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107613:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107616:	5b                   	pop    %ebx
80107617:	89 f8                	mov    %edi,%eax
80107619:	5e                   	pop    %esi
8010761a:	5f                   	pop    %edi
8010761b:	5d                   	pop    %ebp
8010761c:	c3                   	ret    
8010761d:	8d 76 00             	lea    0x0(%esi),%esi
80107620:	89 c1                	mov    %eax,%ecx
80107622:	8b 55 10             	mov    0x10(%ebp),%edx
80107625:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107628:	31 ff                	xor    %edi,%edi
8010762a:	e8 41 fb ff ff       	call   80107170 <deallocuvm.part.0>
8010762f:	eb 92                	jmp    801075c3 <allocuvm+0xb3>
80107631:	eb 0d                	jmp    80107640 <deallocuvm>
80107633:	90                   	nop
80107634:	90                   	nop
80107635:	90                   	nop
80107636:	90                   	nop
80107637:	90                   	nop
80107638:	90                   	nop
80107639:	90                   	nop
8010763a:	90                   	nop
8010763b:	90                   	nop
8010763c:	90                   	nop
8010763d:	90                   	nop
8010763e:	90                   	nop
8010763f:	90                   	nop

80107640 <deallocuvm>:
{
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	8b 55 0c             	mov    0xc(%ebp),%edx
80107646:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107649:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010764c:	39 d1                	cmp    %edx,%ecx
8010764e:	73 10                	jae    80107660 <deallocuvm+0x20>
}
80107650:	5d                   	pop    %ebp
80107651:	e9 1a fb ff ff       	jmp    80107170 <deallocuvm.part.0>
80107656:	8d 76 00             	lea    0x0(%esi),%esi
80107659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107660:	89 d0                	mov    %edx,%eax
80107662:	5d                   	pop    %ebp
80107663:	c3                   	ret    
80107664:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010766a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107670 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107670:	55                   	push   %ebp
80107671:	89 e5                	mov    %esp,%ebp
80107673:	57                   	push   %edi
80107674:	56                   	push   %esi
80107675:	53                   	push   %ebx
80107676:	83 ec 0c             	sub    $0xc,%esp
80107679:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010767c:	85 f6                	test   %esi,%esi
8010767e:	74 59                	je     801076d9 <freevm+0x69>
80107680:	31 c9                	xor    %ecx,%ecx
80107682:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107687:	89 f0                	mov    %esi,%eax
80107689:	e8 e2 fa ff ff       	call   80107170 <deallocuvm.part.0>
8010768e:	89 f3                	mov    %esi,%ebx
80107690:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107696:	eb 0f                	jmp    801076a7 <freevm+0x37>
80107698:	90                   	nop
80107699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076a0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801076a3:	39 fb                	cmp    %edi,%ebx
801076a5:	74 23                	je     801076ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801076a7:	8b 03                	mov    (%ebx),%eax
801076a9:	a8 01                	test   $0x1,%al
801076ab:	74 f3                	je     801076a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801076b2:	83 ec 0c             	sub    $0xc,%esp
801076b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801076bd:	50                   	push   %eax
801076be:	e8 5d ac ff ff       	call   80102320 <kfree>
801076c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076c6:	39 fb                	cmp    %edi,%ebx
801076c8:	75 dd                	jne    801076a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801076ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801076cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d0:	5b                   	pop    %ebx
801076d1:	5e                   	pop    %esi
801076d2:	5f                   	pop    %edi
801076d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801076d4:	e9 47 ac ff ff       	jmp    80102320 <kfree>
    panic("freevm: no pgdir");
801076d9:	83 ec 0c             	sub    $0xc,%esp
801076dc:	68 11 85 10 80       	push   $0x80108511
801076e1:	e8 aa 8c ff ff       	call   80100390 <panic>
801076e6:	8d 76 00             	lea    0x0(%esi),%esi
801076e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076f0 <setupkvm>:
{
801076f0:	55                   	push   %ebp
801076f1:	89 e5                	mov    %esp,%ebp
801076f3:	56                   	push   %esi
801076f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801076f5:	e8 d6 ad ff ff       	call   801024d0 <kalloc>
801076fa:	85 c0                	test   %eax,%eax
801076fc:	89 c6                	mov    %eax,%esi
801076fe:	74 42                	je     80107742 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107700:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107703:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107708:	68 00 10 00 00       	push   $0x1000
8010770d:	6a 00                	push   $0x0
8010770f:	50                   	push   %eax
80107710:	e8 bb d6 ff ff       	call   80104dd0 <memset>
80107715:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107718:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010771b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010771e:	83 ec 08             	sub    $0x8,%esp
80107721:	8b 13                	mov    (%ebx),%edx
80107723:	ff 73 0c             	pushl  0xc(%ebx)
80107726:	50                   	push   %eax
80107727:	29 c1                	sub    %eax,%ecx
80107729:	89 f0                	mov    %esi,%eax
8010772b:	e8 b0 f9 ff ff       	call   801070e0 <mappages>
80107730:	83 c4 10             	add    $0x10,%esp
80107733:	85 c0                	test   %eax,%eax
80107735:	78 19                	js     80107750 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107737:	83 c3 10             	add    $0x10,%ebx
8010773a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107740:	75 d6                	jne    80107718 <setupkvm+0x28>
}
80107742:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107745:	89 f0                	mov    %esi,%eax
80107747:	5b                   	pop    %ebx
80107748:	5e                   	pop    %esi
80107749:	5d                   	pop    %ebp
8010774a:	c3                   	ret    
8010774b:	90                   	nop
8010774c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107750:	83 ec 0c             	sub    $0xc,%esp
80107753:	56                   	push   %esi
      return 0;
80107754:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107756:	e8 15 ff ff ff       	call   80107670 <freevm>
      return 0;
8010775b:	83 c4 10             	add    $0x10,%esp
}
8010775e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107761:	89 f0                	mov    %esi,%eax
80107763:	5b                   	pop    %ebx
80107764:	5e                   	pop    %esi
80107765:	5d                   	pop    %ebp
80107766:	c3                   	ret    
80107767:	89 f6                	mov    %esi,%esi
80107769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107770 <kvmalloc>:
{
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107776:	e8 75 ff ff ff       	call   801076f0 <setupkvm>
8010777b:	a3 a4 c0 11 80       	mov    %eax,0x8011c0a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107780:	05 00 00 00 80       	add    $0x80000000,%eax
80107785:	0f 22 d8             	mov    %eax,%cr3
}
80107788:	c9                   	leave  
80107789:	c3                   	ret    
8010778a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107790 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107790:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107791:	31 c9                	xor    %ecx,%ecx
{
80107793:	89 e5                	mov    %esp,%ebp
80107795:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107798:	8b 55 0c             	mov    0xc(%ebp),%edx
8010779b:	8b 45 08             	mov    0x8(%ebp),%eax
8010779e:	e8 bd f8 ff ff       	call   80107060 <walkpgdir>
  if(pte == 0)
801077a3:	85 c0                	test   %eax,%eax
801077a5:	74 05                	je     801077ac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801077a7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801077aa:	c9                   	leave  
801077ab:	c3                   	ret    
    panic("clearpteu");
801077ac:	83 ec 0c             	sub    $0xc,%esp
801077af:	68 22 85 10 80       	push   $0x80108522
801077b4:	e8 d7 8b ff ff       	call   80100390 <panic>
801077b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801077c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
801077c3:	57                   	push   %edi
801077c4:	56                   	push   %esi
801077c5:	53                   	push   %ebx
801077c6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801077c9:	e8 22 ff ff ff       	call   801076f0 <setupkvm>
801077ce:	85 c0                	test   %eax,%eax
801077d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077d3:	0f 84 9f 00 00 00    	je     80107878 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801077dc:	85 c9                	test   %ecx,%ecx
801077de:	0f 84 94 00 00 00    	je     80107878 <copyuvm+0xb8>
801077e4:	31 ff                	xor    %edi,%edi
801077e6:	eb 4a                	jmp    80107832 <copyuvm+0x72>
801077e8:	90                   	nop
801077e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801077f0:	83 ec 04             	sub    $0x4,%esp
801077f3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801077f9:	68 00 10 00 00       	push   $0x1000
801077fe:	53                   	push   %ebx
801077ff:	50                   	push   %eax
80107800:	e8 7b d6 ff ff       	call   80104e80 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107805:	58                   	pop    %eax
80107806:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010780c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107811:	5a                   	pop    %edx
80107812:	ff 75 e4             	pushl  -0x1c(%ebp)
80107815:	50                   	push   %eax
80107816:	89 fa                	mov    %edi,%edx
80107818:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010781b:	e8 c0 f8 ff ff       	call   801070e0 <mappages>
80107820:	83 c4 10             	add    $0x10,%esp
80107823:	85 c0                	test   %eax,%eax
80107825:	78 61                	js     80107888 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107827:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010782d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107830:	76 46                	jbe    80107878 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107832:	8b 45 08             	mov    0x8(%ebp),%eax
80107835:	31 c9                	xor    %ecx,%ecx
80107837:	89 fa                	mov    %edi,%edx
80107839:	e8 22 f8 ff ff       	call   80107060 <walkpgdir>
8010783e:	85 c0                	test   %eax,%eax
80107840:	74 61                	je     801078a3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107842:	8b 00                	mov    (%eax),%eax
80107844:	a8 01                	test   $0x1,%al
80107846:	74 4e                	je     80107896 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107848:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010784a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010784f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107855:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107858:	e8 73 ac ff ff       	call   801024d0 <kalloc>
8010785d:	85 c0                	test   %eax,%eax
8010785f:	89 c6                	mov    %eax,%esi
80107861:	75 8d                	jne    801077f0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107863:	83 ec 0c             	sub    $0xc,%esp
80107866:	ff 75 e0             	pushl  -0x20(%ebp)
80107869:	e8 02 fe ff ff       	call   80107670 <freevm>
  return 0;
8010786e:	83 c4 10             	add    $0x10,%esp
80107871:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107878:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010787b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010787e:	5b                   	pop    %ebx
8010787f:	5e                   	pop    %esi
80107880:	5f                   	pop    %edi
80107881:	5d                   	pop    %ebp
80107882:	c3                   	ret    
80107883:	90                   	nop
80107884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107888:	83 ec 0c             	sub    $0xc,%esp
8010788b:	56                   	push   %esi
8010788c:	e8 8f aa ff ff       	call   80102320 <kfree>
      goto bad;
80107891:	83 c4 10             	add    $0x10,%esp
80107894:	eb cd                	jmp    80107863 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107896:	83 ec 0c             	sub    $0xc,%esp
80107899:	68 46 85 10 80       	push   $0x80108546
8010789e:	e8 ed 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801078a3:	83 ec 0c             	sub    $0xc,%esp
801078a6:	68 2c 85 10 80       	push   $0x8010852c
801078ab:	e8 e0 8a ff ff       	call   80100390 <panic>

801078b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078b0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078b1:	31 c9                	xor    %ecx,%ecx
{
801078b3:	89 e5                	mov    %esp,%ebp
801078b5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801078b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801078bb:	8b 45 08             	mov    0x8(%ebp),%eax
801078be:	e8 9d f7 ff ff       	call   80107060 <walkpgdir>
  if((*pte & PTE_P) == 0)
801078c3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801078c5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801078c6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801078cd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078d0:	05 00 00 00 80       	add    $0x80000000,%eax
801078d5:	83 fa 05             	cmp    $0x5,%edx
801078d8:	ba 00 00 00 00       	mov    $0x0,%edx
801078dd:	0f 45 c2             	cmovne %edx,%eax
}
801078e0:	c3                   	ret    
801078e1:	eb 0d                	jmp    801078f0 <copyout>
801078e3:	90                   	nop
801078e4:	90                   	nop
801078e5:	90                   	nop
801078e6:	90                   	nop
801078e7:	90                   	nop
801078e8:	90                   	nop
801078e9:	90                   	nop
801078ea:	90                   	nop
801078eb:	90                   	nop
801078ec:	90                   	nop
801078ed:	90                   	nop
801078ee:	90                   	nop
801078ef:	90                   	nop

801078f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801078f0:	55                   	push   %ebp
801078f1:	89 e5                	mov    %esp,%ebp
801078f3:	57                   	push   %edi
801078f4:	56                   	push   %esi
801078f5:	53                   	push   %ebx
801078f6:	83 ec 1c             	sub    $0x1c,%esp
801078f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801078fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801078ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107902:	85 db                	test   %ebx,%ebx
80107904:	75 40                	jne    80107946 <copyout+0x56>
80107906:	eb 70                	jmp    80107978 <copyout+0x88>
80107908:	90                   	nop
80107909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107913:	89 f1                	mov    %esi,%ecx
80107915:	29 d1                	sub    %edx,%ecx
80107917:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010791d:	39 d9                	cmp    %ebx,%ecx
8010791f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107922:	29 f2                	sub    %esi,%edx
80107924:	83 ec 04             	sub    $0x4,%esp
80107927:	01 d0                	add    %edx,%eax
80107929:	51                   	push   %ecx
8010792a:	57                   	push   %edi
8010792b:	50                   	push   %eax
8010792c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010792f:	e8 4c d5 ff ff       	call   80104e80 <memmove>
    len -= n;
    buf += n;
80107934:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107937:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010793a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107940:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107942:	29 cb                	sub    %ecx,%ebx
80107944:	74 32                	je     80107978 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107946:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107948:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010794b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010794e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107954:	56                   	push   %esi
80107955:	ff 75 08             	pushl  0x8(%ebp)
80107958:	e8 53 ff ff ff       	call   801078b0 <uva2ka>
    if(pa0 == 0)
8010795d:	83 c4 10             	add    $0x10,%esp
80107960:	85 c0                	test   %eax,%eax
80107962:	75 ac                	jne    80107910 <copyout+0x20>
  }
  return 0;
}
80107964:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107967:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010796c:	5b                   	pop    %ebx
8010796d:	5e                   	pop    %esi
8010796e:	5f                   	pop    %edi
8010796f:	5d                   	pop    %ebp
80107970:	c3                   	ret    
80107971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107978:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010797b:	31 c0                	xor    %eax,%eax
}
8010797d:	5b                   	pop    %ebx
8010797e:	5e                   	pop    %esi
8010797f:	5f                   	pop    %edi
80107980:	5d                   	pop    %ebp
80107981:	c3                   	ret    
