
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 2e 10 80       	mov    $0x80102e40,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 80 70 10 80       	push   $0x80107080
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 25 41 00 00       	call   80104180 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 70 10 80       	push   $0x80107087
80100097:	50                   	push   %eax
80100098:	e8 d3 3f 00 00       	call   80104070 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
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
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 97 41 00 00       	call   80104280 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 39 42 00 00       	call   801043a0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 3f 00 00       	call   801040b0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 4d 1f 00 00       	call   801020d0 <iderw>
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
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 8e 70 10 80       	push   $0x8010708e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

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
801001ae:	e8 9d 3f 00 00       	call   80104150 <holdingsleep>
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
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 07 1f 00 00       	jmp    801020d0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 70 10 80       	push   $0x8010709f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
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
801001ef:	e8 5c 3f 00 00       	call   80104150 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 0c 3f 00 00       	call   80104110 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 70 40 00 00       	call   80104280 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
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
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 3f 41 00 00       	jmp    801043a0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 70 10 80       	push   $0x801070a6
80100269:	e8 02 01 00 00       	call   80100370 <panic>
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
80100280:	e8 ab 14 00 00       	call   80101730 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 ef 3f 00 00       	call   80104280 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 a0 ff 10 80       	push   $0x8010ffa0
801002bd:	e8 4e 3a 00 00       	call   80103d10 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 89 34 00 00       	call   80103760 <myproc>
801002d7:	8b 40 28             	mov    0x28(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 b5 40 00 00       	call   801043a0 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 5d 13 00 00       	call   80101650 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 55 40 00 00       	call   801043a0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 fd 12 00 00       	call   80101650 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 42 23 00 00       	call   801026d0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 ad 70 10 80       	push   $0x801070ad
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 47 7a 10 80 	movl   $0x80107a47,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 e3 3d 00 00       	call   801041a0 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 c1 70 10 80       	push   $0x801070c1
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 11 57 00 00       	call   80105b30 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 58 56 00 00       	call   80105b30 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 4c 56 00 00       	call   80105b30 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 40 56 00 00       	call   80105b30 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 87 3f 00 00       	call   801044a0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 c2 3e 00 00       	call   801043f0 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 c5 70 10 80       	push   $0x801070c5
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 f0 70 10 80 	movzbl -0x7fef8f10(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 1c 11 00 00       	call   80101730 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 60 3c 00 00       	call   80104280 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 54 3d 00 00       	call   801043a0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 fb 0f 00 00       	call   80101650 <ilock>

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
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 8e 3c 00 00       	call   801043a0 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 d8 70 10 80       	mov    $0x801070d8,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 b3 3a 00 00       	call   80104280 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 df 70 10 80       	push   $0x801070df
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 78 3a 00 00       	call   80104280 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100836:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 33 3b 00 00       	call   801043a0 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008f1:	68 a0 ff 10 80       	push   $0x8010ffa0
801008f6:	e8 c5 35 00 00       	call   80103ec0 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010090d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100934:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 34 36 00 00       	jmp    80103fb0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 e8 70 10 80       	push   $0x801070e8
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 cb 37 00 00       	call   80104180 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 a2 18 00 00       	call   80102280 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 5f 2d 00 00       	call   80103760 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 24 21 00 00       	call   80102b30 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 89 14 00 00       	call   80101ea0 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 16 02 00 00    	je     80100c38 <exec+0x248>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 23 0c 00 00       	call   80101650 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 f2 0e 00 00       	call   80101930 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 91 0e 00 00       	call   801018e0 <iunlockput>
    end_op();
80100a4f:	e8 4c 21 00 00       	call   80102ba0 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 47 62 00 00       	call   80106cc0 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 63 0e 00 00       	call   80101930 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 07 60 00 00       	call   80106b10 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 11 5f 00 00       	call   80106a50 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 e2 60 00 00       	call   80106c40 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 71 0d 00 00       	call   801018e0 <iunlockput>
  end_op();
80100b6f:	e8 2c 20 00 00       	call   80102ba0 <end_op>
  ip = 0;

  sz = PGROUNDUP(sz);

  uint ustackbase = KERNBASE - 4; //cs153_lab3: the base of the user stack located a word below KERNBASE
  sp = allocuvm(pgdir, ustackbase - PGSIZE, ustackbase); //cs153_lab3: allocate a page of user virtual memory starting from ustackbase - PGSIZE to ustackbase and set sp (stack pointer) to ustackbase
80100b74:	83 c4 0c             	add    $0xc,%esp
80100b77:	68 fc ff ff 7f       	push   $0x7ffffffc
80100b7c:	68 fc ef ff 7f       	push   $0x7fffeffc
80100b81:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b87:	e8 84 5f 00 00       	call   80106b10 <allocuvm>
  if (!sp) //cs153_lab3: if sp allocuvm return 0 (error)
80100b8c:	83 c4 10             	add    $0x10,%esp
80100b8f:	85 c0                	test   %eax,%eax
  ip = 0;

  sz = PGROUNDUP(sz);

  uint ustackbase = KERNBASE - 4; //cs153_lab3: the base of the user stack located a word below KERNBASE
  sp = allocuvm(pgdir, ustackbase - PGSIZE, ustackbase); //cs153_lab3: allocate a page of user virtual memory starting from ustackbase - PGSIZE to ustackbase and set sp (stack pointer) to ustackbase
80100b91:	89 c3                	mov    %eax,%ebx
  if (!sp) //cs153_lab3: if sp allocuvm return 0 (error)
80100b93:	0f 84 84 00 00 00    	je     80100c1d <exec+0x22d>
    goto bad;

  curproc->userStack_numPages = 1; //cs153_lab3: only allocated a single page for the user stack to grow in
80100b99:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;
*/

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b9f:	31 f6                	xor    %esi,%esi
80100ba1:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  uint ustackbase = KERNBASE - 4; //cs153_lab3: the base of the user stack located a word below KERNBASE
  sp = allocuvm(pgdir, ustackbase - PGSIZE, ustackbase); //cs153_lab3: allocate a page of user virtual memory starting from ustackbase - PGSIZE to ustackbase and set sp (stack pointer) to ustackbase
  if (!sp) //cs153_lab3: if sp allocuvm return 0 (error)
    goto bad;

  curproc->userStack_numPages = 1; //cs153_lab3: only allocated a single page for the user stack to grow in
80100ba7:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;
*/

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bae:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bb1:	8b 00                	mov    (%eax),%eax
80100bb3:	85 c0                	test   %eax,%eax
80100bb5:	0f 84 9c 00 00 00    	je     80100c57 <exec+0x267>
80100bbb:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100bc1:	eb 24                	jmp    80100be7 <exec+0x1f7>
80100bc3:	90                   	nop
80100bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100bcb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;
*/

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bd2:	83 c6 01             	add    $0x1,%esi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100bd5:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;
*/

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bdb:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100bde:	85 c0                	test   %eax,%eax
80100be0:	74 75                	je     80100c57 <exec+0x267>
    if(argc >= MAXARG)
80100be2:	83 fe 20             	cmp    $0x20,%esi
80100be5:	74 36                	je     80100c1d <exec+0x22d>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100be7:	83 ec 0c             	sub    $0xc,%esp
80100bea:	50                   	push   %eax
80100beb:	e8 40 3a 00 00       	call   80104630 <strlen>
80100bf0:	f7 d0                	not    %eax
80100bf2:	01 d8                	add    %ebx,%eax
80100bf4:	83 e0 fc             	and    $0xfffffffc,%eax
80100bf7:	89 c3                	mov    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bf9:	58                   	pop    %eax
80100bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bfd:	ff 34 b0             	pushl  (%eax,%esi,4)
80100c00:	e8 2b 3a 00 00       	call   80104630 <strlen>
80100c05:	83 c0 01             	add    $0x1,%eax
80100c08:	50                   	push   %eax
80100c09:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0c:	ff 34 b0             	pushl  (%eax,%esi,4)
80100c0f:	53                   	push   %ebx
80100c10:	57                   	push   %edi
80100c11:	e8 4a 63 00 00       	call   80106f60 <copyout>
80100c16:	83 c4 20             	add    $0x20,%esp
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	79 ab                	jns    80100bc8 <exec+0x1d8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c1d:	83 ec 0c             	sub    $0xc,%esp
80100c20:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c26:	e8 15 60 00 00       	call   80106c40 <freevm>
80100c2b:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100c2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c33:	e9 24 fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100c38:	e8 63 1f 00 00       	call   80102ba0 <end_op>
    cprintf("exec: fail\n");
80100c3d:	83 ec 0c             	sub    $0xc,%esp
80100c40:	68 01 71 10 80       	push   $0x80107101
80100c45:	e8 16 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100c4a:	83 c4 10             	add    $0x10,%esp
80100c4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c52:	e9 05 fe ff ff       	jmp    80100a5c <exec+0x6c>
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c57:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c5e:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c60:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c67:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c6b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c72:	ff ff ff 
  ustack[1] = argc;
80100c75:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c7b:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c7d:	83 c0 0c             	add    $0xc,%eax
80100c80:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c82:	50                   	push   %eax
80100c83:	52                   	push   %edx
80100c84:	53                   	push   %ebx
80100c85:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8b:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c91:	e8 ca 62 00 00       	call   80106f60 <copyout>
80100c96:	83 c4 10             	add    $0x10,%esp
80100c99:	85 c0                	test   %eax,%eax
80100c9b:	78 80                	js     80100c1d <exec+0x22d>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80100ca0:	0f b6 10             	movzbl (%eax),%edx
80100ca3:	84 d2                	test   %dl,%dl
80100ca5:	74 1c                	je     80100cc3 <exec+0x2d3>
80100ca7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100caa:	83 c0 01             	add    $0x1,%eax
80100cad:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s == '/')
      last = s+1;
80100cb0:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb3:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cb6:	0f 44 c8             	cmove  %eax,%ecx
80100cb9:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cbc:	84 d2                	test   %dl,%dl
80100cbe:	75 f0                	jne    80100cb0 <exec+0x2c0>
80100cc0:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cc3:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cc9:	83 ec 04             	sub    $0x4,%esp
80100ccc:	6a 10                	push   $0x10
80100cce:	ff 75 08             	pushl  0x8(%ebp)
80100cd1:	89 f8                	mov    %edi,%eax
80100cd3:	83 c0 70             	add    $0x70,%eax
80100cd6:	50                   	push   %eax
80100cd7:	e8 14 39 00 00       	call   801045f0 <safestrcpy>
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  sz = PGROUNDUP(sz);
80100cdc:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100ce2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100ce8:	8b 77 08             	mov    0x8(%edi),%esi
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  sz = PGROUNDUP(sz);
80100ceb:	05 ff 0f 00 00       	add    $0xfff,%eax
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100cf0:	89 57 08             	mov    %edx,0x8(%edi)
  curproc->sz = sz;
80100cf3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cf8:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100cfa:	8b 47 1c             	mov    0x1c(%edi),%eax
80100cfd:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d03:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d06:	8b 47 1c             	mov    0x1c(%edi),%eax
80100d09:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d0c:	89 3c 24             	mov    %edi,(%esp)
80100d0f:	e8 ac 5b 00 00       	call   801068c0 <switchuvm>
  freevm(oldpgdir);
80100d14:	89 34 24             	mov    %esi,(%esp)
80100d17:	e8 24 5f 00 00       	call   80106c40 <freevm>
  return 0;
80100d1c:	83 c4 10             	add    $0x10,%esp
80100d1f:	31 c0                	xor    %eax,%eax
80100d21:	e9 36 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d26:	66 90                	xchg   %ax,%ax
80100d28:	66 90                	xchg   %ax,%ax
80100d2a:	66 90                	xchg   %ax,%ax
80100d2c:	66 90                	xchg   %ax,%ax
80100d2e:	66 90                	xchg   %ax,%ax

80100d30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d36:	68 0d 71 10 80       	push   $0x8010710d
80100d3b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d40:	e8 3b 34 00 00       	call   80104180 <initlock>
}
80100d45:	83 c4 10             	add    $0x10,%esp
80100d48:	c9                   	leave  
80100d49:	c3                   	ret    
80100d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d54:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d59:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d5c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d61:	e8 1a 35 00 00       	call   80104280 <acquire>
80100d66:	83 c4 10             	add    $0x10,%esp
80100d69:	eb 10                	jmp    80100d7b <filealloc+0x2b>
80100d6b:	90                   	nop
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d70:	83 c3 18             	add    $0x18,%ebx
80100d73:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d79:	74 25                	je     80100da0 <filealloc+0x50>
    if(f->ref == 0){
80100d7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d7e:	85 c0                	test   %eax,%eax
80100d80:	75 ee                	jne    80100d70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d82:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 0a 36 00 00       	call   801043a0 <release>
      return f;
80100d96:	89 d8                	mov    %ebx,%eax
80100d98:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d9e:	c9                   	leave  
80100d9f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100da0:	83 ec 0c             	sub    $0xc,%esp
80100da3:	68 c0 ff 10 80       	push   $0x8010ffc0
80100da8:	e8 f3 35 00 00       	call   801043a0 <release>
  return 0;
80100dad:	83 c4 10             	add    $0x10,%esp
80100db0:	31 c0                	xor    %eax,%eax
}
80100db2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100db5:	c9                   	leave  
80100db6:	c3                   	ret    
80100db7:	89 f6                	mov    %esi,%esi
80100db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100dc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
80100dc4:	83 ec 10             	sub    $0x10,%esp
80100dc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dca:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dcf:	e8 ac 34 00 00       	call   80104280 <acquire>
  if(f->ref < 1)
80100dd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100dd7:	83 c4 10             	add    $0x10,%esp
80100dda:	85 c0                	test   %eax,%eax
80100ddc:	7e 1a                	jle    80100df8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dde:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100de1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100de4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100de7:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dec:	e8 af 35 00 00       	call   801043a0 <release>
  return f;
}
80100df1:	89 d8                	mov    %ebx,%eax
80100df3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100df6:	c9                   	leave  
80100df7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100df8:	83 ec 0c             	sub    $0xc,%esp
80100dfb:	68 14 71 10 80       	push   $0x80107114
80100e00:	e8 6b f5 ff ff       	call   80100370 <panic>
80100e05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e10 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	57                   	push   %edi
80100e14:	56                   	push   %esi
80100e15:	53                   	push   %ebx
80100e16:	83 ec 28             	sub    $0x28,%esp
80100e19:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e1c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e21:	e8 5a 34 00 00       	call   80104280 <acquire>
  if(f->ref < 1)
80100e26:	8b 47 04             	mov    0x4(%edi),%eax
80100e29:	83 c4 10             	add    $0x10,%esp
80100e2c:	85 c0                	test   %eax,%eax
80100e2e:	0f 8e 9b 00 00 00    	jle    80100ecf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e34:	83 e8 01             	sub    $0x1,%eax
80100e37:	85 c0                	test   %eax,%eax
80100e39:	89 47 04             	mov    %eax,0x4(%edi)
80100e3c:	74 1a                	je     80100e58 <fileclose+0x48>
    release(&ftable.lock);
80100e3e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e48:	5b                   	pop    %ebx
80100e49:	5e                   	pop    %esi
80100e4a:	5f                   	pop    %edi
80100e4b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e4c:	e9 4f 35 00 00       	jmp    801043a0 <release>
80100e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e58:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e5c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e5e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e61:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e64:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e6a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e6d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e70:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e75:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e78:	e8 23 35 00 00       	call   801043a0 <release>

  if(ff.type == FD_PIPE)
80100e7d:	83 c4 10             	add    $0x10,%esp
80100e80:	83 fb 01             	cmp    $0x1,%ebx
80100e83:	74 13                	je     80100e98 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e85:	83 fb 02             	cmp    $0x2,%ebx
80100e88:	74 26                	je     80100eb0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e8d:	5b                   	pop    %ebx
80100e8e:	5e                   	pop    %esi
80100e8f:	5f                   	pop    %edi
80100e90:	5d                   	pop    %ebp
80100e91:	c3                   	ret    
80100e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e98:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100e9c:	83 ec 08             	sub    $0x8,%esp
80100e9f:	53                   	push   %ebx
80100ea0:	56                   	push   %esi
80100ea1:	e8 2a 24 00 00       	call   801032d0 <pipeclose>
80100ea6:	83 c4 10             	add    $0x10,%esp
80100ea9:	eb df                	jmp    80100e8a <fileclose+0x7a>
80100eab:	90                   	nop
80100eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100eb0:	e8 7b 1c 00 00       	call   80102b30 <begin_op>
    iput(ff.ip);
80100eb5:	83 ec 0c             	sub    $0xc,%esp
80100eb8:	ff 75 e0             	pushl  -0x20(%ebp)
80100ebb:	e8 c0 08 00 00       	call   80101780 <iput>
    end_op();
80100ec0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ec6:	5b                   	pop    %ebx
80100ec7:	5e                   	pop    %esi
80100ec8:	5f                   	pop    %edi
80100ec9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eca:	e9 d1 1c 00 00       	jmp    80102ba0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ecf:	83 ec 0c             	sub    $0xc,%esp
80100ed2:	68 1c 71 10 80       	push   $0x8010711c
80100ed7:	e8 94 f4 ff ff       	call   80100370 <panic>
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ee0:	55                   	push   %ebp
80100ee1:	89 e5                	mov    %esp,%ebp
80100ee3:	53                   	push   %ebx
80100ee4:	83 ec 04             	sub    $0x4,%esp
80100ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100eed:	75 31                	jne    80100f20 <filestat+0x40>
    ilock(f->ip);
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	ff 73 10             	pushl  0x10(%ebx)
80100ef5:	e8 56 07 00 00       	call   80101650 <ilock>
    stati(f->ip, st);
80100efa:	58                   	pop    %eax
80100efb:	5a                   	pop    %edx
80100efc:	ff 75 0c             	pushl  0xc(%ebp)
80100eff:	ff 73 10             	pushl  0x10(%ebx)
80100f02:	e8 f9 09 00 00       	call   80101900 <stati>
    iunlock(f->ip);
80100f07:	59                   	pop    %ecx
80100f08:	ff 73 10             	pushl  0x10(%ebx)
80100f0b:	e8 20 08 00 00       	call   80101730 <iunlock>
    return 0;
80100f10:	83 c4 10             	add    $0x10,%esp
80100f13:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f18:	c9                   	leave  
80100f19:	c3                   	ret    
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f28:	c9                   	leave  
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f30 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	57                   	push   %edi
80100f34:	56                   	push   %esi
80100f35:	53                   	push   %ebx
80100f36:	83 ec 0c             	sub    $0xc,%esp
80100f39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f42:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f46:	74 60                	je     80100fa8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f48:	8b 03                	mov    (%ebx),%eax
80100f4a:	83 f8 01             	cmp    $0x1,%eax
80100f4d:	74 41                	je     80100f90 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f4f:	83 f8 02             	cmp    $0x2,%eax
80100f52:	75 5b                	jne    80100faf <fileread+0x7f>
    ilock(f->ip);
80100f54:	83 ec 0c             	sub    $0xc,%esp
80100f57:	ff 73 10             	pushl  0x10(%ebx)
80100f5a:	e8 f1 06 00 00       	call   80101650 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f5f:	57                   	push   %edi
80100f60:	ff 73 14             	pushl  0x14(%ebx)
80100f63:	56                   	push   %esi
80100f64:	ff 73 10             	pushl  0x10(%ebx)
80100f67:	e8 c4 09 00 00       	call   80101930 <readi>
80100f6c:	83 c4 20             	add    $0x20,%esp
80100f6f:	85 c0                	test   %eax,%eax
80100f71:	89 c6                	mov    %eax,%esi
80100f73:	7e 03                	jle    80100f78 <fileread+0x48>
      f->off += r;
80100f75:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f78:	83 ec 0c             	sub    $0xc,%esp
80100f7b:	ff 73 10             	pushl  0x10(%ebx)
80100f7e:	e8 ad 07 00 00       	call   80101730 <iunlock>
    return r;
80100f83:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f86:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8b:	5b                   	pop    %ebx
80100f8c:	5e                   	pop    %esi
80100f8d:	5f                   	pop    %edi
80100f8e:	5d                   	pop    %ebp
80100f8f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f90:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f93:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f99:	5b                   	pop    %ebx
80100f9a:	5e                   	pop    %esi
80100f9b:	5f                   	pop    %edi
80100f9c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f9d:	e9 ce 24 00 00       	jmp    80103470 <piperead>
80100fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fad:	eb d9                	jmp    80100f88 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	68 26 71 10 80       	push   $0x80107126
80100fb7:	e8 b4 f3 ff ff       	call   80100370 <panic>
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 1c             	sub    $0x1c,%esp
80100fc9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fcf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fd6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fdc:	0f 84 aa 00 00 00    	je     8010108c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100fe2:	8b 06                	mov    (%esi),%eax
80100fe4:	83 f8 01             	cmp    $0x1,%eax
80100fe7:	0f 84 c2 00 00 00    	je     801010af <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fed:	83 f8 02             	cmp    $0x2,%eax
80100ff0:	0f 85 d8 00 00 00    	jne    801010ce <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ff9:	31 ff                	xor    %edi,%edi
80100ffb:	85 c0                	test   %eax,%eax
80100ffd:	7f 34                	jg     80101033 <filewrite+0x73>
80100fff:	e9 9c 00 00 00       	jmp    801010a0 <filewrite+0xe0>
80101004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101008:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010100b:	83 ec 0c             	sub    $0xc,%esp
8010100e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101011:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101014:	e8 17 07 00 00       	call   80101730 <iunlock>
      end_op();
80101019:	e8 82 1b 00 00       	call   80102ba0 <end_op>
8010101e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101021:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101024:	39 d8                	cmp    %ebx,%eax
80101026:	0f 85 95 00 00 00    	jne    801010c1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010102c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010102e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101031:	7e 6d                	jle    801010a0 <filewrite+0xe0>
      int n1 = n - i;
80101033:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101036:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010103b:	29 fb                	sub    %edi,%ebx
8010103d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101043:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101046:	e8 e5 1a 00 00       	call   80102b30 <begin_op>
      ilock(f->ip);
8010104b:	83 ec 0c             	sub    $0xc,%esp
8010104e:	ff 76 10             	pushl  0x10(%esi)
80101051:	e8 fa 05 00 00       	call   80101650 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101056:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101059:	53                   	push   %ebx
8010105a:	ff 76 14             	pushl  0x14(%esi)
8010105d:	01 f8                	add    %edi,%eax
8010105f:	50                   	push   %eax
80101060:	ff 76 10             	pushl  0x10(%esi)
80101063:	e8 c8 09 00 00       	call   80101a30 <writei>
80101068:	83 c4 20             	add    $0x20,%esp
8010106b:	85 c0                	test   %eax,%eax
8010106d:	7f 99                	jg     80101008 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	ff 76 10             	pushl  0x10(%esi)
80101075:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101078:	e8 b3 06 00 00       	call   80101730 <iunlock>
      end_op();
8010107d:	e8 1e 1b 00 00       	call   80102ba0 <end_op>

      if(r < 0)
80101082:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101085:	83 c4 10             	add    $0x10,%esp
80101088:	85 c0                	test   %eax,%eax
8010108a:	74 98                	je     80101024 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010108c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010108f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101094:	5b                   	pop    %ebx
80101095:	5e                   	pop    %esi
80101096:	5f                   	pop    %edi
80101097:	5d                   	pop    %ebp
80101098:	c3                   	ret    
80101099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010a0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010a3:	75 e7                	jne    8010108c <filewrite+0xcc>
  }
  panic("filewrite");
}
801010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a8:	89 f8                	mov    %edi,%eax
801010aa:	5b                   	pop    %ebx
801010ab:	5e                   	pop    %esi
801010ac:	5f                   	pop    %edi
801010ad:	5d                   	pop    %ebp
801010ae:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010af:	8b 46 0c             	mov    0xc(%esi),%eax
801010b2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010bc:	e9 af 22 00 00       	jmp    80103370 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010c1:	83 ec 0c             	sub    $0xc,%esp
801010c4:	68 2f 71 10 80       	push   $0x8010712f
801010c9:	e8 a2 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ce:	83 ec 0c             	sub    $0xc,%esp
801010d1:	68 35 71 10 80       	push   $0x80107135
801010d6:	e8 95 f2 ff ff       	call   80100370 <panic>
801010db:	66 90                	xchg   %ax,%ax
801010dd:	66 90                	xchg   %ax,%ax
801010df:	90                   	nop

801010e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010e9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010f2:	85 c9                	test   %ecx,%ecx
801010f4:	0f 84 85 00 00 00    	je     8010117f <balloc+0x9f>
801010fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101101:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101104:	83 ec 08             	sub    $0x8,%esp
80101107:	89 f0                	mov    %esi,%eax
80101109:	c1 f8 0c             	sar    $0xc,%eax
8010110c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101112:	50                   	push   %eax
80101113:	ff 75 d8             	pushl  -0x28(%ebp)
80101116:	e8 b5 ef ff ff       	call   801000d0 <bread>
8010111b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010111e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101123:	83 c4 10             	add    $0x10,%esp
80101126:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101129:	31 c0                	xor    %eax,%eax
8010112b:	eb 2d                	jmp    8010115a <balloc+0x7a>
8010112d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101130:	89 c1                	mov    %eax,%ecx
80101132:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101137:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010113a:	83 e1 07             	and    $0x7,%ecx
8010113d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010113f:	89 c1                	mov    %eax,%ecx
80101141:	c1 f9 03             	sar    $0x3,%ecx
80101144:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101149:	85 d7                	test   %edx,%edi
8010114b:	74 43                	je     80101190 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114d:	83 c0 01             	add    $0x1,%eax
80101150:	83 c6 01             	add    $0x1,%esi
80101153:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101158:	74 05                	je     8010115f <balloc+0x7f>
8010115a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010115d:	72 d1                	jb     80101130 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	ff 75 e4             	pushl  -0x1c(%ebp)
80101165:	e8 76 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010116a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101171:	83 c4 10             	add    $0x10,%esp
80101174:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101177:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010117d:	77 82                	ja     80101101 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	68 3f 71 10 80       	push   $0x8010713f
80101187:	e8 e4 f1 ff ff       	call   80100370 <panic>
8010118c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101190:	09 fa                	or     %edi,%edx
80101192:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101195:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101198:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010119c:	57                   	push   %edi
8010119d:	e8 6e 1b 00 00       	call   80102d10 <log_write>
        brelse(bp);
801011a2:	89 3c 24             	mov    %edi,(%esp)
801011a5:	e8 36 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011aa:	58                   	pop    %eax
801011ab:	5a                   	pop    %edx
801011ac:	56                   	push   %esi
801011ad:	ff 75 d8             	pushl  -0x28(%ebp)
801011b0:	e8 1b ef ff ff       	call   801000d0 <bread>
801011b5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ba:	83 c4 0c             	add    $0xc,%esp
801011bd:	68 00 02 00 00       	push   $0x200
801011c2:	6a 00                	push   $0x0
801011c4:	50                   	push   %eax
801011c5:	e8 26 32 00 00       	call   801043f0 <memset>
  log_write(bp);
801011ca:	89 1c 24             	mov    %ebx,(%esp)
801011cd:	e8 3e 1b 00 00       	call   80102d10 <log_write>
  brelse(bp);
801011d2:	89 1c 24             	mov    %ebx,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011dd:	89 f0                	mov    %esi,%eax
801011df:	5b                   	pop    %ebx
801011e0:	5e                   	pop    %esi
801011e1:	5f                   	pop    %edi
801011e2:	5d                   	pop    %ebp
801011e3:	c3                   	ret    
801011e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801011f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	57                   	push   %edi
801011f4:	56                   	push   %esi
801011f5:	53                   	push   %ebx
801011f6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801011f8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011fa:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011ff:	83 ec 28             	sub    $0x28,%esp
80101202:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101205:	68 e0 09 11 80       	push   $0x801109e0
8010120a:	e8 71 30 00 00       	call   80104280 <acquire>
8010120f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101215:	eb 1b                	jmp    80101232 <iget+0x42>
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101220:	85 f6                	test   %esi,%esi
80101222:	74 44                	je     80101268 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101224:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010122a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101230:	74 4e                	je     80101280 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101232:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101235:	85 c9                	test   %ecx,%ecx
80101237:	7e e7                	jle    80101220 <iget+0x30>
80101239:	39 3b                	cmp    %edi,(%ebx)
8010123b:	75 e3                	jne    80101220 <iget+0x30>
8010123d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101240:	75 de                	jne    80101220 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101242:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101245:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101248:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010124a:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010124f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101252:	e8 49 31 00 00       	call   801043a0 <release>
      return ip;
80101257:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010125a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010125d:	89 f0                	mov    %esi,%eax
8010125f:	5b                   	pop    %ebx
80101260:	5e                   	pop    %esi
80101261:	5f                   	pop    %edi
80101262:	5d                   	pop    %ebp
80101263:	c3                   	ret    
80101264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101268:	85 c9                	test   %ecx,%ecx
8010126a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010126d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101273:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101279:	75 b7                	jne    80101232 <iget+0x42>
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 2d                	je     801012b1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 e0 09 11 80       	push   $0x801109e0
8010129f:	e8 fc 30 00 00       	call   801043a0 <release>

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
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	68 55 71 10 80       	push   $0x80107155
801012b9:	e8 b2 f0 ff ff       	call   80100370 <panic>
801012be:	66 90                	xchg   %ax,%ax

801012c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c6                	mov    %eax,%esi
801012c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012cb:	83 fa 0b             	cmp    $0xb,%edx
801012ce:	77 18                	ja     801012e8 <bmap+0x28>
801012d0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012d3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012d6:	85 c0                	test   %eax,%eax
801012d8:	74 76                	je     80101350 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dd:	5b                   	pop    %ebx
801012de:	5e                   	pop    %esi
801012df:	5f                   	pop    %edi
801012e0:	5d                   	pop    %ebp
801012e1:	c3                   	ret    
801012e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012e8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801012eb:	83 fb 7f             	cmp    $0x7f,%ebx
801012ee:	0f 87 83 00 00 00    	ja     80101377 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801012f4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012fa:	85 c0                	test   %eax,%eax
801012fc:	74 6a                	je     80101368 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012fe:	83 ec 08             	sub    $0x8,%esp
80101301:	50                   	push   %eax
80101302:	ff 36                	pushl  (%esi)
80101304:	e8 c7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101309:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010130d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101310:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101312:	8b 1a                	mov    (%edx),%ebx
80101314:	85 db                	test   %ebx,%ebx
80101316:	75 1d                	jne    80101335 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101318:	8b 06                	mov    (%esi),%eax
8010131a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010131d:	e8 be fd ff ff       	call   801010e0 <balloc>
80101322:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101325:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101328:	89 c3                	mov    %eax,%ebx
8010132a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010132c:	57                   	push   %edi
8010132d:	e8 de 19 00 00       	call   80102d10 <log_write>
80101332:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101335:	83 ec 0c             	sub    $0xc,%esp
80101338:	57                   	push   %edi
80101339:	e8 a2 ee ff ff       	call   801001e0 <brelse>
8010133e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101341:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101344:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101346:	5b                   	pop    %ebx
80101347:	5e                   	pop    %esi
80101348:	5f                   	pop    %edi
80101349:	5d                   	pop    %ebp
8010134a:	c3                   	ret    
8010134b:	90                   	nop
8010134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101350:	8b 06                	mov    (%esi),%eax
80101352:	e8 89 fd ff ff       	call   801010e0 <balloc>
80101357:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135d:	5b                   	pop    %ebx
8010135e:	5e                   	pop    %esi
8010135f:	5f                   	pop    %edi
80101360:	5d                   	pop    %ebp
80101361:	c3                   	ret    
80101362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101368:	8b 06                	mov    (%esi),%eax
8010136a:	e8 71 fd ff ff       	call   801010e0 <balloc>
8010136f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101375:	eb 87                	jmp    801012fe <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101377:	83 ec 0c             	sub    $0xc,%esp
8010137a:	68 65 71 10 80       	push   $0x80107165
8010137f:	e8 ec ef ff ff       	call   80100370 <panic>
80101384:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010138a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101390 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	56                   	push   %esi
80101394:	53                   	push   %ebx
80101395:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101398:	83 ec 08             	sub    $0x8,%esp
8010139b:	6a 01                	push   $0x1
8010139d:	ff 75 08             	pushl  0x8(%ebp)
801013a0:	e8 2b ed ff ff       	call   801000d0 <bread>
801013a5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013aa:	83 c4 0c             	add    $0xc,%esp
801013ad:	6a 1c                	push   $0x1c
801013af:	50                   	push   %eax
801013b0:	56                   	push   %esi
801013b1:	e8 ea 30 00 00       	call   801044a0 <memmove>
  brelse(bp);
801013b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013b9:	83 c4 10             	add    $0x10,%esp
}
801013bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013c2:	e9 19 ee ff ff       	jmp    801001e0 <brelse>
801013c7:	89 f6                	mov    %esi,%esi
801013c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	89 d3                	mov    %edx,%ebx
801013d7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013d9:	83 ec 08             	sub    $0x8,%esp
801013dc:	68 c0 09 11 80       	push   $0x801109c0
801013e1:	50                   	push   %eax
801013e2:	e8 a9 ff ff ff       	call   80101390 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013e7:	58                   	pop    %eax
801013e8:	5a                   	pop    %edx
801013e9:	89 da                	mov    %ebx,%edx
801013eb:	c1 ea 0c             	shr    $0xc,%edx
801013ee:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801013f4:	52                   	push   %edx
801013f5:	56                   	push   %esi
801013f6:	e8 d5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013fb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801013fd:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101403:	ba 01 00 00 00       	mov    $0x1,%edx
80101408:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010140b:	c1 fb 03             	sar    $0x3,%ebx
8010140e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101411:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101413:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101418:	85 d1                	test   %edx,%ecx
8010141a:	74 27                	je     80101443 <bfree+0x73>
8010141c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010141e:	f7 d2                	not    %edx
80101420:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101422:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101425:	21 d0                	and    %edx,%eax
80101427:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010142b:	56                   	push   %esi
8010142c:	e8 df 18 00 00       	call   80102d10 <log_write>
  brelse(bp);
80101431:	89 34 24             	mov    %esi,(%esp)
80101434:	e8 a7 ed ff ff       	call   801001e0 <brelse>
}
80101439:	83 c4 10             	add    $0x10,%esp
8010143c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010143f:	5b                   	pop    %ebx
80101440:	5e                   	pop    %esi
80101441:	5d                   	pop    %ebp
80101442:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101443:	83 ec 0c             	sub    $0xc,%esp
80101446:	68 78 71 10 80       	push   $0x80107178
8010144b:	e8 20 ef ff ff       	call   80100370 <panic>

80101450 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	53                   	push   %ebx
80101454:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101459:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010145c:	68 8b 71 10 80       	push   $0x8010718b
80101461:	68 e0 09 11 80       	push   $0x801109e0
80101466:	e8 15 2d 00 00       	call   80104180 <initlock>
8010146b:	83 c4 10             	add    $0x10,%esp
8010146e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101470:	83 ec 08             	sub    $0x8,%esp
80101473:	68 92 71 10 80       	push   $0x80107192
80101478:	53                   	push   %ebx
80101479:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010147f:	e8 ec 2b 00 00       	call   80104070 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101484:	83 c4 10             	add    $0x10,%esp
80101487:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010148d:	75 e1                	jne    80101470 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010148f:	83 ec 08             	sub    $0x8,%esp
80101492:	68 c0 09 11 80       	push   $0x801109c0
80101497:	ff 75 08             	pushl  0x8(%ebp)
8010149a:	e8 f1 fe ff ff       	call   80101390 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010149f:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014a5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014ab:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014b1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014b7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014bd:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014c3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014c9:	68 f8 71 10 80       	push   $0x801071f8
801014ce:	e8 8d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014d3:	83 c4 30             	add    $0x30,%esp
801014d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014d9:	c9                   	leave  
801014da:	c3                   	ret    
801014db:	90                   	nop
801014dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014e0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	53                   	push   %ebx
801014e6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014e9:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801014f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801014f3:	8b 75 08             	mov    0x8(%ebp),%esi
801014f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014f9:	0f 86 91 00 00 00    	jbe    80101590 <ialloc+0xb0>
801014ff:	bb 01 00 00 00       	mov    $0x1,%ebx
80101504:	eb 21                	jmp    80101527 <ialloc+0x47>
80101506:	8d 76 00             	lea    0x0(%esi),%esi
80101509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101510:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101513:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101516:	57                   	push   %edi
80101517:	e8 c4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010151c:	83 c4 10             	add    $0x10,%esp
8010151f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101525:	76 69                	jbe    80101590 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101527:	89 d8                	mov    %ebx,%eax
80101529:	83 ec 08             	sub    $0x8,%esp
8010152c:	c1 e8 03             	shr    $0x3,%eax
8010152f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101535:	50                   	push   %eax
80101536:	56                   	push   %esi
80101537:	e8 94 eb ff ff       	call   801000d0 <bread>
8010153c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010153e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101540:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101543:	83 e0 07             	and    $0x7,%eax
80101546:	c1 e0 06             	shl    $0x6,%eax
80101549:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010154d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101551:	75 bd                	jne    80101510 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101553:	83 ec 04             	sub    $0x4,%esp
80101556:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101559:	6a 40                	push   $0x40
8010155b:	6a 00                	push   $0x0
8010155d:	51                   	push   %ecx
8010155e:	e8 8d 2e 00 00       	call   801043f0 <memset>
      dip->type = type;
80101563:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101567:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010156a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010156d:	89 3c 24             	mov    %edi,(%esp)
80101570:	e8 9b 17 00 00       	call   80102d10 <log_write>
      brelse(bp);
80101575:	89 3c 24             	mov    %edi,(%esp)
80101578:	e8 63 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010157d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101580:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101583:	89 da                	mov    %ebx,%edx
80101585:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101587:	5b                   	pop    %ebx
80101588:	5e                   	pop    %esi
80101589:	5f                   	pop    %edi
8010158a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010158b:	e9 60 fc ff ff       	jmp    801011f0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101590:	83 ec 0c             	sub    $0xc,%esp
80101593:	68 98 71 10 80       	push   $0x80107198
80101598:	e8 d3 ed ff ff       	call   80100370 <panic>
8010159d:	8d 76 00             	lea    0x0(%esi),%esi

801015a0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	56                   	push   %esi
801015a4:	53                   	push   %ebx
801015a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015a8:	83 ec 08             	sub    $0x8,%esp
801015ab:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ae:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015b1:	c1 e8 03             	shr    $0x3,%eax
801015b4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015ba:	50                   	push   %eax
801015bb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015be:	e8 0d eb ff ff       	call   801000d0 <bread>
801015c3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015c5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015c8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015cc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015cf:	83 e0 07             	and    $0x7,%eax
801015d2:	c1 e0 06             	shl    $0x6,%eax
801015d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015d9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015dc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015e0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801015e3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015e7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015eb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015ef:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801015f3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801015f7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801015fa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015fd:	6a 34                	push   $0x34
801015ff:	53                   	push   %ebx
80101600:	50                   	push   %eax
80101601:	e8 9a 2e 00 00       	call   801044a0 <memmove>
  log_write(bp);
80101606:	89 34 24             	mov    %esi,(%esp)
80101609:	e8 02 17 00 00       	call   80102d10 <log_write>
  brelse(bp);
8010160e:	89 75 08             	mov    %esi,0x8(%ebp)
80101611:	83 c4 10             	add    $0x10,%esp
}
80101614:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101617:	5b                   	pop    %ebx
80101618:	5e                   	pop    %esi
80101619:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010161a:	e9 c1 eb ff ff       	jmp    801001e0 <brelse>
8010161f:	90                   	nop

80101620 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	53                   	push   %ebx
80101624:	83 ec 10             	sub    $0x10,%esp
80101627:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010162a:	68 e0 09 11 80       	push   $0x801109e0
8010162f:	e8 4c 2c 00 00       	call   80104280 <acquire>
  ip->ref++;
80101634:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101638:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010163f:	e8 5c 2d 00 00       	call   801043a0 <release>
  return ip;
}
80101644:	89 d8                	mov    %ebx,%eax
80101646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101649:	c9                   	leave  
8010164a:	c3                   	ret    
8010164b:	90                   	nop
8010164c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101650 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	56                   	push   %esi
80101654:	53                   	push   %ebx
80101655:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101658:	85 db                	test   %ebx,%ebx
8010165a:	0f 84 b7 00 00 00    	je     80101717 <ilock+0xc7>
80101660:	8b 53 08             	mov    0x8(%ebx),%edx
80101663:	85 d2                	test   %edx,%edx
80101665:	0f 8e ac 00 00 00    	jle    80101717 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010166b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010166e:	83 ec 0c             	sub    $0xc,%esp
80101671:	50                   	push   %eax
80101672:	e8 39 2a 00 00       	call   801040b0 <acquiresleep>

  if(ip->valid == 0){
80101677:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010167a:	83 c4 10             	add    $0x10,%esp
8010167d:	85 c0                	test   %eax,%eax
8010167f:	74 0f                	je     80101690 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101681:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101684:	5b                   	pop    %ebx
80101685:	5e                   	pop    %esi
80101686:	5d                   	pop    %ebp
80101687:	c3                   	ret    
80101688:	90                   	nop
80101689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101690:	8b 43 04             	mov    0x4(%ebx),%eax
80101693:	83 ec 08             	sub    $0x8,%esp
80101696:	c1 e8 03             	shr    $0x3,%eax
80101699:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010169f:	50                   	push   %eax
801016a0:	ff 33                	pushl  (%ebx)
801016a2:	e8 29 ea ff ff       	call   801000d0 <bread>
801016a7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016a9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ac:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016af:	83 e0 07             	and    $0x7,%eax
801016b2:	c1 e0 06             	shl    $0x6,%eax
801016b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016b9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016bc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016bf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016c3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016c7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016cb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016cf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016d3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016d7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016db:	8b 50 fc             	mov    -0x4(%eax),%edx
801016de:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016e1:	6a 34                	push   $0x34
801016e3:	50                   	push   %eax
801016e4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016e7:	50                   	push   %eax
801016e8:	e8 b3 2d 00 00       	call   801044a0 <memmove>
    brelse(bp);
801016ed:	89 34 24             	mov    %esi,(%esp)
801016f0:	e8 eb ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
801016f5:	83 c4 10             	add    $0x10,%esp
801016f8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
801016fd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101704:	0f 85 77 ff ff ff    	jne    80101681 <ilock+0x31>
      panic("ilock: no type");
8010170a:	83 ec 0c             	sub    $0xc,%esp
8010170d:	68 b0 71 10 80       	push   $0x801071b0
80101712:	e8 59 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101717:	83 ec 0c             	sub    $0xc,%esp
8010171a:	68 aa 71 10 80       	push   $0x801071aa
8010171f:	e8 4c ec ff ff       	call   80100370 <panic>
80101724:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010172a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101730 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	56                   	push   %esi
80101734:	53                   	push   %ebx
80101735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101738:	85 db                	test   %ebx,%ebx
8010173a:	74 28                	je     80101764 <iunlock+0x34>
8010173c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010173f:	83 ec 0c             	sub    $0xc,%esp
80101742:	56                   	push   %esi
80101743:	e8 08 2a 00 00       	call   80104150 <holdingsleep>
80101748:	83 c4 10             	add    $0x10,%esp
8010174b:	85 c0                	test   %eax,%eax
8010174d:	74 15                	je     80101764 <iunlock+0x34>
8010174f:	8b 43 08             	mov    0x8(%ebx),%eax
80101752:	85 c0                	test   %eax,%eax
80101754:	7e 0e                	jle    80101764 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101756:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101759:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010175c:	5b                   	pop    %ebx
8010175d:	5e                   	pop    %esi
8010175e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010175f:	e9 ac 29 00 00       	jmp    80104110 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101764:	83 ec 0c             	sub    $0xc,%esp
80101767:	68 bf 71 10 80       	push   $0x801071bf
8010176c:	e8 ff eb ff ff       	call   80100370 <panic>
80101771:	eb 0d                	jmp    80101780 <iput>
80101773:	90                   	nop
80101774:	90                   	nop
80101775:	90                   	nop
80101776:	90                   	nop
80101777:	90                   	nop
80101778:	90                   	nop
80101779:	90                   	nop
8010177a:	90                   	nop
8010177b:	90                   	nop
8010177c:	90                   	nop
8010177d:	90                   	nop
8010177e:	90                   	nop
8010177f:	90                   	nop

80101780 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	57                   	push   %edi
80101784:	56                   	push   %esi
80101785:	53                   	push   %ebx
80101786:	83 ec 28             	sub    $0x28,%esp
80101789:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010178c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010178f:	57                   	push   %edi
80101790:	e8 1b 29 00 00       	call   801040b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101795:	8b 56 4c             	mov    0x4c(%esi),%edx
80101798:	83 c4 10             	add    $0x10,%esp
8010179b:	85 d2                	test   %edx,%edx
8010179d:	74 07                	je     801017a6 <iput+0x26>
8010179f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017a4:	74 32                	je     801017d8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017a6:	83 ec 0c             	sub    $0xc,%esp
801017a9:	57                   	push   %edi
801017aa:	e8 61 29 00 00       	call   80104110 <releasesleep>

  acquire(&icache.lock);
801017af:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017b6:	e8 c5 2a 00 00       	call   80104280 <acquire>
  ip->ref--;
801017bb:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017bf:	83 c4 10             	add    $0x10,%esp
801017c2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017cc:	5b                   	pop    %ebx
801017cd:	5e                   	pop    %esi
801017ce:	5f                   	pop    %edi
801017cf:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017d0:	e9 cb 2b 00 00       	jmp    801043a0 <release>
801017d5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017d8:	83 ec 0c             	sub    $0xc,%esp
801017db:	68 e0 09 11 80       	push   $0x801109e0
801017e0:	e8 9b 2a 00 00       	call   80104280 <acquire>
    int r = ip->ref;
801017e5:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801017e8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017ef:	e8 ac 2b 00 00       	call   801043a0 <release>
    if(r == 1){
801017f4:	83 c4 10             	add    $0x10,%esp
801017f7:	83 fb 01             	cmp    $0x1,%ebx
801017fa:	75 aa                	jne    801017a6 <iput+0x26>
801017fc:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101802:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101805:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101808:	89 cf                	mov    %ecx,%edi
8010180a:	eb 0b                	jmp    80101817 <iput+0x97>
8010180c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101810:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101813:	39 fb                	cmp    %edi,%ebx
80101815:	74 19                	je     80101830 <iput+0xb0>
    if(ip->addrs[i]){
80101817:	8b 13                	mov    (%ebx),%edx
80101819:	85 d2                	test   %edx,%edx
8010181b:	74 f3                	je     80101810 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010181d:	8b 06                	mov    (%esi),%eax
8010181f:	e8 ac fb ff ff       	call   801013d0 <bfree>
      ip->addrs[i] = 0;
80101824:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010182a:	eb e4                	jmp    80101810 <iput+0x90>
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101830:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101836:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101839:	85 c0                	test   %eax,%eax
8010183b:	75 33                	jne    80101870 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010183d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101840:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101847:	56                   	push   %esi
80101848:	e8 53 fd ff ff       	call   801015a0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010184d:	31 c0                	xor    %eax,%eax
8010184f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101853:	89 34 24             	mov    %esi,(%esp)
80101856:	e8 45 fd ff ff       	call   801015a0 <iupdate>
      ip->valid = 0;
8010185b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101862:	83 c4 10             	add    $0x10,%esp
80101865:	e9 3c ff ff ff       	jmp    801017a6 <iput+0x26>
8010186a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101870:	83 ec 08             	sub    $0x8,%esp
80101873:	50                   	push   %eax
80101874:	ff 36                	pushl  (%esi)
80101876:	e8 55 e8 ff ff       	call   801000d0 <bread>
8010187b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101881:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101884:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101887:	8d 58 5c             	lea    0x5c(%eax),%ebx
8010188a:	83 c4 10             	add    $0x10,%esp
8010188d:	89 cf                	mov    %ecx,%edi
8010188f:	eb 0e                	jmp    8010189f <iput+0x11f>
80101891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101898:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
8010189b:	39 fb                	cmp    %edi,%ebx
8010189d:	74 0f                	je     801018ae <iput+0x12e>
      if(a[j])
8010189f:	8b 13                	mov    (%ebx),%edx
801018a1:	85 d2                	test   %edx,%edx
801018a3:	74 f3                	je     80101898 <iput+0x118>
        bfree(ip->dev, a[j]);
801018a5:	8b 06                	mov    (%esi),%eax
801018a7:	e8 24 fb ff ff       	call   801013d0 <bfree>
801018ac:	eb ea                	jmp    80101898 <iput+0x118>
    }
    brelse(bp);
801018ae:	83 ec 0c             	sub    $0xc,%esp
801018b1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018b4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018b7:	e8 24 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018bc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018c2:	8b 06                	mov    (%esi),%eax
801018c4:	e8 07 fb ff ff       	call   801013d0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018c9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018d0:	00 00 00 
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	e9 62 ff ff ff       	jmp    8010183d <iput+0xbd>
801018db:	90                   	nop
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018e0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	53                   	push   %ebx
801018e4:	83 ec 10             	sub    $0x10,%esp
801018e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018ea:	53                   	push   %ebx
801018eb:	e8 40 fe ff ff       	call   80101730 <iunlock>
  iput(ip);
801018f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018f3:	83 c4 10             	add    $0x10,%esp
}
801018f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018f9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801018fa:	e9 81 fe ff ff       	jmp    80101780 <iput>
801018ff:	90                   	nop

80101900 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	8b 55 08             	mov    0x8(%ebp),%edx
80101906:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101909:	8b 0a                	mov    (%edx),%ecx
8010190b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010190e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101911:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101914:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101918:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010191b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010191f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101923:	8b 52 58             	mov    0x58(%edx),%edx
80101926:	89 50 10             	mov    %edx,0x10(%eax)
}
80101929:	5d                   	pop    %ebp
8010192a:	c3                   	ret    
8010192b:	90                   	nop
8010192c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101930 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	57                   	push   %edi
80101934:	56                   	push   %esi
80101935:	53                   	push   %ebx
80101936:	83 ec 1c             	sub    $0x1c,%esp
80101939:	8b 45 08             	mov    0x8(%ebp),%eax
8010193c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010193f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101942:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101947:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010194a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010194d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101950:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101953:	0f 84 a7 00 00 00    	je     80101a00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101959:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010195c:	8b 40 58             	mov    0x58(%eax),%eax
8010195f:	39 f0                	cmp    %esi,%eax
80101961:	0f 82 c1 00 00 00    	jb     80101a28 <readi+0xf8>
80101967:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010196a:	89 fa                	mov    %edi,%edx
8010196c:	01 f2                	add    %esi,%edx
8010196e:	0f 82 b4 00 00 00    	jb     80101a28 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101974:	89 c1                	mov    %eax,%ecx
80101976:	29 f1                	sub    %esi,%ecx
80101978:	39 d0                	cmp    %edx,%eax
8010197a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010197d:	31 ff                	xor    %edi,%edi
8010197f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101981:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101984:	74 6d                	je     801019f3 <readi+0xc3>
80101986:	8d 76 00             	lea    0x0(%esi),%esi
80101989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101990:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101993:	89 f2                	mov    %esi,%edx
80101995:	c1 ea 09             	shr    $0x9,%edx
80101998:	89 d8                	mov    %ebx,%eax
8010199a:	e8 21 f9 ff ff       	call   801012c0 <bmap>
8010199f:	83 ec 08             	sub    $0x8,%esp
801019a2:	50                   	push   %eax
801019a3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019a5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019aa:	e8 21 e7 ff ff       	call   801000d0 <bread>
801019af:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019b4:	89 f1                	mov    %esi,%ecx
801019b6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019bc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019c2:	29 cb                	sub    %ecx,%ebx
801019c4:	29 f8                	sub    %edi,%eax
801019c6:	39 c3                	cmp    %eax,%ebx
801019c8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019cb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019cf:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d0:	01 df                	add    %ebx,%edi
801019d2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019d4:	50                   	push   %eax
801019d5:	ff 75 e0             	pushl  -0x20(%ebp)
801019d8:	e8 c3 2a 00 00       	call   801044a0 <memmove>
    brelse(bp);
801019dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019e0:	89 14 24             	mov    %edx,(%esp)
801019e3:	e8 f8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019f1:	77 9d                	ja     80101990 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801019f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019f9:	5b                   	pop    %ebx
801019fa:	5e                   	pop    %esi
801019fb:	5f                   	pop    %edi
801019fc:	5d                   	pop    %ebp
801019fd:	c3                   	ret    
801019fe:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a04:	66 83 f8 09          	cmp    $0x9,%ax
80101a08:	77 1e                	ja     80101a28 <readi+0xf8>
80101a0a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a11:	85 c0                	test   %eax,%eax
80101a13:	74 13                	je     80101a28 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a15:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a1b:	5b                   	pop    %ebx
80101a1c:	5e                   	pop    %esi
80101a1d:	5f                   	pop    %edi
80101a1e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a1f:	ff e0                	jmp    *%eax
80101a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a2d:	eb c7                	jmp    801019f6 <readi+0xc6>
80101a2f:	90                   	nop

80101a30 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	57                   	push   %edi
80101a34:	56                   	push   %esi
80101a35:	53                   	push   %ebx
80101a36:	83 ec 1c             	sub    $0x1c,%esp
80101a39:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a47:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a50:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a53:	0f 84 b7 00 00 00    	je     80101b10 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a5c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a5f:	0f 82 eb 00 00 00    	jb     80101b50 <writei+0x120>
80101a65:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a68:	89 f8                	mov    %edi,%eax
80101a6a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a6c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a71:	0f 87 d9 00 00 00    	ja     80101b50 <writei+0x120>
80101a77:	39 c6                	cmp    %eax,%esi
80101a79:	0f 87 d1 00 00 00    	ja     80101b50 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a7f:	85 ff                	test   %edi,%edi
80101a81:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a88:	74 78                	je     80101b02 <writei+0xd2>
80101a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a90:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a93:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a95:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a9a:	c1 ea 09             	shr    $0x9,%edx
80101a9d:	89 f8                	mov    %edi,%eax
80101a9f:	e8 1c f8 ff ff       	call   801012c0 <bmap>
80101aa4:	83 ec 08             	sub    $0x8,%esp
80101aa7:	50                   	push   %eax
80101aa8:	ff 37                	pushl  (%edi)
80101aaa:	e8 21 e6 ff ff       	call   801000d0 <bread>
80101aaf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ab4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ab7:	89 f1                	mov    %esi,%ecx
80101ab9:	83 c4 0c             	add    $0xc,%esp
80101abc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ac2:	29 cb                	sub    %ecx,%ebx
80101ac4:	39 c3                	cmp    %eax,%ebx
80101ac6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ac9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101acd:	53                   	push   %ebx
80101ace:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ad3:	50                   	push   %eax
80101ad4:	e8 c7 29 00 00       	call   801044a0 <memmove>
    log_write(bp);
80101ad9:	89 3c 24             	mov    %edi,(%esp)
80101adc:	e8 2f 12 00 00       	call   80102d10 <log_write>
    brelse(bp);
80101ae1:	89 3c 24             	mov    %edi,(%esp)
80101ae4:	e8 f7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101aec:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101aef:	83 c4 10             	add    $0x10,%esp
80101af2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101af5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101af8:	77 96                	ja     80101a90 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101afa:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101afd:	3b 70 58             	cmp    0x58(%eax),%esi
80101b00:	77 36                	ja     80101b38 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b02:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b08:	5b                   	pop    %ebx
80101b09:	5e                   	pop    %esi
80101b0a:	5f                   	pop    %edi
80101b0b:	5d                   	pop    %ebp
80101b0c:	c3                   	ret    
80101b0d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b14:	66 83 f8 09          	cmp    $0x9,%ax
80101b18:	77 36                	ja     80101b50 <writei+0x120>
80101b1a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b21:	85 c0                	test   %eax,%eax
80101b23:	74 2b                	je     80101b50 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b25:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b2b:	5b                   	pop    %ebx
80101b2c:	5e                   	pop    %esi
80101b2d:	5f                   	pop    %edi
80101b2e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b2f:	ff e0                	jmp    *%eax
80101b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b38:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b3b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b3e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b41:	50                   	push   %eax
80101b42:	e8 59 fa ff ff       	call   801015a0 <iupdate>
80101b47:	83 c4 10             	add    $0x10,%esp
80101b4a:	eb b6                	jmp    80101b02 <writei+0xd2>
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b55:	eb ae                	jmp    80101b05 <writei+0xd5>
80101b57:	89 f6                	mov    %esi,%esi
80101b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b60 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b66:	6a 0e                	push   $0xe
80101b68:	ff 75 0c             	pushl  0xc(%ebp)
80101b6b:	ff 75 08             	pushl  0x8(%ebp)
80101b6e:	e8 ad 29 00 00       	call   80104520 <strncmp>
}
80101b73:	c9                   	leave  
80101b74:	c3                   	ret    
80101b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	57                   	push   %edi
80101b84:	56                   	push   %esi
80101b85:	53                   	push   %ebx
80101b86:	83 ec 1c             	sub    $0x1c,%esp
80101b89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b8c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b91:	0f 85 80 00 00 00    	jne    80101c17 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b97:	8b 53 58             	mov    0x58(%ebx),%edx
80101b9a:	31 ff                	xor    %edi,%edi
80101b9c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b9f:	85 d2                	test   %edx,%edx
80101ba1:	75 0d                	jne    80101bb0 <dirlookup+0x30>
80101ba3:	eb 5b                	jmp    80101c00 <dirlookup+0x80>
80101ba5:	8d 76 00             	lea    0x0(%esi),%esi
80101ba8:	83 c7 10             	add    $0x10,%edi
80101bab:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bae:	76 50                	jbe    80101c00 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bb0:	6a 10                	push   $0x10
80101bb2:	57                   	push   %edi
80101bb3:	56                   	push   %esi
80101bb4:	53                   	push   %ebx
80101bb5:	e8 76 fd ff ff       	call   80101930 <readi>
80101bba:	83 c4 10             	add    $0x10,%esp
80101bbd:	83 f8 10             	cmp    $0x10,%eax
80101bc0:	75 48                	jne    80101c0a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101bc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bc7:	74 df                	je     80101ba8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bc9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bcc:	83 ec 04             	sub    $0x4,%esp
80101bcf:	6a 0e                	push   $0xe
80101bd1:	50                   	push   %eax
80101bd2:	ff 75 0c             	pushl  0xc(%ebp)
80101bd5:	e8 46 29 00 00       	call   80104520 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bda:	83 c4 10             	add    $0x10,%esp
80101bdd:	85 c0                	test   %eax,%eax
80101bdf:	75 c7                	jne    80101ba8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101be1:	8b 45 10             	mov    0x10(%ebp),%eax
80101be4:	85 c0                	test   %eax,%eax
80101be6:	74 05                	je     80101bed <dirlookup+0x6d>
        *poff = off;
80101be8:	8b 45 10             	mov    0x10(%ebp),%eax
80101beb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101bed:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101bf1:	8b 03                	mov    (%ebx),%eax
80101bf3:	e8 f8 f5 ff ff       	call   801011f0 <iget>
    }
  }

  return 0;
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
80101bff:	c3                   	ret    
80101c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c03:	31 c0                	xor    %eax,%eax
}
80101c05:	5b                   	pop    %ebx
80101c06:	5e                   	pop    %esi
80101c07:	5f                   	pop    %edi
80101c08:	5d                   	pop    %ebp
80101c09:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c0a:	83 ec 0c             	sub    $0xc,%esp
80101c0d:	68 d9 71 10 80       	push   $0x801071d9
80101c12:	e8 59 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c17:	83 ec 0c             	sub    $0xc,%esp
80101c1a:	68 c7 71 10 80       	push   $0x801071c7
80101c1f:	e8 4c e7 ff ff       	call   80100370 <panic>
80101c24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c30 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	57                   	push   %edi
80101c34:	56                   	push   %esi
80101c35:	53                   	push   %ebx
80101c36:	89 cf                	mov    %ecx,%edi
80101c38:	89 c3                	mov    %eax,%ebx
80101c3a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c3d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c40:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c43:	0f 84 53 01 00 00    	je     80101d9c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c49:	e8 12 1b 00 00       	call   80103760 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c4e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c51:	8b 70 6c             	mov    0x6c(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c54:	68 e0 09 11 80       	push   $0x801109e0
80101c59:	e8 22 26 00 00       	call   80104280 <acquire>
  ip->ref++;
80101c5e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c62:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c69:	e8 32 27 00 00       	call   801043a0 <release>
80101c6e:	83 c4 10             	add    $0x10,%esp
80101c71:	eb 08                	jmp    80101c7b <namex+0x4b>
80101c73:	90                   	nop
80101c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c78:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c7b:	0f b6 03             	movzbl (%ebx),%eax
80101c7e:	3c 2f                	cmp    $0x2f,%al
80101c80:	74 f6                	je     80101c78 <namex+0x48>
    path++;
  if(*path == 0)
80101c82:	84 c0                	test   %al,%al
80101c84:	0f 84 e3 00 00 00    	je     80101d6d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c8a:	0f b6 03             	movzbl (%ebx),%eax
80101c8d:	89 da                	mov    %ebx,%edx
80101c8f:	84 c0                	test   %al,%al
80101c91:	0f 84 ac 00 00 00    	je     80101d43 <namex+0x113>
80101c97:	3c 2f                	cmp    $0x2f,%al
80101c99:	75 09                	jne    80101ca4 <namex+0x74>
80101c9b:	e9 a3 00 00 00       	jmp    80101d43 <namex+0x113>
80101ca0:	84 c0                	test   %al,%al
80101ca2:	74 0a                	je     80101cae <namex+0x7e>
    path++;
80101ca4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101ca7:	0f b6 02             	movzbl (%edx),%eax
80101caa:	3c 2f                	cmp    $0x2f,%al
80101cac:	75 f2                	jne    80101ca0 <namex+0x70>
80101cae:	89 d1                	mov    %edx,%ecx
80101cb0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cb2:	83 f9 0d             	cmp    $0xd,%ecx
80101cb5:	0f 8e 8d 00 00 00    	jle    80101d48 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cbb:	83 ec 04             	sub    $0x4,%esp
80101cbe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cc1:	6a 0e                	push   $0xe
80101cc3:	53                   	push   %ebx
80101cc4:	57                   	push   %edi
80101cc5:	e8 d6 27 00 00       	call   801044a0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101ccd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cd0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cd2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cd5:	75 11                	jne    80101ce8 <namex+0xb8>
80101cd7:	89 f6                	mov    %esi,%esi
80101cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101ce0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101ce3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ce6:	74 f8                	je     80101ce0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ce8:	83 ec 0c             	sub    $0xc,%esp
80101ceb:	56                   	push   %esi
80101cec:	e8 5f f9 ff ff       	call   80101650 <ilock>
    if(ip->type != T_DIR){
80101cf1:	83 c4 10             	add    $0x10,%esp
80101cf4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101cf9:	0f 85 7f 00 00 00    	jne    80101d7e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101cff:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d02:	85 d2                	test   %edx,%edx
80101d04:	74 09                	je     80101d0f <namex+0xdf>
80101d06:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d09:	0f 84 a3 00 00 00    	je     80101db2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d0f:	83 ec 04             	sub    $0x4,%esp
80101d12:	6a 00                	push   $0x0
80101d14:	57                   	push   %edi
80101d15:	56                   	push   %esi
80101d16:	e8 65 fe ff ff       	call   80101b80 <dirlookup>
80101d1b:	83 c4 10             	add    $0x10,%esp
80101d1e:	85 c0                	test   %eax,%eax
80101d20:	74 5c                	je     80101d7e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d22:	83 ec 0c             	sub    $0xc,%esp
80101d25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d28:	56                   	push   %esi
80101d29:	e8 02 fa ff ff       	call   80101730 <iunlock>
  iput(ip);
80101d2e:	89 34 24             	mov    %esi,(%esp)
80101d31:	e8 4a fa ff ff       	call   80101780 <iput>
80101d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d39:	83 c4 10             	add    $0x10,%esp
80101d3c:	89 c6                	mov    %eax,%esi
80101d3e:	e9 38 ff ff ff       	jmp    80101c7b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d43:	31 c9                	xor    %ecx,%ecx
80101d45:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d48:	83 ec 04             	sub    $0x4,%esp
80101d4b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d4e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d51:	51                   	push   %ecx
80101d52:	53                   	push   %ebx
80101d53:	57                   	push   %edi
80101d54:	e8 47 27 00 00       	call   801044a0 <memmove>
    name[len] = 0;
80101d59:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d5f:	83 c4 10             	add    $0x10,%esp
80101d62:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d66:	89 d3                	mov    %edx,%ebx
80101d68:	e9 65 ff ff ff       	jmp    80101cd2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d70:	85 c0                	test   %eax,%eax
80101d72:	75 54                	jne    80101dc8 <namex+0x198>
80101d74:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d79:	5b                   	pop    %ebx
80101d7a:	5e                   	pop    %esi
80101d7b:	5f                   	pop    %edi
80101d7c:	5d                   	pop    %ebp
80101d7d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d7e:	83 ec 0c             	sub    $0xc,%esp
80101d81:	56                   	push   %esi
80101d82:	e8 a9 f9 ff ff       	call   80101730 <iunlock>
  iput(ip);
80101d87:	89 34 24             	mov    %esi,(%esp)
80101d8a:	e8 f1 f9 ff ff       	call   80101780 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d8f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d95:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d97:	5b                   	pop    %ebx
80101d98:	5e                   	pop    %esi
80101d99:	5f                   	pop    %edi
80101d9a:	5d                   	pop    %ebp
80101d9b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101d9c:	ba 01 00 00 00       	mov    $0x1,%edx
80101da1:	b8 01 00 00 00       	mov    $0x1,%eax
80101da6:	e8 45 f4 ff ff       	call   801011f0 <iget>
80101dab:	89 c6                	mov    %eax,%esi
80101dad:	e9 c9 fe ff ff       	jmp    80101c7b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101db2:	83 ec 0c             	sub    $0xc,%esp
80101db5:	56                   	push   %esi
80101db6:	e8 75 f9 ff ff       	call   80101730 <iunlock>
      return ip;
80101dbb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101dc1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dc3:	5b                   	pop    %ebx
80101dc4:	5e                   	pop    %esi
80101dc5:	5f                   	pop    %edi
80101dc6:	5d                   	pop    %ebp
80101dc7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101dc8:	83 ec 0c             	sub    $0xc,%esp
80101dcb:	56                   	push   %esi
80101dcc:	e8 af f9 ff ff       	call   80101780 <iput>
    return 0;
80101dd1:	83 c4 10             	add    $0x10,%esp
80101dd4:	31 c0                	xor    %eax,%eax
80101dd6:	eb 9e                	jmp    80101d76 <namex+0x146>
80101dd8:	90                   	nop
80101dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101de0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101de0:	55                   	push   %ebp
80101de1:	89 e5                	mov    %esp,%ebp
80101de3:	57                   	push   %edi
80101de4:	56                   	push   %esi
80101de5:	53                   	push   %ebx
80101de6:	83 ec 20             	sub    $0x20,%esp
80101de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dec:	6a 00                	push   $0x0
80101dee:	ff 75 0c             	pushl  0xc(%ebp)
80101df1:	53                   	push   %ebx
80101df2:	e8 89 fd ff ff       	call   80101b80 <dirlookup>
80101df7:	83 c4 10             	add    $0x10,%esp
80101dfa:	85 c0                	test   %eax,%eax
80101dfc:	75 67                	jne    80101e65 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dfe:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e01:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e04:	85 ff                	test   %edi,%edi
80101e06:	74 29                	je     80101e31 <dirlink+0x51>
80101e08:	31 ff                	xor    %edi,%edi
80101e0a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e0d:	eb 09                	jmp    80101e18 <dirlink+0x38>
80101e0f:	90                   	nop
80101e10:	83 c7 10             	add    $0x10,%edi
80101e13:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e16:	76 19                	jbe    80101e31 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e18:	6a 10                	push   $0x10
80101e1a:	57                   	push   %edi
80101e1b:	56                   	push   %esi
80101e1c:	53                   	push   %ebx
80101e1d:	e8 0e fb ff ff       	call   80101930 <readi>
80101e22:	83 c4 10             	add    $0x10,%esp
80101e25:	83 f8 10             	cmp    $0x10,%eax
80101e28:	75 4e                	jne    80101e78 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e2f:	75 df                	jne    80101e10 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e34:	83 ec 04             	sub    $0x4,%esp
80101e37:	6a 0e                	push   $0xe
80101e39:	ff 75 0c             	pushl  0xc(%ebp)
80101e3c:	50                   	push   %eax
80101e3d:	e8 4e 27 00 00       	call   80104590 <strncpy>
  de.inum = inum;
80101e42:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e45:	6a 10                	push   $0x10
80101e47:	57                   	push   %edi
80101e48:	56                   	push   %esi
80101e49:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e4a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e4e:	e8 dd fb ff ff       	call   80101a30 <writei>
80101e53:	83 c4 20             	add    $0x20,%esp
80101e56:	83 f8 10             	cmp    $0x10,%eax
80101e59:	75 2a                	jne    80101e85 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e5b:	31 c0                	xor    %eax,%eax
}
80101e5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e60:	5b                   	pop    %ebx
80101e61:	5e                   	pop    %esi
80101e62:	5f                   	pop    %edi
80101e63:	5d                   	pop    %ebp
80101e64:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e65:	83 ec 0c             	sub    $0xc,%esp
80101e68:	50                   	push   %eax
80101e69:	e8 12 f9 ff ff       	call   80101780 <iput>
    return -1;
80101e6e:	83 c4 10             	add    $0x10,%esp
80101e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e76:	eb e5                	jmp    80101e5d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e78:	83 ec 0c             	sub    $0xc,%esp
80101e7b:	68 e8 71 10 80       	push   $0x801071e8
80101e80:	e8 eb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	68 e6 77 10 80       	push   $0x801077e6
80101e8d:	e8 de e4 ff ff       	call   80100370 <panic>
80101e92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ea0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ea0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ea1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ea3:	89 e5                	mov    %esp,%ebp
80101ea5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80101eab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101eae:	e8 7d fd ff ff       	call   80101c30 <namex>
}
80101eb3:	c9                   	leave  
80101eb4:	c3                   	ret    
80101eb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ec0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ec1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ec6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ec8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101ecb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ece:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101ecf:	e9 5c fd ff ff       	jmp    80101c30 <namex>
80101ed4:	66 90                	xchg   %ax,%ax
80101ed6:	66 90                	xchg   %ax,%ax
80101ed8:	66 90                	xchg   %ax,%ax
80101eda:	66 90                	xchg   %ax,%ax
80101edc:	66 90                	xchg   %ax,%ax
80101ede:	66 90                	xchg   %ax,%ax

80101ee0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ee0:	55                   	push   %ebp
  if(b == 0)
80101ee1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ee3:	89 e5                	mov    %esp,%ebp
80101ee5:	56                   	push   %esi
80101ee6:	53                   	push   %ebx
  if(b == 0)
80101ee7:	0f 84 ad 00 00 00    	je     80101f9a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101eed:	8b 58 08             	mov    0x8(%eax),%ebx
80101ef0:	89 c1                	mov    %eax,%ecx
80101ef2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101ef8:	0f 87 8f 00 00 00    	ja     80101f8d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101efe:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f03:	90                   	nop
80101f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f08:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f09:	83 e0 c0             	and    $0xffffffc0,%eax
80101f0c:	3c 40                	cmp    $0x40,%al
80101f0e:	75 f8                	jne    80101f08 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f10:	31 f6                	xor    %esi,%esi
80101f12:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f17:	89 f0                	mov    %esi,%eax
80101f19:	ee                   	out    %al,(%dx)
80101f1a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f1f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f24:	ee                   	out    %al,(%dx)
80101f25:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f2a:	89 d8                	mov    %ebx,%eax
80101f2c:	ee                   	out    %al,(%dx)
80101f2d:	89 d8                	mov    %ebx,%eax
80101f2f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f34:	c1 f8 08             	sar    $0x8,%eax
80101f37:	ee                   	out    %al,(%dx)
80101f38:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f3d:	89 f0                	mov    %esi,%eax
80101f3f:	ee                   	out    %al,(%dx)
80101f40:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f44:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f49:	83 e0 01             	and    $0x1,%eax
80101f4c:	c1 e0 04             	shl    $0x4,%eax
80101f4f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f52:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f53:	f6 01 04             	testb  $0x4,(%ecx)
80101f56:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f5b:	75 13                	jne    80101f70 <idestart+0x90>
80101f5d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f62:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f63:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f66:	5b                   	pop    %ebx
80101f67:	5e                   	pop    %esi
80101f68:	5d                   	pop    %ebp
80101f69:	c3                   	ret    
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f70:	b8 30 00 00 00       	mov    $0x30,%eax
80101f75:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f76:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f7b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f7e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f83:	fc                   	cld    
80101f84:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f89:	5b                   	pop    %ebx
80101f8a:	5e                   	pop    %esi
80101f8b:	5d                   	pop    %ebp
80101f8c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f8d:	83 ec 0c             	sub    $0xc,%esp
80101f90:	68 54 72 10 80       	push   $0x80107254
80101f95:	e8 d6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101f9a:	83 ec 0c             	sub    $0xc,%esp
80101f9d:	68 4b 72 10 80       	push   $0x8010724b
80101fa2:	e8 c9 e3 ff ff       	call   80100370 <panic>
80101fa7:	89 f6                	mov    %esi,%esi
80101fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fb0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fb0:	55                   	push   %ebp
80101fb1:	89 e5                	mov    %esp,%ebp
80101fb3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fb6:	68 66 72 10 80       	push   $0x80107266
80101fbb:	68 80 a5 10 80       	push   $0x8010a580
80101fc0:	e8 bb 21 00 00       	call   80104180 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fc5:	58                   	pop    %eax
80101fc6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101fcb:	5a                   	pop    %edx
80101fcc:	83 e8 01             	sub    $0x1,%eax
80101fcf:	50                   	push   %eax
80101fd0:	6a 0e                	push   $0xe
80101fd2:	e8 a9 02 00 00       	call   80102280 <ioapicenable>
80101fd7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fda:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fdf:	90                   	nop
80101fe0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fe1:	83 e0 c0             	and    $0xffffffc0,%eax
80101fe4:	3c 40                	cmp    $0x40,%al
80101fe6:	75 f8                	jne    80101fe0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fe8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fed:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101ff2:	ee                   	out    %al,(%dx)
80101ff3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ff8:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ffd:	eb 06                	jmp    80102005 <ideinit+0x55>
80101fff:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102000:	83 e9 01             	sub    $0x1,%ecx
80102003:	74 0f                	je     80102014 <ideinit+0x64>
80102005:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102006:	84 c0                	test   %al,%al
80102008:	74 f6                	je     80102000 <ideinit+0x50>
      havedisk1 = 1;
8010200a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102011:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102014:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102019:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010201e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010201f:	c9                   	leave  
80102020:	c3                   	ret    
80102021:	eb 0d                	jmp    80102030 <ideintr>
80102023:	90                   	nop
80102024:	90                   	nop
80102025:	90                   	nop
80102026:	90                   	nop
80102027:	90                   	nop
80102028:	90                   	nop
80102029:	90                   	nop
8010202a:	90                   	nop
8010202b:	90                   	nop
8010202c:	90                   	nop
8010202d:	90                   	nop
8010202e:	90                   	nop
8010202f:	90                   	nop

80102030 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
80102036:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102039:	68 80 a5 10 80       	push   $0x8010a580
8010203e:	e8 3d 22 00 00       	call   80104280 <acquire>

  if((b = idequeue) == 0){
80102043:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102049:	83 c4 10             	add    $0x10,%esp
8010204c:	85 db                	test   %ebx,%ebx
8010204e:	74 34                	je     80102084 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102050:	8b 43 58             	mov    0x58(%ebx),%eax
80102053:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102058:	8b 33                	mov    (%ebx),%esi
8010205a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102060:	74 3e                	je     801020a0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102062:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102065:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102068:	83 ce 02             	or     $0x2,%esi
8010206b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010206d:	53                   	push   %ebx
8010206e:	e8 4d 1e 00 00       	call   80103ec0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102073:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102078:	83 c4 10             	add    $0x10,%esp
8010207b:	85 c0                	test   %eax,%eax
8010207d:	74 05                	je     80102084 <ideintr+0x54>
    idestart(idequeue);
8010207f:	e8 5c fe ff ff       	call   80101ee0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102084:	83 ec 0c             	sub    $0xc,%esp
80102087:	68 80 a5 10 80       	push   $0x8010a580
8010208c:	e8 0f 23 00 00       	call   801043a0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102091:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102094:	5b                   	pop    %ebx
80102095:	5e                   	pop    %esi
80102096:	5f                   	pop    %edi
80102097:	5d                   	pop    %ebp
80102098:	c3                   	ret    
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020a5:	8d 76 00             	lea    0x0(%esi),%esi
801020a8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a9:	89 c1                	mov    %eax,%ecx
801020ab:	83 e1 c0             	and    $0xffffffc0,%ecx
801020ae:	80 f9 40             	cmp    $0x40,%cl
801020b1:	75 f5                	jne    801020a8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020b3:	a8 21                	test   $0x21,%al
801020b5:	75 ab                	jne    80102062 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020b7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020ba:	b9 80 00 00 00       	mov    $0x80,%ecx
801020bf:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020c4:	fc                   	cld    
801020c5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020c7:	8b 33                	mov    (%ebx),%esi
801020c9:	eb 97                	jmp    80102062 <ideintr+0x32>
801020cb:	90                   	nop
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	53                   	push   %ebx
801020d4:	83 ec 10             	sub    $0x10,%esp
801020d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020da:	8d 43 0c             	lea    0xc(%ebx),%eax
801020dd:	50                   	push   %eax
801020de:	e8 6d 20 00 00       	call   80104150 <holdingsleep>
801020e3:	83 c4 10             	add    $0x10,%esp
801020e6:	85 c0                	test   %eax,%eax
801020e8:	0f 84 ad 00 00 00    	je     8010219b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801020ee:	8b 03                	mov    (%ebx),%eax
801020f0:	83 e0 06             	and    $0x6,%eax
801020f3:	83 f8 02             	cmp    $0x2,%eax
801020f6:	0f 84 b9 00 00 00    	je     801021b5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801020fc:	8b 53 04             	mov    0x4(%ebx),%edx
801020ff:	85 d2                	test   %edx,%edx
80102101:	74 0d                	je     80102110 <iderw+0x40>
80102103:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102108:	85 c0                	test   %eax,%eax
8010210a:	0f 84 98 00 00 00    	je     801021a8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102110:	83 ec 0c             	sub    $0xc,%esp
80102113:	68 80 a5 10 80       	push   $0x8010a580
80102118:	e8 63 21 00 00       	call   80104280 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010211d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102123:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102126:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010212d:	85 d2                	test   %edx,%edx
8010212f:	75 09                	jne    8010213a <iderw+0x6a>
80102131:	eb 58                	jmp    8010218b <iderw+0xbb>
80102133:	90                   	nop
80102134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102138:	89 c2                	mov    %eax,%edx
8010213a:	8b 42 58             	mov    0x58(%edx),%eax
8010213d:	85 c0                	test   %eax,%eax
8010213f:	75 f7                	jne    80102138 <iderw+0x68>
80102141:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102144:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102146:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010214c:	74 44                	je     80102192 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010214e:	8b 03                	mov    (%ebx),%eax
80102150:	83 e0 06             	and    $0x6,%eax
80102153:	83 f8 02             	cmp    $0x2,%eax
80102156:	74 23                	je     8010217b <iderw+0xab>
80102158:	90                   	nop
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102160:	83 ec 08             	sub    $0x8,%esp
80102163:	68 80 a5 10 80       	push   $0x8010a580
80102168:	53                   	push   %ebx
80102169:	e8 a2 1b 00 00       	call   80103d10 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 c4 10             	add    $0x10,%esp
80102173:	83 e0 06             	and    $0x6,%eax
80102176:	83 f8 02             	cmp    $0x2,%eax
80102179:	75 e5                	jne    80102160 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010217b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102182:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102185:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102186:	e9 15 22 00 00       	jmp    801043a0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010218b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102190:	eb b2                	jmp    80102144 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102192:	89 d8                	mov    %ebx,%eax
80102194:	e8 47 fd ff ff       	call   80101ee0 <idestart>
80102199:	eb b3                	jmp    8010214e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010219b:	83 ec 0c             	sub    $0xc,%esp
8010219e:	68 6a 72 10 80       	push   $0x8010726a
801021a3:	e8 c8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 95 72 10 80       	push   $0x80107295
801021b0:	e8 bb e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 80 72 10 80       	push   $0x80107280
801021bd:	e8 ae e1 ff ff       	call   80100370 <panic>
801021c2:	66 90                	xchg   %ax,%ax
801021c4:	66 90                	xchg   %ax,%ax
801021c6:	66 90                	xchg   %ax,%ax
801021c8:	66 90                	xchg   %ax,%ax
801021ca:	66 90                	xchg   %ax,%ax
801021cc:	66 90                	xchg   %ax,%ax
801021ce:	66 90                	xchg   %ax,%ax

801021d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021d8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021db:	89 e5                	mov    %esp,%ebp
801021dd:	56                   	push   %esi
801021de:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021e6:	00 00 00 
  return ioapic->data;
801021e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801021ef:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801021f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801021fe:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102205:	89 f0                	mov    %esi,%eax
80102207:	c1 e8 10             	shr    $0x10,%eax
8010220a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010220d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102210:	c1 e8 18             	shr    $0x18,%eax
80102213:	39 d0                	cmp    %edx,%eax
80102215:	74 16                	je     8010222d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102217:	83 ec 0c             	sub    $0xc,%esp
8010221a:	68 b4 72 10 80       	push   $0x801072b4
8010221f:	e8 3c e4 ff ff       	call   80100660 <cprintf>
80102224:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010222a:	83 c4 10             	add    $0x10,%esp
8010222d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102230:	ba 10 00 00 00       	mov    $0x10,%edx
80102235:	b8 20 00 00 00       	mov    $0x20,%eax
8010223a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102240:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102242:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102248:	89 c3                	mov    %eax,%ebx
8010224a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102250:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102253:	89 59 10             	mov    %ebx,0x10(%ecx)
80102256:	8d 5a 01             	lea    0x1(%edx),%ebx
80102259:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010225c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010225e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102260:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102266:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010226d:	75 d1                	jne    80102240 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010226f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102272:	5b                   	pop    %ebx
80102273:	5e                   	pop    %esi
80102274:	5d                   	pop    %ebp
80102275:	c3                   	ret    
80102276:	8d 76 00             	lea    0x0(%esi),%esi
80102279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102280 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102280:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102281:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102287:	89 e5                	mov    %esp,%ebp
80102289:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010228c:	8d 50 20             	lea    0x20(%eax),%edx
8010228f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102293:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102295:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010229b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010229e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022a1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022a6:	a1 34 26 11 80       	mov    0x80112634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022ab:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022ae:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022b1:	5d                   	pop    %ebp
801022b2:	c3                   	ret    
801022b3:	66 90                	xchg   %ax,%ax
801022b5:	66 90                	xchg   %ax,%ax
801022b7:	66 90                	xchg   %ax,%ax
801022b9:	66 90                	xchg   %ax,%ax
801022bb:	66 90                	xchg   %ax,%ax
801022bd:	66 90                	xchg   %ax,%ax
801022bf:	90                   	nop

801022c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	53                   	push   %ebx
801022c4:	83 ec 04             	sub    $0x4,%esp
801022c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022d0:	75 70                	jne    80102342 <kfree+0x82>
801022d2:	81 fb f4 58 11 80    	cmp    $0x801158f4,%ebx
801022d8:	72 68                	jb     80102342 <kfree+0x82>
801022da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022e5:	77 5b                	ja     80102342 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022e7:	83 ec 04             	sub    $0x4,%esp
801022ea:	68 00 10 00 00       	push   $0x1000
801022ef:	6a 01                	push   $0x1
801022f1:	53                   	push   %ebx
801022f2:	e8 f9 20 00 00       	call   801043f0 <memset>

  if(kmem.use_lock)
801022f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801022fd:	83 c4 10             	add    $0x10,%esp
80102300:	85 d2                	test   %edx,%edx
80102302:	75 2c                	jne    80102330 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102304:	a1 78 26 11 80       	mov    0x80112678,%eax
80102309:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010230b:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102310:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102316:	85 c0                	test   %eax,%eax
80102318:	75 06                	jne    80102320 <kfree+0x60>
    release(&kmem.lock);
}
8010231a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010231d:	c9                   	leave  
8010231e:	c3                   	ret    
8010231f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102320:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102327:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010232a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010232b:	e9 70 20 00 00       	jmp    801043a0 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 40 26 11 80       	push   $0x80112640
80102338:	e8 43 1f 00 00       	call   80104280 <acquire>
8010233d:	83 c4 10             	add    $0x10,%esp
80102340:	eb c2                	jmp    80102304 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102342:	83 ec 0c             	sub    $0xc,%esp
80102345:	68 e6 72 10 80       	push   $0x801072e6
8010234a:	e8 21 e0 ff ff       	call   80100370 <panic>
8010234f:	90                   	nop

80102350 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	56                   	push   %esi
80102354:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102355:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102358:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010235b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102361:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102367:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010236d:	39 de                	cmp    %ebx,%esi
8010236f:	72 23                	jb     80102394 <freerange+0x44>
80102371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102378:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010237e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102381:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102387:	50                   	push   %eax
80102388:	e8 33 ff ff ff       	call   801022c0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	39 f3                	cmp    %esi,%ebx
80102392:	76 e4                	jbe    80102378 <freerange+0x28>
    kfree(p);
}
80102394:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102397:	5b                   	pop    %ebx
80102398:	5e                   	pop    %esi
80102399:	5d                   	pop    %ebp
8010239a:	c3                   	ret    
8010239b:	90                   	nop
8010239c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023a0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023a8:	83 ec 08             	sub    $0x8,%esp
801023ab:	68 ec 72 10 80       	push   $0x801072ec
801023b0:	68 40 26 11 80       	push   $0x80112640
801023b5:	e8 c6 1d 00 00       	call   80104180 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023bd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023c0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023c7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ca:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023dc:	39 de                	cmp    %ebx,%esi
801023de:	72 1c                	jb     801023fc <kinit1+0x5c>
    kfree(p);
801023e0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023e6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023ef:	50                   	push   %eax
801023f0:	e8 cb fe ff ff       	call   801022c0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f5:	83 c4 10             	add    $0x10,%esp
801023f8:	39 de                	cmp    %ebx,%esi
801023fa:	73 e4                	jae    801023e0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801023fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023ff:	5b                   	pop    %ebx
80102400:	5e                   	pop    %esi
80102401:	5d                   	pop    %ebp
80102402:	c3                   	ret    
80102403:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102410 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102415:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102418:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010241b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102421:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102427:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242d:	39 de                	cmp    %ebx,%esi
8010242f:	72 23                	jb     80102454 <kinit2+0x44>
80102431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102438:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010243e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102441:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102447:	50                   	push   %eax
80102448:	e8 73 fe ff ff       	call   801022c0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	39 de                	cmp    %ebx,%esi
80102452:	73 e4                	jae    80102438 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102454:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010245b:	00 00 00 
}
8010245e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102461:	5b                   	pop    %ebx
80102462:	5e                   	pop    %esi
80102463:	5d                   	pop    %ebp
80102464:	c3                   	ret    
80102465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	53                   	push   %ebx
80102474:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102477:	a1 74 26 11 80       	mov    0x80112674,%eax
8010247c:	85 c0                	test   %eax,%eax
8010247e:	75 30                	jne    801024b0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102480:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102486:	85 db                	test   %ebx,%ebx
80102488:	74 1c                	je     801024a6 <kalloc+0x36>
    kmem.freelist = r->next;
8010248a:	8b 13                	mov    (%ebx),%edx
8010248c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102492:	85 c0                	test   %eax,%eax
80102494:	74 10                	je     801024a6 <kalloc+0x36>
    release(&kmem.lock);
80102496:	83 ec 0c             	sub    $0xc,%esp
80102499:	68 40 26 11 80       	push   $0x80112640
8010249e:	e8 fd 1e 00 00       	call   801043a0 <release>
801024a3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024a6:	89 d8                	mov    %ebx,%eax
801024a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024ab:	c9                   	leave  
801024ac:	c3                   	ret    
801024ad:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024b0:	83 ec 0c             	sub    $0xc,%esp
801024b3:	68 40 26 11 80       	push   $0x80112640
801024b8:	e8 c3 1d 00 00       	call   80104280 <acquire>
  r = kmem.freelist;
801024bd:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024c3:	83 c4 10             	add    $0x10,%esp
801024c6:	a1 74 26 11 80       	mov    0x80112674,%eax
801024cb:	85 db                	test   %ebx,%ebx
801024cd:	75 bb                	jne    8010248a <kalloc+0x1a>
801024cf:	eb c1                	jmp    80102492 <kalloc+0x22>
801024d1:	66 90                	xchg   %ax,%ax
801024d3:	66 90                	xchg   %ax,%ax
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	66 90                	xchg   %ax,%ax
801024d9:	66 90                	xchg   %ax,%ax
801024db:	66 90                	xchg   %ax,%ax
801024dd:	66 90                	xchg   %ax,%ax
801024df:	90                   	nop

801024e0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801024e0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024e1:	ba 64 00 00 00       	mov    $0x64,%edx
801024e6:	89 e5                	mov    %esp,%ebp
801024e8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024e9:	a8 01                	test   $0x1,%al
801024eb:	0f 84 af 00 00 00    	je     801025a0 <kbdgetc+0xc0>
801024f1:	ba 60 00 00 00       	mov    $0x60,%edx
801024f6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801024f7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801024fa:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102500:	74 7e                	je     80102580 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102502:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102504:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010250a:	79 24                	jns    80102530 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010250c:	f6 c1 40             	test   $0x40,%cl
8010250f:	75 05                	jne    80102516 <kbdgetc+0x36>
80102511:	89 c2                	mov    %eax,%edx
80102513:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102516:	0f b6 82 20 74 10 80 	movzbl -0x7fef8be0(%edx),%eax
8010251d:	83 c8 40             	or     $0x40,%eax
80102520:	0f b6 c0             	movzbl %al,%eax
80102523:	f7 d0                	not    %eax
80102525:	21 c8                	and    %ecx,%eax
80102527:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010252c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010252e:	5d                   	pop    %ebp
8010252f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102530:	f6 c1 40             	test   $0x40,%cl
80102533:	74 09                	je     8010253e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102535:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102538:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010253b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010253e:	0f b6 82 20 74 10 80 	movzbl -0x7fef8be0(%edx),%eax
80102545:	09 c1                	or     %eax,%ecx
80102547:	0f b6 82 20 73 10 80 	movzbl -0x7fef8ce0(%edx),%eax
8010254e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102550:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102552:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102558:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010255b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010255e:	8b 04 85 00 73 10 80 	mov    -0x7fef8d00(,%eax,4),%eax
80102565:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102569:	74 c3                	je     8010252e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010256b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010256e:	83 fa 19             	cmp    $0x19,%edx
80102571:	77 1d                	ja     80102590 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102573:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102576:	5d                   	pop    %ebp
80102577:	c3                   	ret    
80102578:	90                   	nop
80102579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102580:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102582:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102589:	5d                   	pop    %ebp
8010258a:	c3                   	ret    
8010258b:	90                   	nop
8010258c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102590:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102593:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102596:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102597:	83 f9 19             	cmp    $0x19,%ecx
8010259a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010259d:	c3                   	ret    
8010259e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a5:	5d                   	pop    %ebp
801025a6:	c3                   	ret    
801025a7:	89 f6                	mov    %esi,%esi
801025a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025b0 <kbdintr>:

void
kbdintr(void)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025b6:	68 e0 24 10 80       	push   $0x801024e0
801025bb:	e8 30 e2 ff ff       	call   801007f0 <consoleintr>
}
801025c0:	83 c4 10             	add    $0x10,%esp
801025c3:	c9                   	leave  
801025c4:	c3                   	ret    
801025c5:	66 90                	xchg   %ax,%ax
801025c7:	66 90                	xchg   %ax,%ax
801025c9:	66 90                	xchg   %ax,%ax
801025cb:	66 90                	xchg   %ax,%ax
801025cd:	66 90                	xchg   %ax,%ax
801025cf:	90                   	nop

801025d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801025d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801025d5:	55                   	push   %ebp
801025d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025d8:	85 c0                	test   %eax,%eax
801025da:	0f 84 c8 00 00 00    	je     801026a8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801025e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025ea:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801025f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025f7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102601:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102604:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102607:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010260e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102611:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102614:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010261b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010261e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102621:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102628:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010262b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010262e:	8b 50 30             	mov    0x30(%eax),%edx
80102631:	c1 ea 10             	shr    $0x10,%edx
80102634:	80 fa 03             	cmp    $0x3,%dl
80102637:	77 77                	ja     801026b0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102639:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102640:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102643:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102646:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010264d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102650:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102653:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010265a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010265d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102660:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102667:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010266d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102674:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102677:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102681:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102684:	8b 50 20             	mov    0x20(%eax),%edx
80102687:	89 f6                	mov    %esi,%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102690:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102696:	80 e6 10             	and    $0x10,%dh
80102699:	75 f5                	jne    80102690 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026a2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026a8:	5d                   	pop    %ebp
801026a9:	c3                   	ret    
801026aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026b7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ba:	8b 50 20             	mov    0x20(%eax),%edx
801026bd:	e9 77 ff ff ff       	jmp    80102639 <lapicinit+0x69>
801026c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026d0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801026d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801026d5:	55                   	push   %ebp
801026d6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801026d8:	85 c0                	test   %eax,%eax
801026da:	74 0c                	je     801026e8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801026dc:	8b 40 20             	mov    0x20(%eax),%eax
}
801026df:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801026e0:	c1 e8 18             	shr    $0x18,%eax
}
801026e3:	c3                   	ret    
801026e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801026e8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801026ea:	5d                   	pop    %ebp
801026eb:	c3                   	ret    
801026ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801026f0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801026f5:	55                   	push   %ebp
801026f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801026f8:	85 c0                	test   %eax,%eax
801026fa:	74 0d                	je     80102709 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102703:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102706:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102709:	5d                   	pop    %ebp
8010270a:	c3                   	ret    
8010270b:	90                   	nop
8010270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102710 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
}
80102713:	5d                   	pop    %ebp
80102714:	c3                   	ret    
80102715:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102720 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102720:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102721:	ba 70 00 00 00       	mov    $0x70,%edx
80102726:	b8 0f 00 00 00       	mov    $0xf,%eax
8010272b:	89 e5                	mov    %esp,%ebp
8010272d:	53                   	push   %ebx
8010272e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102731:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102734:	ee                   	out    %al,(%dx)
80102735:	ba 71 00 00 00       	mov    $0x71,%edx
8010273a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010273f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102740:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102742:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102745:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010274b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010274d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102750:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102753:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102755:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102758:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010275e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102763:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102769:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010276c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102773:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102776:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102779:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102780:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102783:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102786:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010278c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102795:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102798:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010279e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027a7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801027aa:	5b                   	pop    %ebx
801027ab:	5d                   	pop    %ebp
801027ac:	c3                   	ret    
801027ad:	8d 76 00             	lea    0x0(%esi),%esi

801027b0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801027b0:	55                   	push   %ebp
801027b1:	ba 70 00 00 00       	mov    $0x70,%edx
801027b6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027bb:	89 e5                	mov    %esp,%ebp
801027bd:	57                   	push   %edi
801027be:	56                   	push   %esi
801027bf:	53                   	push   %ebx
801027c0:	83 ec 4c             	sub    $0x4c,%esp
801027c3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027c4:	ba 71 00 00 00       	mov    $0x71,%edx
801027c9:	ec                   	in     (%dx),%al
801027ca:	83 e0 04             	and    $0x4,%eax
801027cd:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027d0:	31 db                	xor    %ebx,%ebx
801027d2:	88 45 b7             	mov    %al,-0x49(%ebp)
801027d5:	bf 70 00 00 00       	mov    $0x70,%edi
801027da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027e0:	89 d8                	mov    %ebx,%eax
801027e2:	89 fa                	mov    %edi,%edx
801027e4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e5:	b9 71 00 00 00       	mov    $0x71,%ecx
801027ea:	89 ca                	mov    %ecx,%edx
801027ec:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801027ed:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f0:	89 fa                	mov    %edi,%edx
801027f2:	89 45 b8             	mov    %eax,-0x48(%ebp)
801027f5:	b8 02 00 00 00       	mov    $0x2,%eax
801027fa:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027fb:	89 ca                	mov    %ecx,%edx
801027fd:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801027fe:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102801:	89 fa                	mov    %edi,%edx
80102803:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102806:	b8 04 00 00 00       	mov    $0x4,%eax
8010280b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280c:	89 ca                	mov    %ecx,%edx
8010280e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010280f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102812:	89 fa                	mov    %edi,%edx
80102814:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102817:	b8 07 00 00 00       	mov    $0x7,%eax
8010281c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281d:	89 ca                	mov    %ecx,%edx
8010281f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102820:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102823:	89 fa                	mov    %edi,%edx
80102825:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102828:	b8 08 00 00 00       	mov    $0x8,%eax
8010282d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010282e:	89 ca                	mov    %ecx,%edx
80102830:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102831:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102834:	89 fa                	mov    %edi,%edx
80102836:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102839:	b8 09 00 00 00       	mov    $0x9,%eax
8010283e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283f:	89 ca                	mov    %ecx,%edx
80102841:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102842:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102845:	89 fa                	mov    %edi,%edx
80102847:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010284a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010284f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102850:	89 ca                	mov    %ecx,%edx
80102852:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102853:	84 c0                	test   %al,%al
80102855:	78 89                	js     801027e0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102857:	89 d8                	mov    %ebx,%eax
80102859:	89 fa                	mov    %edi,%edx
8010285b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285c:	89 ca                	mov    %ecx,%edx
8010285e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010285f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102862:	89 fa                	mov    %edi,%edx
80102864:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102867:	b8 02 00 00 00       	mov    $0x2,%eax
8010286c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286d:	89 ca                	mov    %ecx,%edx
8010286f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102870:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102873:	89 fa                	mov    %edi,%edx
80102875:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102878:	b8 04 00 00 00       	mov    $0x4,%eax
8010287d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287e:	89 ca                	mov    %ecx,%edx
80102880:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102881:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102884:	89 fa                	mov    %edi,%edx
80102886:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102889:	b8 07 00 00 00       	mov    $0x7,%eax
8010288e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288f:	89 ca                	mov    %ecx,%edx
80102891:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102892:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102895:	89 fa                	mov    %edi,%edx
80102897:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010289a:	b8 08 00 00 00       	mov    $0x8,%eax
8010289f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a0:	89 ca                	mov    %ecx,%edx
801028a2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028a3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a6:	89 fa                	mov    %edi,%edx
801028a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028ab:	b8 09 00 00 00       	mov    $0x9,%eax
801028b0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b1:	89 ca                	mov    %ecx,%edx
801028b3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028b4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028b7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801028ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028bd:	8d 45 b8             	lea    -0x48(%ebp),%eax
801028c0:	6a 18                	push   $0x18
801028c2:	56                   	push   %esi
801028c3:	50                   	push   %eax
801028c4:	e8 77 1b 00 00       	call   80104440 <memcmp>
801028c9:	83 c4 10             	add    $0x10,%esp
801028cc:	85 c0                	test   %eax,%eax
801028ce:	0f 85 0c ff ff ff    	jne    801027e0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801028d4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028d8:	75 78                	jne    80102952 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028da:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028dd:	89 c2                	mov    %eax,%edx
801028df:	83 e0 0f             	and    $0xf,%eax
801028e2:	c1 ea 04             	shr    $0x4,%edx
801028e5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028eb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028ee:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028f1:	89 c2                	mov    %eax,%edx
801028f3:	83 e0 0f             	and    $0xf,%eax
801028f6:	c1 ea 04             	shr    $0x4,%edx
801028f9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028fc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028ff:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102902:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102905:	89 c2                	mov    %eax,%edx
80102907:	83 e0 0f             	and    $0xf,%eax
8010290a:	c1 ea 04             	shr    $0x4,%edx
8010290d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102910:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102913:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102916:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102919:	89 c2                	mov    %eax,%edx
8010291b:	83 e0 0f             	and    $0xf,%eax
8010291e:	c1 ea 04             	shr    $0x4,%edx
80102921:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102924:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102927:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010292a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010292d:	89 c2                	mov    %eax,%edx
8010292f:	83 e0 0f             	and    $0xf,%eax
80102932:	c1 ea 04             	shr    $0x4,%edx
80102935:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102938:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010293b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010293e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102941:	89 c2                	mov    %eax,%edx
80102943:	83 e0 0f             	and    $0xf,%eax
80102946:	c1 ea 04             	shr    $0x4,%edx
80102949:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010294c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010294f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102952:	8b 75 08             	mov    0x8(%ebp),%esi
80102955:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102958:	89 06                	mov    %eax,(%esi)
8010295a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010295d:	89 46 04             	mov    %eax,0x4(%esi)
80102960:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102963:	89 46 08             	mov    %eax,0x8(%esi)
80102966:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102969:	89 46 0c             	mov    %eax,0xc(%esi)
8010296c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010296f:	89 46 10             	mov    %eax,0x10(%esi)
80102972:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102975:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102978:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010297f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102982:	5b                   	pop    %ebx
80102983:	5e                   	pop    %esi
80102984:	5f                   	pop    %edi
80102985:	5d                   	pop    %ebp
80102986:	c3                   	ret    
80102987:	66 90                	xchg   %ax,%ax
80102989:	66 90                	xchg   %ax,%ax
8010298b:	66 90                	xchg   %ax,%ax
8010298d:	66 90                	xchg   %ax,%ax
8010298f:	90                   	nop

80102990 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102990:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102996:	85 c9                	test   %ecx,%ecx
80102998:	0f 8e 85 00 00 00    	jle    80102a23 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
8010299e:	55                   	push   %ebp
8010299f:	89 e5                	mov    %esp,%ebp
801029a1:	57                   	push   %edi
801029a2:	56                   	push   %esi
801029a3:	53                   	push   %ebx
801029a4:	31 db                	xor    %ebx,%ebx
801029a6:	83 ec 0c             	sub    $0xc,%esp
801029a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029b0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029b5:	83 ec 08             	sub    $0x8,%esp
801029b8:	01 d8                	add    %ebx,%eax
801029ba:	83 c0 01             	add    $0x1,%eax
801029bd:	50                   	push   %eax
801029be:	ff 35 c4 26 11 80    	pushl  0x801126c4
801029c4:	e8 07 d7 ff ff       	call   801000d0 <bread>
801029c9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029cb:	58                   	pop    %eax
801029cc:	5a                   	pop    %edx
801029cd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
801029d4:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029da:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029dd:	e8 ee d6 ff ff       	call   801000d0 <bread>
801029e2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029e4:	8d 47 5c             	lea    0x5c(%edi),%eax
801029e7:	83 c4 0c             	add    $0xc,%esp
801029ea:	68 00 02 00 00       	push   $0x200
801029ef:	50                   	push   %eax
801029f0:	8d 46 5c             	lea    0x5c(%esi),%eax
801029f3:	50                   	push   %eax
801029f4:	e8 a7 1a 00 00       	call   801044a0 <memmove>
    bwrite(dbuf);  // write dst to disk
801029f9:	89 34 24             	mov    %esi,(%esp)
801029fc:	e8 9f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a01:	89 3c 24             	mov    %edi,(%esp)
80102a04:	e8 d7 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a09:	89 34 24             	mov    %esi,(%esp)
80102a0c:	e8 cf d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a11:	83 c4 10             	add    $0x10,%esp
80102a14:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a1a:	7f 94                	jg     801029b0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a1f:	5b                   	pop    %ebx
80102a20:	5e                   	pop    %esi
80102a21:	5f                   	pop    %edi
80102a22:	5d                   	pop    %ebp
80102a23:	f3 c3                	repz ret 
80102a25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	53                   	push   %ebx
80102a34:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a37:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102a3d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a43:	e8 88 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a48:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a4e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a51:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a53:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a55:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a58:	7e 1f                	jle    80102a79 <write_head+0x49>
80102a5a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a61:	31 d2                	xor    %edx,%edx
80102a63:	90                   	nop
80102a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a68:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102a6e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102a72:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a75:	39 c2                	cmp    %eax,%edx
80102a77:	75 ef                	jne    80102a68 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a79:	83 ec 0c             	sub    $0xc,%esp
80102a7c:	53                   	push   %ebx
80102a7d:	e8 1e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a82:	89 1c 24             	mov    %ebx,(%esp)
80102a85:	e8 56 d7 ff ff       	call   801001e0 <brelse>
}
80102a8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a8d:	c9                   	leave  
80102a8e:	c3                   	ret    
80102a8f:	90                   	nop

80102a90 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
80102a93:	53                   	push   %ebx
80102a94:	83 ec 2c             	sub    $0x2c,%esp
80102a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102a9a:	68 20 75 10 80       	push   $0x80107520
80102a9f:	68 80 26 11 80       	push   $0x80112680
80102aa4:	e8 d7 16 00 00       	call   80104180 <initlock>
  readsb(dev, &sb);
80102aa9:	58                   	pop    %eax
80102aaa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102aad:	5a                   	pop    %edx
80102aae:	50                   	push   %eax
80102aaf:	53                   	push   %ebx
80102ab0:	e8 db e8 ff ff       	call   80101390 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ab5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102abb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102abc:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ac2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ac8:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102acd:	5a                   	pop    %edx
80102ace:	50                   	push   %eax
80102acf:	53                   	push   %ebx
80102ad0:	e8 fb d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ad5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ad8:	83 c4 10             	add    $0x10,%esp
80102adb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102add:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ae3:	7e 1c                	jle    80102b01 <initlog+0x71>
80102ae5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102aec:	31 d2                	xor    %edx,%edx
80102aee:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102af0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102af4:	83 c2 04             	add    $0x4,%edx
80102af7:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102afd:	39 da                	cmp    %ebx,%edx
80102aff:	75 ef                	jne    80102af0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b01:	83 ec 0c             	sub    $0xc,%esp
80102b04:	50                   	push   %eax
80102b05:	e8 d6 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b0a:	e8 81 fe ff ff       	call   80102990 <install_trans>
  log.lh.n = 0;
80102b0f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b16:	00 00 00 
  write_head(); // clear the log
80102b19:	e8 12 ff ff ff       	call   80102a30 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b21:	c9                   	leave  
80102b22:	c3                   	ret    
80102b23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b36:	68 80 26 11 80       	push   $0x80112680
80102b3b:	e8 40 17 00 00       	call   80104280 <acquire>
80102b40:	83 c4 10             	add    $0x10,%esp
80102b43:	eb 18                	jmp    80102b5d <begin_op+0x2d>
80102b45:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b48:	83 ec 08             	sub    $0x8,%esp
80102b4b:	68 80 26 11 80       	push   $0x80112680
80102b50:	68 80 26 11 80       	push   $0x80112680
80102b55:	e8 b6 11 00 00       	call   80103d10 <sleep>
80102b5a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b5d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b62:	85 c0                	test   %eax,%eax
80102b64:	75 e2                	jne    80102b48 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b66:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b6b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b71:	83 c0 01             	add    $0x1,%eax
80102b74:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b77:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b7a:	83 fa 1e             	cmp    $0x1e,%edx
80102b7d:	7f c9                	jg     80102b48 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b7f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b82:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b87:	68 80 26 11 80       	push   $0x80112680
80102b8c:	e8 0f 18 00 00       	call   801043a0 <release>
      break;
    }
  }
}
80102b91:	83 c4 10             	add    $0x10,%esp
80102b94:	c9                   	leave  
80102b95:	c3                   	ret    
80102b96:	8d 76 00             	lea    0x0(%esi),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
80102ba3:	57                   	push   %edi
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ba9:	68 80 26 11 80       	push   $0x80112680
80102bae:	e8 cd 16 00 00       	call   80104280 <acquire>
  log.outstanding -= 1;
80102bb3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bb8:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102bbe:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bc1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bc4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bc6:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bcb:	0f 85 23 01 00 00    	jne    80102cf4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102bd1:	85 c0                	test   %eax,%eax
80102bd3:	0f 85 f7 00 00 00    	jne    80102cd0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bd9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bdc:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102be3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102be6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102be8:	68 80 26 11 80       	push   $0x80112680
80102bed:	e8 ae 17 00 00       	call   801043a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bf2:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102bf8:	83 c4 10             	add    $0x10,%esp
80102bfb:	85 c9                	test   %ecx,%ecx
80102bfd:	0f 8e 8a 00 00 00    	jle    80102c8d <end_op+0xed>
80102c03:	90                   	nop
80102c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c08:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c0d:	83 ec 08             	sub    $0x8,%esp
80102c10:	01 d8                	add    %ebx,%eax
80102c12:	83 c0 01             	add    $0x1,%eax
80102c15:	50                   	push   %eax
80102c16:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c1c:	e8 af d4 ff ff       	call   801000d0 <bread>
80102c21:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c23:	58                   	pop    %eax
80102c24:	5a                   	pop    %edx
80102c25:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102c2c:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c32:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c35:	e8 96 d4 ff ff       	call   801000d0 <bread>
80102c3a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c3c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c3f:	83 c4 0c             	add    $0xc,%esp
80102c42:	68 00 02 00 00       	push   $0x200
80102c47:	50                   	push   %eax
80102c48:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c4b:	50                   	push   %eax
80102c4c:	e8 4f 18 00 00       	call   801044a0 <memmove>
    bwrite(to);  // write the log
80102c51:	89 34 24             	mov    %esi,(%esp)
80102c54:	e8 47 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c59:	89 3c 24             	mov    %edi,(%esp)
80102c5c:	e8 7f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c61:	89 34 24             	mov    %esi,(%esp)
80102c64:	e8 77 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c69:	83 c4 10             	add    $0x10,%esp
80102c6c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c72:	7c 94                	jl     80102c08 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c74:	e8 b7 fd ff ff       	call   80102a30 <write_head>
    install_trans(); // Now install writes to home locations
80102c79:	e8 12 fd ff ff       	call   80102990 <install_trans>
    log.lh.n = 0;
80102c7e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c85:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c88:	e8 a3 fd ff ff       	call   80102a30 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c8d:	83 ec 0c             	sub    $0xc,%esp
80102c90:	68 80 26 11 80       	push   $0x80112680
80102c95:	e8 e6 15 00 00       	call   80104280 <acquire>
    log.committing = 0;
    wakeup(&log);
80102c9a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102ca1:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102ca8:	00 00 00 
    wakeup(&log);
80102cab:	e8 10 12 00 00       	call   80103ec0 <wakeup>
    release(&log.lock);
80102cb0:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cb7:	e8 e4 16 00 00       	call   801043a0 <release>
80102cbc:	83 c4 10             	add    $0x10,%esp
  }
}
80102cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cc2:	5b                   	pop    %ebx
80102cc3:	5e                   	pop    %esi
80102cc4:	5f                   	pop    %edi
80102cc5:	5d                   	pop    %ebp
80102cc6:	c3                   	ret    
80102cc7:	89 f6                	mov    %esi,%esi
80102cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102cd0:	83 ec 0c             	sub    $0xc,%esp
80102cd3:	68 80 26 11 80       	push   $0x80112680
80102cd8:	e8 e3 11 00 00       	call   80103ec0 <wakeup>
  }
  release(&log.lock);
80102cdd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ce4:	e8 b7 16 00 00       	call   801043a0 <release>
80102ce9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cef:	5b                   	pop    %ebx
80102cf0:	5e                   	pop    %esi
80102cf1:	5f                   	pop    %edi
80102cf2:	5d                   	pop    %ebp
80102cf3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102cf4:	83 ec 0c             	sub    $0xc,%esp
80102cf7:	68 24 75 10 80       	push   $0x80107524
80102cfc:	e8 6f d6 ff ff       	call   80100370 <panic>
80102d01:	eb 0d                	jmp    80102d10 <log_write>
80102d03:	90                   	nop
80102d04:	90                   	nop
80102d05:	90                   	nop
80102d06:	90                   	nop
80102d07:	90                   	nop
80102d08:	90                   	nop
80102d09:	90                   	nop
80102d0a:	90                   	nop
80102d0b:	90                   	nop
80102d0c:	90                   	nop
80102d0d:	90                   	nop
80102d0e:	90                   	nop
80102d0f:	90                   	nop

80102d10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	53                   	push   %ebx
80102d14:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d17:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d20:	83 fa 1d             	cmp    $0x1d,%edx
80102d23:	0f 8f 97 00 00 00    	jg     80102dc0 <log_write+0xb0>
80102d29:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d2e:	83 e8 01             	sub    $0x1,%eax
80102d31:	39 c2                	cmp    %eax,%edx
80102d33:	0f 8d 87 00 00 00    	jge    80102dc0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d39:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d3e:	85 c0                	test   %eax,%eax
80102d40:	0f 8e 87 00 00 00    	jle    80102dcd <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d46:	83 ec 0c             	sub    $0xc,%esp
80102d49:	68 80 26 11 80       	push   $0x80112680
80102d4e:	e8 2d 15 00 00       	call   80104280 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d53:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d59:	83 c4 10             	add    $0x10,%esp
80102d5c:	83 fa 00             	cmp    $0x0,%edx
80102d5f:	7e 50                	jle    80102db1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d61:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d64:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d66:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102d6c:	75 0b                	jne    80102d79 <log_write+0x69>
80102d6e:	eb 38                	jmp    80102da8 <log_write+0x98>
80102d70:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d77:	74 2f                	je     80102da8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d79:	83 c0 01             	add    $0x1,%eax
80102d7c:	39 d0                	cmp    %edx,%eax
80102d7e:	75 f0                	jne    80102d70 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d80:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d87:	83 c2 01             	add    $0x1,%edx
80102d8a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d90:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d93:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d9d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102d9e:	e9 fd 15 00 00       	jmp    801043a0 <release>
80102da3:	90                   	nop
80102da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102da8:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102daf:	eb df                	jmp    80102d90 <log_write+0x80>
80102db1:	8b 43 08             	mov    0x8(%ebx),%eax
80102db4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102db9:	75 d5                	jne    80102d90 <log_write+0x80>
80102dbb:	eb ca                	jmp    80102d87 <log_write+0x77>
80102dbd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102dc0:	83 ec 0c             	sub    $0xc,%esp
80102dc3:	68 33 75 10 80       	push   $0x80107533
80102dc8:	e8 a3 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102dcd:	83 ec 0c             	sub    $0xc,%esp
80102dd0:	68 49 75 10 80       	push   $0x80107549
80102dd5:	e8 96 d5 ff ff       	call   80100370 <panic>
80102dda:	66 90                	xchg   %ax,%ax
80102ddc:	66 90                	xchg   %ax,%ax
80102dde:	66 90                	xchg   %ax,%ax

80102de0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
80102de4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102de7:	e8 54 09 00 00       	call   80103740 <cpuid>
80102dec:	89 c3                	mov    %eax,%ebx
80102dee:	e8 4d 09 00 00       	call   80103740 <cpuid>
80102df3:	83 ec 04             	sub    $0x4,%esp
80102df6:	53                   	push   %ebx
80102df7:	50                   	push   %eax
80102df8:	68 64 75 10 80       	push   $0x80107564
80102dfd:	e8 5e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e02:	e8 29 29 00 00       	call   80105730 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e07:	e8 b4 08 00 00       	call   801036c0 <mycpu>
80102e0c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e0e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e13:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e1a:	e8 01 0c 00 00       	call   80103a20 <scheduler>
80102e1f:	90                   	nop

80102e20 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e26:	e8 75 3a 00 00       	call   801068a0 <switchkvm>
  seginit();
80102e2b:	e8 e0 38 00 00       	call   80106710 <seginit>
  lapicinit();
80102e30:	e8 9b f7 ff ff       	call   801025d0 <lapicinit>
  mpmain();
80102e35:	e8 a6 ff ff ff       	call   80102de0 <mpmain>
80102e3a:	66 90                	xchg   %ax,%ax
80102e3c:	66 90                	xchg   %ax,%ax
80102e3e:	66 90                	xchg   %ax,%ax

80102e40 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e40:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e44:	83 e4 f0             	and    $0xfffffff0,%esp
80102e47:	ff 71 fc             	pushl  -0x4(%ecx)
80102e4a:	55                   	push   %ebp
80102e4b:	89 e5                	mov    %esp,%ebp
80102e4d:	53                   	push   %ebx
80102e4e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e4f:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e54:	83 ec 08             	sub    $0x8,%esp
80102e57:	68 00 00 40 80       	push   $0x80400000
80102e5c:	68 f4 58 11 80       	push   $0x801158f4
80102e61:	e8 3a f5 ff ff       	call   801023a0 <kinit1>
  kvmalloc();      // kernel page table
80102e66:	e8 d5 3e 00 00       	call   80106d40 <kvmalloc>
  mpinit();        // detect other processors
80102e6b:	e8 70 01 00 00       	call   80102fe0 <mpinit>
  lapicinit();     // interrupt controller
80102e70:	e8 5b f7 ff ff       	call   801025d0 <lapicinit>
  seginit();       // segment descriptors
80102e75:	e8 96 38 00 00       	call   80106710 <seginit>
  picinit();       // disable pic
80102e7a:	e8 31 03 00 00       	call   801031b0 <picinit>
  ioapicinit();    // another interrupt controller
80102e7f:	e8 4c f3 ff ff       	call   801021d0 <ioapicinit>
  consoleinit();   // console hardware
80102e84:	e8 17 db ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102e89:	e8 e2 2b 00 00       	call   80105a70 <uartinit>
  pinit();         // process table
80102e8e:	e8 0d 08 00 00       	call   801036a0 <pinit>
  shminit();       // shared memory
80102e93:	e8 68 41 00 00       	call   80107000 <shminit>
  tvinit();        // trap vectors
80102e98:	e8 f3 27 00 00       	call   80105690 <tvinit>
  binit();         // buffer cache
80102e9d:	e8 9e d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ea2:	e8 89 de ff ff       	call   80100d30 <fileinit>
  ideinit();       // disk 
80102ea7:	e8 04 f1 ff ff       	call   80101fb0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102eac:	83 c4 0c             	add    $0xc,%esp
80102eaf:	68 8a 00 00 00       	push   $0x8a
80102eb4:	68 8c a4 10 80       	push   $0x8010a48c
80102eb9:	68 00 70 00 80       	push   $0x80007000
80102ebe:	e8 dd 15 00 00       	call   801044a0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ec3:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102eca:	00 00 00 
80102ecd:	83 c4 10             	add    $0x10,%esp
80102ed0:	05 80 27 11 80       	add    $0x80112780,%eax
80102ed5:	39 d8                	cmp    %ebx,%eax
80102ed7:	76 6a                	jbe    80102f43 <main+0x103>
80102ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ee0:	e8 db 07 00 00       	call   801036c0 <mycpu>
80102ee5:	39 d8                	cmp    %ebx,%eax
80102ee7:	74 41                	je     80102f2a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ee9:	e8 82 f5 ff ff       	call   80102470 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102eee:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102ef3:	c7 05 f8 6f 00 80 20 	movl   $0x80102e20,0x80006ff8
80102efa:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102efd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f04:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f07:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f0c:	0f b6 03             	movzbl (%ebx),%eax
80102f0f:	83 ec 08             	sub    $0x8,%esp
80102f12:	68 00 70 00 00       	push   $0x7000
80102f17:	50                   	push   %eax
80102f18:	e8 03 f8 ff ff       	call   80102720 <lapicstartap>
80102f1d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f20:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f26:	85 c0                	test   %eax,%eax
80102f28:	74 f6                	je     80102f20 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f2a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f31:	00 00 00 
80102f34:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f3a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f3f:	39 c3                	cmp    %eax,%ebx
80102f41:	72 9d                	jb     80102ee0 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f43:	83 ec 08             	sub    $0x8,%esp
80102f46:	68 00 00 00 8e       	push   $0x8e000000
80102f4b:	68 00 00 40 80       	push   $0x80400000
80102f50:	e8 bb f4 ff ff       	call   80102410 <kinit2>
  userinit();      // first user process
80102f55:	e8 36 08 00 00       	call   80103790 <userinit>
  mpmain();        // finish this processor's setup
80102f5a:	e8 81 fe ff ff       	call   80102de0 <mpmain>
80102f5f:	90                   	nop

80102f60 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	57                   	push   %edi
80102f64:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f65:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f6b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f6c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f6f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f72:	39 de                	cmp    %ebx,%esi
80102f74:	73 48                	jae    80102fbe <mpsearch1+0x5e>
80102f76:	8d 76 00             	lea    0x0(%esi),%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f80:	83 ec 04             	sub    $0x4,%esp
80102f83:	8d 7e 10             	lea    0x10(%esi),%edi
80102f86:	6a 04                	push   $0x4
80102f88:	68 78 75 10 80       	push   $0x80107578
80102f8d:	56                   	push   %esi
80102f8e:	e8 ad 14 00 00       	call   80104440 <memcmp>
80102f93:	83 c4 10             	add    $0x10,%esp
80102f96:	85 c0                	test   %eax,%eax
80102f98:	75 1e                	jne    80102fb8 <mpsearch1+0x58>
80102f9a:	8d 7e 10             	lea    0x10(%esi),%edi
80102f9d:	89 f2                	mov    %esi,%edx
80102f9f:	31 c9                	xor    %ecx,%ecx
80102fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fa8:	0f b6 02             	movzbl (%edx),%eax
80102fab:	83 c2 01             	add    $0x1,%edx
80102fae:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fb0:	39 fa                	cmp    %edi,%edx
80102fb2:	75 f4                	jne    80102fa8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fb4:	84 c9                	test   %cl,%cl
80102fb6:	74 10                	je     80102fc8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fb8:	39 fb                	cmp    %edi,%ebx
80102fba:	89 fe                	mov    %edi,%esi
80102fbc:	77 c2                	ja     80102f80 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fc1:	31 c0                	xor    %eax,%eax
}
80102fc3:	5b                   	pop    %ebx
80102fc4:	5e                   	pop    %esi
80102fc5:	5f                   	pop    %edi
80102fc6:	5d                   	pop    %ebp
80102fc7:	c3                   	ret    
80102fc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fcb:	89 f0                	mov    %esi,%eax
80102fcd:	5b                   	pop    %ebx
80102fce:	5e                   	pop    %esi
80102fcf:	5f                   	pop    %edi
80102fd0:	5d                   	pop    %ebp
80102fd1:	c3                   	ret    
80102fd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fe0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	57                   	push   %edi
80102fe4:	56                   	push   %esi
80102fe5:	53                   	push   %ebx
80102fe6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fe9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102ff0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102ff7:	c1 e0 08             	shl    $0x8,%eax
80102ffa:	09 d0                	or     %edx,%eax
80102ffc:	c1 e0 04             	shl    $0x4,%eax
80102fff:	85 c0                	test   %eax,%eax
80103001:	75 1b                	jne    8010301e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103003:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010300a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103011:	c1 e0 08             	shl    $0x8,%eax
80103014:	09 d0                	or     %edx,%eax
80103016:	c1 e0 0a             	shl    $0xa,%eax
80103019:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010301e:	ba 00 04 00 00       	mov    $0x400,%edx
80103023:	e8 38 ff ff ff       	call   80102f60 <mpsearch1>
80103028:	85 c0                	test   %eax,%eax
8010302a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010302d:	0f 84 37 01 00 00    	je     8010316a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103033:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103036:	8b 58 04             	mov    0x4(%eax),%ebx
80103039:	85 db                	test   %ebx,%ebx
8010303b:	0f 84 43 01 00 00    	je     80103184 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103041:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103047:	83 ec 04             	sub    $0x4,%esp
8010304a:	6a 04                	push   $0x4
8010304c:	68 7d 75 10 80       	push   $0x8010757d
80103051:	56                   	push   %esi
80103052:	e8 e9 13 00 00       	call   80104440 <memcmp>
80103057:	83 c4 10             	add    $0x10,%esp
8010305a:	85 c0                	test   %eax,%eax
8010305c:	0f 85 22 01 00 00    	jne    80103184 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103062:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103069:	3c 01                	cmp    $0x1,%al
8010306b:	74 08                	je     80103075 <mpinit+0x95>
8010306d:	3c 04                	cmp    $0x4,%al
8010306f:	0f 85 0f 01 00 00    	jne    80103184 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103075:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010307c:	85 ff                	test   %edi,%edi
8010307e:	74 21                	je     801030a1 <mpinit+0xc1>
80103080:	31 d2                	xor    %edx,%edx
80103082:	31 c0                	xor    %eax,%eax
80103084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103088:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010308f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103090:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103093:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103095:	39 c7                	cmp    %eax,%edi
80103097:	75 ef                	jne    80103088 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103099:	84 d2                	test   %dl,%dl
8010309b:	0f 85 e3 00 00 00    	jne    80103184 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030a1:	85 f6                	test   %esi,%esi
801030a3:	0f 84 db 00 00 00    	je     80103184 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030a9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030af:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030b4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030bb:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030c1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030c6:	01 d6                	add    %edx,%esi
801030c8:	90                   	nop
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030d0:	39 c6                	cmp    %eax,%esi
801030d2:	76 23                	jbe    801030f7 <mpinit+0x117>
801030d4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801030d7:	80 fa 04             	cmp    $0x4,%dl
801030da:	0f 87 c0 00 00 00    	ja     801031a0 <mpinit+0x1c0>
801030e0:	ff 24 95 bc 75 10 80 	jmp    *-0x7fef8a44(,%edx,4)
801030e7:	89 f6                	mov    %esi,%esi
801030e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030f0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030f3:	39 c6                	cmp    %eax,%esi
801030f5:	77 dd                	ja     801030d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030f7:	85 db                	test   %ebx,%ebx
801030f9:	0f 84 92 00 00 00    	je     80103191 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103102:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103106:	74 15                	je     8010311d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103108:	ba 22 00 00 00       	mov    $0x22,%edx
8010310d:	b8 70 00 00 00       	mov    $0x70,%eax
80103112:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103113:	ba 23 00 00 00       	mov    $0x23,%edx
80103118:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103119:	83 c8 01             	or     $0x1,%eax
8010311c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010311d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103120:	5b                   	pop    %ebx
80103121:	5e                   	pop    %esi
80103122:	5f                   	pop    %edi
80103123:	5d                   	pop    %ebp
80103124:	c3                   	ret    
80103125:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103128:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010312e:	83 f9 07             	cmp    $0x7,%ecx
80103131:	7f 19                	jg     8010314c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103133:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103137:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010313d:	83 c1 01             	add    $0x1,%ecx
80103140:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103146:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010314c:	83 c0 14             	add    $0x14,%eax
      continue;
8010314f:	e9 7c ff ff ff       	jmp    801030d0 <mpinit+0xf0>
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103158:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010315c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010315f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
80103165:	e9 66 ff ff ff       	jmp    801030d0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010316a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010316f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103174:	e8 e7 fd ff ff       	call   80102f60 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103179:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010317b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010317e:	0f 85 af fe ff ff    	jne    80103033 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103184:	83 ec 0c             	sub    $0xc,%esp
80103187:	68 82 75 10 80       	push   $0x80107582
8010318c:	e8 df d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103191:	83 ec 0c             	sub    $0xc,%esp
80103194:	68 9c 75 10 80       	push   $0x8010759c
80103199:	e8 d2 d1 ff ff       	call   80100370 <panic>
8010319e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031a0:	31 db                	xor    %ebx,%ebx
801031a2:	e9 30 ff ff ff       	jmp    801030d7 <mpinit+0xf7>
801031a7:	66 90                	xchg   %ax,%ax
801031a9:	66 90                	xchg   %ax,%ax
801031ab:	66 90                	xchg   %ax,%ax
801031ad:	66 90                	xchg   %ax,%ax
801031af:	90                   	nop

801031b0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031b0:	55                   	push   %ebp
801031b1:	ba 21 00 00 00       	mov    $0x21,%edx
801031b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031bb:	89 e5                	mov    %esp,%ebp
801031bd:	ee                   	out    %al,(%dx)
801031be:	ba a1 00 00 00       	mov    $0xa1,%edx
801031c3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031c4:	5d                   	pop    %ebp
801031c5:	c3                   	ret    
801031c6:	66 90                	xchg   %ax,%ax
801031c8:	66 90                	xchg   %ax,%ax
801031ca:	66 90                	xchg   %ax,%ax
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	57                   	push   %edi
801031d4:	56                   	push   %esi
801031d5:	53                   	push   %ebx
801031d6:	83 ec 0c             	sub    $0xc,%esp
801031d9:	8b 75 08             	mov    0x8(%ebp),%esi
801031dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031eb:	e8 60 db ff ff       	call   80100d50 <filealloc>
801031f0:	85 c0                	test   %eax,%eax
801031f2:	89 06                	mov    %eax,(%esi)
801031f4:	0f 84 a8 00 00 00    	je     801032a2 <pipealloc+0xd2>
801031fa:	e8 51 db ff ff       	call   80100d50 <filealloc>
801031ff:	85 c0                	test   %eax,%eax
80103201:	89 03                	mov    %eax,(%ebx)
80103203:	0f 84 87 00 00 00    	je     80103290 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103209:	e8 62 f2 ff ff       	call   80102470 <kalloc>
8010320e:	85 c0                	test   %eax,%eax
80103210:	89 c7                	mov    %eax,%edi
80103212:	0f 84 b0 00 00 00    	je     801032c8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103218:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010321b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103222:	00 00 00 
  p->writeopen = 1;
80103225:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010322c:	00 00 00 
  p->nwrite = 0;
8010322f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103236:	00 00 00 
  p->nread = 0;
80103239:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103240:	00 00 00 
  initlock(&p->lock, "pipe");
80103243:	68 d0 75 10 80       	push   $0x801075d0
80103248:	50                   	push   %eax
80103249:	e8 32 0f 00 00       	call   80104180 <initlock>
  (*f0)->type = FD_PIPE;
8010324e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103250:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103253:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103259:	8b 06                	mov    (%esi),%eax
8010325b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010325f:	8b 06                	mov    (%esi),%eax
80103261:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103265:	8b 06                	mov    (%esi),%eax
80103267:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010326a:	8b 03                	mov    (%ebx),%eax
8010326c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103272:	8b 03                	mov    (%ebx),%eax
80103274:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103278:	8b 03                	mov    (%ebx),%eax
8010327a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010327e:	8b 03                	mov    (%ebx),%eax
80103280:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103283:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103286:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103288:	5b                   	pop    %ebx
80103289:	5e                   	pop    %esi
8010328a:	5f                   	pop    %edi
8010328b:	5d                   	pop    %ebp
8010328c:	c3                   	ret    
8010328d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103290:	8b 06                	mov    (%esi),%eax
80103292:	85 c0                	test   %eax,%eax
80103294:	74 1e                	je     801032b4 <pipealloc+0xe4>
    fileclose(*f0);
80103296:	83 ec 0c             	sub    $0xc,%esp
80103299:	50                   	push   %eax
8010329a:	e8 71 db ff ff       	call   80100e10 <fileclose>
8010329f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032a2:	8b 03                	mov    (%ebx),%eax
801032a4:	85 c0                	test   %eax,%eax
801032a6:	74 0c                	je     801032b4 <pipealloc+0xe4>
    fileclose(*f1);
801032a8:	83 ec 0c             	sub    $0xc,%esp
801032ab:	50                   	push   %eax
801032ac:	e8 5f db ff ff       	call   80100e10 <fileclose>
801032b1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801032b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032bc:	5b                   	pop    %ebx
801032bd:	5e                   	pop    %esi
801032be:	5f                   	pop    %edi
801032bf:	5d                   	pop    %ebp
801032c0:	c3                   	ret    
801032c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032c8:	8b 06                	mov    (%esi),%eax
801032ca:	85 c0                	test   %eax,%eax
801032cc:	75 c8                	jne    80103296 <pipealloc+0xc6>
801032ce:	eb d2                	jmp    801032a2 <pipealloc+0xd2>

801032d0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	56                   	push   %esi
801032d4:	53                   	push   %ebx
801032d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032db:	83 ec 0c             	sub    $0xc,%esp
801032de:	53                   	push   %ebx
801032df:	e8 9c 0f 00 00       	call   80104280 <acquire>
  if(writable){
801032e4:	83 c4 10             	add    $0x10,%esp
801032e7:	85 f6                	test   %esi,%esi
801032e9:	74 45                	je     80103330 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801032eb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801032f1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801032f4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032fb:	00 00 00 
    wakeup(&p->nread);
801032fe:	50                   	push   %eax
801032ff:	e8 bc 0b 00 00       	call   80103ec0 <wakeup>
80103304:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103307:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010330d:	85 d2                	test   %edx,%edx
8010330f:	75 0a                	jne    8010331b <pipeclose+0x4b>
80103311:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103317:	85 c0                	test   %eax,%eax
80103319:	74 35                	je     80103350 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010331b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010331e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103321:	5b                   	pop    %ebx
80103322:	5e                   	pop    %esi
80103323:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103324:	e9 77 10 00 00       	jmp    801043a0 <release>
80103329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103330:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103336:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103339:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103340:	00 00 00 
    wakeup(&p->nwrite);
80103343:	50                   	push   %eax
80103344:	e8 77 0b 00 00       	call   80103ec0 <wakeup>
80103349:	83 c4 10             	add    $0x10,%esp
8010334c:	eb b9                	jmp    80103307 <pipeclose+0x37>
8010334e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103350:	83 ec 0c             	sub    $0xc,%esp
80103353:	53                   	push   %ebx
80103354:	e8 47 10 00 00       	call   801043a0 <release>
    kfree((char*)p);
80103359:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010335c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010335f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103362:	5b                   	pop    %ebx
80103363:	5e                   	pop    %esi
80103364:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103365:	e9 56 ef ff ff       	jmp    801022c0 <kfree>
8010336a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103370 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103370:	55                   	push   %ebp
80103371:	89 e5                	mov    %esp,%ebp
80103373:	57                   	push   %edi
80103374:	56                   	push   %esi
80103375:	53                   	push   %ebx
80103376:	83 ec 28             	sub    $0x28,%esp
80103379:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010337c:	53                   	push   %ebx
8010337d:	e8 fe 0e 00 00       	call   80104280 <acquire>
  for(i = 0; i < n; i++){
80103382:	8b 45 10             	mov    0x10(%ebp),%eax
80103385:	83 c4 10             	add    $0x10,%esp
80103388:	85 c0                	test   %eax,%eax
8010338a:	0f 8e b9 00 00 00    	jle    80103449 <pipewrite+0xd9>
80103390:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103393:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103399:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010339f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033a5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033a8:	03 4d 10             	add    0x10(%ebp),%ecx
801033ab:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033ae:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033b4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033ba:	39 d0                	cmp    %edx,%eax
801033bc:	74 38                	je     801033f6 <pipewrite+0x86>
801033be:	eb 59                	jmp    80103419 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801033c0:	e8 9b 03 00 00       	call   80103760 <myproc>
801033c5:	8b 48 28             	mov    0x28(%eax),%ecx
801033c8:	85 c9                	test   %ecx,%ecx
801033ca:	75 34                	jne    80103400 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033cc:	83 ec 0c             	sub    $0xc,%esp
801033cf:	57                   	push   %edi
801033d0:	e8 eb 0a 00 00       	call   80103ec0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033d5:	58                   	pop    %eax
801033d6:	5a                   	pop    %edx
801033d7:	53                   	push   %ebx
801033d8:	56                   	push   %esi
801033d9:	e8 32 09 00 00       	call   80103d10 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033de:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033e4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033ea:	83 c4 10             	add    $0x10,%esp
801033ed:	05 00 02 00 00       	add    $0x200,%eax
801033f2:	39 c2                	cmp    %eax,%edx
801033f4:	75 2a                	jne    80103420 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
801033f6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801033fc:	85 c0                	test   %eax,%eax
801033fe:	75 c0                	jne    801033c0 <pipewrite+0x50>
        release(&p->lock);
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	53                   	push   %ebx
80103404:	e8 97 0f 00 00       	call   801043a0 <release>
        return -1;
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103411:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103414:	5b                   	pop    %ebx
80103415:	5e                   	pop    %esi
80103416:	5f                   	pop    %edi
80103417:	5d                   	pop    %ebp
80103418:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103419:	89 c2                	mov    %eax,%edx
8010341b:	90                   	nop
8010341c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103420:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103423:	8d 42 01             	lea    0x1(%edx),%eax
80103426:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010342a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103430:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103436:	0f b6 09             	movzbl (%ecx),%ecx
80103439:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010343d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103440:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103443:	0f 85 65 ff ff ff    	jne    801033ae <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103449:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010344f:	83 ec 0c             	sub    $0xc,%esp
80103452:	50                   	push   %eax
80103453:	e8 68 0a 00 00       	call   80103ec0 <wakeup>
  release(&p->lock);
80103458:	89 1c 24             	mov    %ebx,(%esp)
8010345b:	e8 40 0f 00 00       	call   801043a0 <release>
  return n;
80103460:	83 c4 10             	add    $0x10,%esp
80103463:	8b 45 10             	mov    0x10(%ebp),%eax
80103466:	eb a9                	jmp    80103411 <pipewrite+0xa1>
80103468:	90                   	nop
80103469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103470 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	57                   	push   %edi
80103474:	56                   	push   %esi
80103475:	53                   	push   %ebx
80103476:	83 ec 18             	sub    $0x18,%esp
80103479:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010347c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010347f:	53                   	push   %ebx
80103480:	e8 fb 0d 00 00       	call   80104280 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103485:	83 c4 10             	add    $0x10,%esp
80103488:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010348e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103494:	75 6a                	jne    80103500 <piperead+0x90>
80103496:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010349c:	85 f6                	test   %esi,%esi
8010349e:	0f 84 cc 00 00 00    	je     80103570 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034a4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801034aa:	eb 2d                	jmp    801034d9 <piperead+0x69>
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034b0:	83 ec 08             	sub    $0x8,%esp
801034b3:	53                   	push   %ebx
801034b4:	56                   	push   %esi
801034b5:	e8 56 08 00 00       	call   80103d10 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034ba:	83 c4 10             	add    $0x10,%esp
801034bd:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801034c3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801034c9:	75 35                	jne    80103500 <piperead+0x90>
801034cb:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801034d1:	85 d2                	test   %edx,%edx
801034d3:	0f 84 97 00 00 00    	je     80103570 <piperead+0x100>
    if(myproc()->killed){
801034d9:	e8 82 02 00 00       	call   80103760 <myproc>
801034de:	8b 48 28             	mov    0x28(%eax),%ecx
801034e1:	85 c9                	test   %ecx,%ecx
801034e3:	74 cb                	je     801034b0 <piperead+0x40>
      release(&p->lock);
801034e5:	83 ec 0c             	sub    $0xc,%esp
801034e8:	53                   	push   %ebx
801034e9:	e8 b2 0e 00 00       	call   801043a0 <release>
      return -1;
801034ee:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034f1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801034f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034f9:	5b                   	pop    %ebx
801034fa:	5e                   	pop    %esi
801034fb:	5f                   	pop    %edi
801034fc:	5d                   	pop    %ebp
801034fd:	c3                   	ret    
801034fe:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103500:	8b 45 10             	mov    0x10(%ebp),%eax
80103503:	85 c0                	test   %eax,%eax
80103505:	7e 69                	jle    80103570 <piperead+0x100>
    if(p->nread == p->nwrite)
80103507:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010350d:	31 c9                	xor    %ecx,%ecx
8010350f:	eb 15                	jmp    80103526 <piperead+0xb6>
80103511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103518:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010351e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103524:	74 5a                	je     80103580 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103526:	8d 70 01             	lea    0x1(%eax),%esi
80103529:	25 ff 01 00 00       	and    $0x1ff,%eax
8010352e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103534:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103539:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010353c:	83 c1 01             	add    $0x1,%ecx
8010353f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103542:	75 d4                	jne    80103518 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103544:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010354a:	83 ec 0c             	sub    $0xc,%esp
8010354d:	50                   	push   %eax
8010354e:	e8 6d 09 00 00       	call   80103ec0 <wakeup>
  release(&p->lock);
80103553:	89 1c 24             	mov    %ebx,(%esp)
80103556:	e8 45 0e 00 00       	call   801043a0 <release>
  return i;
8010355b:	8b 45 10             	mov    0x10(%ebp),%eax
8010355e:	83 c4 10             	add    $0x10,%esp
}
80103561:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103564:	5b                   	pop    %ebx
80103565:	5e                   	pop    %esi
80103566:	5f                   	pop    %edi
80103567:	5d                   	pop    %ebp
80103568:	c3                   	ret    
80103569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103570:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103577:	eb cb                	jmp    80103544 <piperead+0xd4>
80103579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103580:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103583:	eb bf                	jmp    80103544 <piperead+0xd4>
80103585:	66 90                	xchg   %ax,%ax
80103587:	66 90                	xchg   %ax,%ax
80103589:	66 90                	xchg   %ax,%ax
8010358b:	66 90                	xchg   %ax,%ax
8010358d:	66 90                	xchg   %ax,%ax
8010358f:	90                   	nop

80103590 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103594:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103599:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010359c:	68 20 2d 11 80       	push   $0x80112d20
801035a1:	e8 da 0c 00 00       	call   80104280 <acquire>
801035a6:	83 c4 10             	add    $0x10,%esp
801035a9:	eb 10                	jmp    801035bb <allocproc+0x2b>
801035ab:	90                   	nop
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035b0:	83 eb 80             	sub    $0xffffff80,%ebx
801035b3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801035b9:	74 75                	je     80103630 <allocproc+0xa0>
    if(p->state == UNUSED)
801035bb:	8b 43 10             	mov    0x10(%ebx),%eax
801035be:	85 c0                	test   %eax,%eax
801035c0:	75 ee                	jne    801035b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035c2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801035c7:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801035ca:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
801035d1:	68 20 2d 11 80       	push   $0x80112d20
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035d6:	8d 50 01             	lea    0x1(%eax),%edx
801035d9:	89 43 14             	mov    %eax,0x14(%ebx)
801035dc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

  release(&ptable.lock);
801035e2:	e8 b9 0d 00 00       	call   801043a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801035e7:	e8 84 ee ff ff       	call   80102470 <kalloc>
801035ec:	83 c4 10             	add    $0x10,%esp
801035ef:	85 c0                	test   %eax,%eax
801035f1:	89 43 0c             	mov    %eax,0xc(%ebx)
801035f4:	74 51                	je     80103647 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801035f6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801035fc:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801035ff:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103604:	89 53 1c             	mov    %edx,0x1c(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103607:	c7 40 14 82 56 10 80 	movl   $0x80105682,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010360e:	6a 14                	push   $0x14
80103610:	6a 00                	push   $0x0
80103612:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103613:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103616:	e8 d5 0d 00 00       	call   801043f0 <memset>
  p->context->eip = (uint)forkret;
8010361b:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
8010361e:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103621:	c7 40 10 50 36 10 80 	movl   $0x80103650,0x10(%eax)

  return p;
80103628:	89 d8                	mov    %ebx,%eax
}
8010362a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010362d:	c9                   	leave  
8010362e:	c3                   	ret    
8010362f:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	68 20 2d 11 80       	push   $0x80112d20
80103638:	e8 63 0d 00 00       	call   801043a0 <release>
  return 0;
8010363d:	83 c4 10             	add    $0x10,%esp
80103640:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103645:	c9                   	leave  
80103646:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103647:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
8010364e:	eb da                	jmp    8010362a <allocproc+0x9a>

80103650 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103656:	68 20 2d 11 80       	push   $0x80112d20
8010365b:	e8 40 0d 00 00       	call   801043a0 <release>

  if (first) {
80103660:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103665:	83 c4 10             	add    $0x10,%esp
80103668:	85 c0                	test   %eax,%eax
8010366a:	75 04                	jne    80103670 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010366c:	c9                   	leave  
8010366d:	c3                   	ret    
8010366e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103670:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103673:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010367a:	00 00 00 
    iinit(ROOTDEV);
8010367d:	6a 01                	push   $0x1
8010367f:	e8 cc dd ff ff       	call   80101450 <iinit>
    initlog(ROOTDEV);
80103684:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010368b:	e8 00 f4 ff ff       	call   80102a90 <initlog>
80103690:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103693:	c9                   	leave  
80103694:	c3                   	ret    
80103695:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036a0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801036a6:	68 d5 75 10 80       	push   $0x801075d5
801036ab:	68 20 2d 11 80       	push   $0x80112d20
801036b0:	e8 cb 0a 00 00       	call   80104180 <initlock>
}
801036b5:	83 c4 10             	add    $0x10,%esp
801036b8:	c9                   	leave  
801036b9:	c3                   	ret    
801036ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036c0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	56                   	push   %esi
801036c4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036c5:	9c                   	pushf  
801036c6:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
801036c7:	f6 c4 02             	test   $0x2,%ah
801036ca:	75 5b                	jne    80103727 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801036cc:	e8 ff ef ff ff       	call   801026d0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036d1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801036d7:	85 f6                	test   %esi,%esi
801036d9:	7e 3f                	jle    8010371a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036db:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801036e2:	39 d0                	cmp    %edx,%eax
801036e4:	74 30                	je     80103716 <mycpu+0x56>
801036e6:	b9 30 28 11 80       	mov    $0x80112830,%ecx
801036eb:	31 d2                	xor    %edx,%edx
801036ed:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036f0:	83 c2 01             	add    $0x1,%edx
801036f3:	39 f2                	cmp    %esi,%edx
801036f5:	74 23                	je     8010371a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036f7:	0f b6 19             	movzbl (%ecx),%ebx
801036fa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103700:	39 d8                	cmp    %ebx,%eax
80103702:	75 ec                	jne    801036f0 <mycpu+0x30>
      return &cpus[i];
80103704:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010370a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010370d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010370e:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103713:	5e                   	pop    %esi
80103714:	5d                   	pop    %ebp
80103715:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103716:	31 d2                	xor    %edx,%edx
80103718:	eb ea                	jmp    80103704 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010371a:	83 ec 0c             	sub    $0xc,%esp
8010371d:	68 dc 75 10 80       	push   $0x801075dc
80103722:	e8 49 cc ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103727:	83 ec 0c             	sub    $0xc,%esp
8010372a:	68 b8 76 10 80       	push   $0x801076b8
8010372f:	e8 3c cc ff ff       	call   80100370 <panic>
80103734:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010373a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103740 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103746:	e8 75 ff ff ff       	call   801036c0 <mycpu>
8010374b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103750:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103751:	c1 f8 04             	sar    $0x4,%eax
80103754:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010375a:	c3                   	ret    
8010375b:	90                   	nop
8010375c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103760 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	53                   	push   %ebx
80103764:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103767:	e8 d4 0a 00 00       	call   80104240 <pushcli>
  c = mycpu();
8010376c:	e8 4f ff ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103771:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103777:	e8 b4 0b 00 00       	call   80104330 <popcli>
  return p;
}
8010377c:	83 c4 04             	add    $0x4,%esp
8010377f:	89 d8                	mov    %ebx,%eax
80103781:	5b                   	pop    %ebx
80103782:	5d                   	pop    %ebp
80103783:	c3                   	ret    
80103784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010378a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103790 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
80103794:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103797:	e8 f4 fd ff ff       	call   80103590 <allocproc>
8010379c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010379e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801037a3:	e8 18 35 00 00       	call   80106cc0 <setupkvm>
801037a8:	85 c0                	test   %eax,%eax
801037aa:	89 43 08             	mov    %eax,0x8(%ebx)
801037ad:	0f 84 bd 00 00 00    	je     80103870 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037b3:	83 ec 04             	sub    $0x4,%esp
801037b6:	68 2c 00 00 00       	push   $0x2c
801037bb:	68 60 a4 10 80       	push   $0x8010a460
801037c0:	50                   	push   %eax
801037c1:	e8 0a 32 00 00       	call   801069d0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
801037c6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
801037c9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801037cf:	6a 4c                	push   $0x4c
801037d1:	6a 00                	push   $0x0
801037d3:	ff 73 1c             	pushl  0x1c(%ebx)
801037d6:	e8 15 0c 00 00       	call   801043f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037db:	8b 43 1c             	mov    0x1c(%ebx),%eax
801037de:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037e3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
801037e8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037eb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037ef:	8b 43 1c             	mov    0x1c(%ebx),%eax
801037f2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801037f6:	8b 43 1c             	mov    0x1c(%ebx),%eax
801037f9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037fd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103801:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103804:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103808:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010380c:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010380f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103816:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103819:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103820:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103823:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010382a:	8d 43 70             	lea    0x70(%ebx),%eax
8010382d:	6a 10                	push   $0x10
8010382f:	68 05 76 10 80       	push   $0x80107605
80103834:	50                   	push   %eax
80103835:	e8 b6 0d 00 00       	call   801045f0 <safestrcpy>
  p->cwd = namei("/");
8010383a:	c7 04 24 0e 76 10 80 	movl   $0x8010760e,(%esp)
80103841:	e8 5a e6 ff ff       	call   80101ea0 <namei>
80103846:	89 43 6c             	mov    %eax,0x6c(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103849:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103850:	e8 2b 0a 00 00       	call   80104280 <acquire>

  p->state = RUNNABLE;
80103855:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)

  release(&ptable.lock);
8010385c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103863:	e8 38 0b 00 00       	call   801043a0 <release>
}
80103868:	83 c4 10             	add    $0x10,%esp
8010386b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386e:	c9                   	leave  
8010386f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103870:	83 ec 0c             	sub    $0xc,%esp
80103873:	68 ec 75 10 80       	push   $0x801075ec
80103878:	e8 f3 ca ff ff       	call   80100370 <panic>
8010387d:	8d 76 00             	lea    0x0(%esi),%esi

80103880 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	56                   	push   %esi
80103884:	53                   	push   %ebx
80103885:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103888:	e8 b3 09 00 00       	call   80104240 <pushcli>
  c = mycpu();
8010388d:	e8 2e fe ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103892:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103898:	e8 93 0a 00 00       	call   80104330 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010389d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
801038a0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801038a2:	7e 34                	jle    801038d8 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038a4:	83 ec 04             	sub    $0x4,%esp
801038a7:	01 c6                	add    %eax,%esi
801038a9:	56                   	push   %esi
801038aa:	50                   	push   %eax
801038ab:	ff 73 08             	pushl  0x8(%ebx)
801038ae:	e8 5d 32 00 00       	call   80106b10 <allocuvm>
801038b3:	83 c4 10             	add    $0x10,%esp
801038b6:	85 c0                	test   %eax,%eax
801038b8:	74 36                	je     801038f0 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
801038ba:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
801038bd:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801038bf:	53                   	push   %ebx
801038c0:	e8 fb 2f 00 00       	call   801068c0 <switchuvm>
  return 0;
801038c5:	83 c4 10             	add    $0x10,%esp
801038c8:	31 c0                	xor    %eax,%eax
}
801038ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038cd:	5b                   	pop    %ebx
801038ce:	5e                   	pop    %esi
801038cf:	5d                   	pop    %ebp
801038d0:	c3                   	ret    
801038d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801038d8:	74 e0                	je     801038ba <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038da:	83 ec 04             	sub    $0x4,%esp
801038dd:	01 c6                	add    %eax,%esi
801038df:	56                   	push   %esi
801038e0:	50                   	push   %eax
801038e1:	ff 73 08             	pushl  0x8(%ebx)
801038e4:	e8 27 33 00 00       	call   80106c10 <deallocuvm>
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	85 c0                	test   %eax,%eax
801038ee:	75 ca                	jne    801038ba <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
801038f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038f5:	eb d3                	jmp    801038ca <growproc+0x4a>
801038f7:	89 f6                	mov    %esi,%esi
801038f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103900 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
80103905:	53                   	push   %ebx
80103906:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103909:	e8 32 09 00 00       	call   80104240 <pushcli>
  c = mycpu();
8010390e:	e8 ad fd ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103913:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103919:	e8 12 0a 00 00       	call   80104330 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
8010391e:	e8 6d fc ff ff       	call   80103590 <allocproc>
80103923:	85 c0                	test   %eax,%eax
80103925:	89 c7                	mov    %eax,%edi
80103927:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010392a:	0f 84 b5 00 00 00    	je     801039e5 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103930:	83 ec 08             	sub    $0x8,%esp
80103933:	ff 33                	pushl  (%ebx)
80103935:	ff 73 08             	pushl  0x8(%ebx)
80103938:	e8 53 34 00 00       	call   80106d90 <copyuvm>
8010393d:	83 c4 10             	add    $0x10,%esp
80103940:	85 c0                	test   %eax,%eax
80103942:	89 47 08             	mov    %eax,0x8(%edi)
80103945:	0f 84 a1 00 00 00    	je     801039ec <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
8010394b:	8b 03                	mov    (%ebx),%eax
8010394d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103950:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103952:	89 59 18             	mov    %ebx,0x18(%ecx)
  *np->tf = *curproc->tf;
80103955:	89 c8                	mov    %ecx,%eax
80103957:	8b 79 1c             	mov    0x1c(%ecx),%edi
8010395a:	8b 73 1c             	mov    0x1c(%ebx),%esi
8010395d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103962:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103964:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103966:	8b 40 1c             	mov    0x1c(%eax),%eax
80103969:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103970:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103974:	85 c0                	test   %eax,%eax
80103976:	74 13                	je     8010398b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103978:	83 ec 0c             	sub    $0xc,%esp
8010397b:	50                   	push   %eax
8010397c:	e8 3f d4 ff ff       	call   80100dc0 <filedup>
80103981:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103984:	83 c4 10             	add    $0x10,%esp
80103987:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010398b:	83 c6 01             	add    $0x1,%esi
8010398e:	83 fe 10             	cmp    $0x10,%esi
80103991:	75 dd                	jne    80103970 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103993:	83 ec 0c             	sub    $0xc,%esp
80103996:	ff 73 6c             	pushl  0x6c(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103999:	83 c3 70             	add    $0x70,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010399c:	e8 7f dc ff ff       	call   80101620 <idup>
801039a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039a4:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039a7:	89 47 6c             	mov    %eax,0x6c(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039aa:	8d 47 70             	lea    0x70(%edi),%eax
801039ad:	6a 10                	push   $0x10
801039af:	53                   	push   %ebx
801039b0:	50                   	push   %eax
801039b1:	e8 3a 0c 00 00       	call   801045f0 <safestrcpy>

  pid = np->pid;
801039b6:	8b 5f 14             	mov    0x14(%edi),%ebx

  acquire(&ptable.lock);
801039b9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039c0:	e8 bb 08 00 00       	call   80104280 <acquire>

  np->state = RUNNABLE;
801039c5:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)

  release(&ptable.lock);
801039cc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039d3:	e8 c8 09 00 00       	call   801043a0 <release>

  return pid;
801039d8:	83 c4 10             	add    $0x10,%esp
801039db:	89 d8                	mov    %ebx,%eax
}
801039dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039e0:	5b                   	pop    %ebx
801039e1:	5e                   	pop    %esi
801039e2:	5f                   	pop    %edi
801039e3:	5d                   	pop    %ebp
801039e4:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
801039e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039ea:	eb f1                	jmp    801039dd <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
801039ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801039ef:	83 ec 0c             	sub    $0xc,%esp
801039f2:	ff 77 0c             	pushl  0xc(%edi)
801039f5:	e8 c6 e8 ff ff       	call   801022c0 <kfree>
    np->kstack = 0;
801039fa:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    np->state = UNUSED;
80103a01:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
    return -1;
80103a08:	83 c4 10             	add    $0x10,%esp
80103a0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a10:	eb cb                	jmp    801039dd <fork+0xdd>
80103a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a20 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	57                   	push   %edi
80103a24:	56                   	push   %esi
80103a25:	53                   	push   %ebx
80103a26:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103a29:	e8 92 fc ff ff       	call   801036c0 <mycpu>
80103a2e:	8d 78 04             	lea    0x4(%eax),%edi
80103a31:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a33:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a3a:	00 00 00 
80103a3d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a40:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a41:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a44:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a49:	68 20 2d 11 80       	push   $0x80112d20
80103a4e:	e8 2d 08 00 00       	call   80104280 <acquire>
80103a53:	83 c4 10             	add    $0x10,%esp
80103a56:	eb 13                	jmp    80103a6b <scheduler+0x4b>
80103a58:	90                   	nop
80103a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a60:	83 eb 80             	sub    $0xffffff80,%ebx
80103a63:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103a69:	74 45                	je     80103ab0 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103a6b:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103a6f:	75 ef                	jne    80103a60 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103a71:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103a74:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a7a:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a7b:	83 eb 80             	sub    $0xffffff80,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103a7e:	e8 3d 2e 00 00       	call   801068c0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a83:	58                   	pop    %eax
80103a84:	5a                   	pop    %edx
80103a85:	ff 73 a0             	pushl  -0x60(%ebx)
80103a88:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a89:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)

      swtch(&(c->scheduler), p->context);
80103a90:	e8 b6 0b 00 00       	call   8010464b <swtch>
      switchkvm();
80103a95:	e8 06 2e 00 00       	call   801068a0 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a9a:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a9d:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103aa3:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103aaa:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aad:	75 bc                	jne    80103a6b <scheduler+0x4b>
80103aaf:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103ab0:	83 ec 0c             	sub    $0xc,%esp
80103ab3:	68 20 2d 11 80       	push   $0x80112d20
80103ab8:	e8 e3 08 00 00       	call   801043a0 <release>

  }
80103abd:	83 c4 10             	add    $0x10,%esp
80103ac0:	e9 7b ff ff ff       	jmp    80103a40 <scheduler+0x20>
80103ac5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ad0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ad5:	e8 66 07 00 00       	call   80104240 <pushcli>
  c = mycpu();
80103ada:	e8 e1 fb ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103adf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae5:	e8 46 08 00 00       	call   80104330 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103aea:	83 ec 0c             	sub    $0xc,%esp
80103aed:	68 20 2d 11 80       	push   $0x80112d20
80103af2:	e8 09 07 00 00       	call   80104200 <holding>
80103af7:	83 c4 10             	add    $0x10,%esp
80103afa:	85 c0                	test   %eax,%eax
80103afc:	74 4f                	je     80103b4d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103afe:	e8 bd fb ff ff       	call   801036c0 <mycpu>
80103b03:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b0a:	75 68                	jne    80103b74 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103b0c:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103b10:	74 55                	je     80103b67 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b12:	9c                   	pushf  
80103b13:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103b14:	f6 c4 02             	test   $0x2,%ah
80103b17:	75 41                	jne    80103b5a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b19:	e8 a2 fb ff ff       	call   801036c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b1e:	83 c3 20             	add    $0x20,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b21:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b27:	e8 94 fb ff ff       	call   801036c0 <mycpu>
80103b2c:	83 ec 08             	sub    $0x8,%esp
80103b2f:	ff 70 04             	pushl  0x4(%eax)
80103b32:	53                   	push   %ebx
80103b33:	e8 13 0b 00 00       	call   8010464b <swtch>
  mycpu()->intena = intena;
80103b38:	e8 83 fb ff ff       	call   801036c0 <mycpu>
}
80103b3d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103b40:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b49:	5b                   	pop    %ebx
80103b4a:	5e                   	pop    %esi
80103b4b:	5d                   	pop    %ebp
80103b4c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b4d:	83 ec 0c             	sub    $0xc,%esp
80103b50:	68 10 76 10 80       	push   $0x80107610
80103b55:	e8 16 c8 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b5a:	83 ec 0c             	sub    $0xc,%esp
80103b5d:	68 3c 76 10 80       	push   $0x8010763c
80103b62:	e8 09 c8 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103b67:	83 ec 0c             	sub    $0xc,%esp
80103b6a:	68 2e 76 10 80       	push   $0x8010762e
80103b6f:	e8 fc c7 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103b74:	83 ec 0c             	sub    $0xc,%esp
80103b77:	68 22 76 10 80       	push   $0x80107622
80103b7c:	e8 ef c7 ff ff       	call   80100370 <panic>
80103b81:	eb 0d                	jmp    80103b90 <exit>
80103b83:	90                   	nop
80103b84:	90                   	nop
80103b85:	90                   	nop
80103b86:	90                   	nop
80103b87:	90                   	nop
80103b88:	90                   	nop
80103b89:	90                   	nop
80103b8a:	90                   	nop
80103b8b:	90                   	nop
80103b8c:	90                   	nop
80103b8d:	90                   	nop
80103b8e:	90                   	nop
80103b8f:	90                   	nop

80103b90 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	57                   	push   %edi
80103b94:	56                   	push   %esi
80103b95:	53                   	push   %ebx
80103b96:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b99:	e8 a2 06 00 00       	call   80104240 <pushcli>
  c = mycpu();
80103b9e:	e8 1d fb ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103ba3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ba9:	e8 82 07 00 00       	call   80104330 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103bae:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103bb4:	8d 5e 2c             	lea    0x2c(%esi),%ebx
80103bb7:	8d 7e 6c             	lea    0x6c(%esi),%edi
80103bba:	0f 84 e7 00 00 00    	je     80103ca7 <exit+0x117>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103bc0:	8b 03                	mov    (%ebx),%eax
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	74 12                	je     80103bd8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103bc6:	83 ec 0c             	sub    $0xc,%esp
80103bc9:	50                   	push   %eax
80103bca:	e8 41 d2 ff ff       	call   80100e10 <fileclose>
      curproc->ofile[fd] = 0;
80103bcf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103bd5:	83 c4 10             	add    $0x10,%esp
80103bd8:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103bdb:	39 df                	cmp    %ebx,%edi
80103bdd:	75 e1                	jne    80103bc0 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103bdf:	e8 4c ef ff ff       	call   80102b30 <begin_op>
  iput(curproc->cwd);
80103be4:	83 ec 0c             	sub    $0xc,%esp
80103be7:	ff 76 6c             	pushl  0x6c(%esi)
80103bea:	e8 91 db ff ff       	call   80101780 <iput>
  end_op();
80103bef:	e8 ac ef ff ff       	call   80102ba0 <end_op>
  curproc->cwd = 0;
80103bf4:	c7 46 6c 00 00 00 00 	movl   $0x0,0x6c(%esi)

  acquire(&ptable.lock);
80103bfb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c02:	e8 79 06 00 00       	call   80104280 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103c07:	8b 56 18             	mov    0x18(%esi),%edx
80103c0a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c0d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c12:	eb 0e                	jmp    80103c22 <exit+0x92>
80103c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c18:	83 e8 80             	sub    $0xffffff80,%eax
80103c1b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103c20:	74 1c                	je     80103c3e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103c22:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103c26:	75 f0                	jne    80103c18 <exit+0x88>
80103c28:	3b 50 24             	cmp    0x24(%eax),%edx
80103c2b:	75 eb                	jne    80103c18 <exit+0x88>
      p->state = RUNNABLE;
80103c2d:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c34:	83 e8 80             	sub    $0xffffff80,%eax
80103c37:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103c3c:	75 e4                	jne    80103c22 <exit+0x92>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c3e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103c44:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c49:	eb 10                	jmp    80103c5b <exit+0xcb>
80103c4b:	90                   	nop
80103c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c50:	83 ea 80             	sub    $0xffffff80,%edx
80103c53:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103c59:	74 33                	je     80103c8e <exit+0xfe>
    if(p->parent == curproc){
80103c5b:	39 72 18             	cmp    %esi,0x18(%edx)
80103c5e:	75 f0                	jne    80103c50 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c60:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c64:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
80103c67:	75 e7                	jne    80103c50 <exit+0xc0>
80103c69:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c6e:	eb 0a                	jmp    80103c7a <exit+0xea>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c70:	83 e8 80             	sub    $0xffffff80,%eax
80103c73:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103c78:	74 d6                	je     80103c50 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103c7a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103c7e:	75 f0                	jne    80103c70 <exit+0xe0>
80103c80:	3b 48 24             	cmp    0x24(%eax),%ecx
80103c83:	75 eb                	jne    80103c70 <exit+0xe0>
      p->state = RUNNABLE;
80103c85:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
80103c8c:	eb e2                	jmp    80103c70 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103c8e:	c7 46 10 05 00 00 00 	movl   $0x5,0x10(%esi)
  sched();
80103c95:	e8 36 fe ff ff       	call   80103ad0 <sched>
  panic("zombie exit");
80103c9a:	83 ec 0c             	sub    $0xc,%esp
80103c9d:	68 5d 76 10 80       	push   $0x8010765d
80103ca2:	e8 c9 c6 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103ca7:	83 ec 0c             	sub    $0xc,%esp
80103caa:	68 50 76 10 80       	push   $0x80107650
80103caf:	e8 bc c6 ff ff       	call   80100370 <panic>
80103cb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103cba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103cc0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	53                   	push   %ebx
80103cc4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103cc7:	68 20 2d 11 80       	push   $0x80112d20
80103ccc:	e8 af 05 00 00       	call   80104280 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103cd1:	e8 6a 05 00 00       	call   80104240 <pushcli>
  c = mycpu();
80103cd6:	e8 e5 f9 ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103cdb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ce1:	e8 4a 06 00 00       	call   80104330 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103ce6:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
80103ced:	e8 de fd ff ff       	call   80103ad0 <sched>
  release(&ptable.lock);
80103cf2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cf9:	e8 a2 06 00 00       	call   801043a0 <release>
}
80103cfe:	83 c4 10             	add    $0x10,%esp
80103d01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d04:	c9                   	leave  
80103d05:	c3                   	ret    
80103d06:	8d 76 00             	lea    0x0(%esi),%esi
80103d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d10 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	57                   	push   %edi
80103d14:	56                   	push   %esi
80103d15:	53                   	push   %ebx
80103d16:	83 ec 0c             	sub    $0xc,%esp
80103d19:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d1c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d1f:	e8 1c 05 00 00       	call   80104240 <pushcli>
  c = mycpu();
80103d24:	e8 97 f9 ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103d29:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d2f:	e8 fc 05 00 00       	call   80104330 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103d34:	85 db                	test   %ebx,%ebx
80103d36:	0f 84 87 00 00 00    	je     80103dc3 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103d3c:	85 f6                	test   %esi,%esi
80103d3e:	74 76                	je     80103db6 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d40:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103d46:	74 50                	je     80103d98 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d48:	83 ec 0c             	sub    $0xc,%esp
80103d4b:	68 20 2d 11 80       	push   $0x80112d20
80103d50:	e8 2b 05 00 00       	call   80104280 <acquire>
    release(lk);
80103d55:	89 34 24             	mov    %esi,(%esp)
80103d58:	e8 43 06 00 00       	call   801043a0 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103d5d:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80103d60:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)

  sched();
80103d67:	e8 64 fd ff ff       	call   80103ad0 <sched>

  // Tidy up.
  p->chan = 0;
80103d6c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d73:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d7a:	e8 21 06 00 00       	call   801043a0 <release>
    acquire(lk);
80103d7f:	89 75 08             	mov    %esi,0x8(%ebp)
80103d82:	83 c4 10             	add    $0x10,%esp
  }
}
80103d85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d88:	5b                   	pop    %ebx
80103d89:	5e                   	pop    %esi
80103d8a:	5f                   	pop    %edi
80103d8b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d8c:	e9 ef 04 00 00       	jmp    80104280 <acquire>
80103d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103d98:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80103d9b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)

  sched();
80103da2:	e8 29 fd ff ff       	call   80103ad0 <sched>

  // Tidy up.
  p->chan = 0;
80103da7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103db1:	5b                   	pop    %ebx
80103db2:	5e                   	pop    %esi
80103db3:	5f                   	pop    %edi
80103db4:	5d                   	pop    %ebp
80103db5:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103db6:	83 ec 0c             	sub    $0xc,%esp
80103db9:	68 6f 76 10 80       	push   $0x8010766f
80103dbe:	e8 ad c5 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103dc3:	83 ec 0c             	sub    $0xc,%esp
80103dc6:	68 69 76 10 80       	push   $0x80107669
80103dcb:	e8 a0 c5 ff ff       	call   80100370 <panic>

80103dd0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	56                   	push   %esi
80103dd4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103dd5:	e8 66 04 00 00       	call   80104240 <pushcli>
  c = mycpu();
80103dda:	e8 e1 f8 ff ff       	call   801036c0 <mycpu>
  p = c->proc;
80103ddf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103de5:	e8 46 05 00 00       	call   80104330 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103dea:	83 ec 0c             	sub    $0xc,%esp
80103ded:	68 20 2d 11 80       	push   $0x80112d20
80103df2:	e8 89 04 00 00       	call   80104280 <acquire>
80103df7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103dfa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dfc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103e01:	eb 10                	jmp    80103e13 <wait+0x43>
80103e03:	90                   	nop
80103e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e08:	83 eb 80             	sub    $0xffffff80,%ebx
80103e0b:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103e11:	74 1d                	je     80103e30 <wait+0x60>
      if(p->parent != curproc)
80103e13:	39 73 18             	cmp    %esi,0x18(%ebx)
80103e16:	75 f0                	jne    80103e08 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103e18:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
80103e1c:	74 30                	je     80103e4e <wait+0x7e>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e1e:	83 eb 80             	sub    $0xffffff80,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103e21:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e26:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103e2c:	75 e5                	jne    80103e13 <wait+0x43>
80103e2e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103e30:	85 c0                	test   %eax,%eax
80103e32:	74 70                	je     80103ea4 <wait+0xd4>
80103e34:	8b 46 28             	mov    0x28(%esi),%eax
80103e37:	85 c0                	test   %eax,%eax
80103e39:	75 69                	jne    80103ea4 <wait+0xd4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e3b:	83 ec 08             	sub    $0x8,%esp
80103e3e:	68 20 2d 11 80       	push   $0x80112d20
80103e43:	56                   	push   %esi
80103e44:	e8 c7 fe ff ff       	call   80103d10 <sleep>
  }
80103e49:	83 c4 10             	add    $0x10,%esp
80103e4c:	eb ac                	jmp    80103dfa <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103e4e:	83 ec 0c             	sub    $0xc,%esp
80103e51:	ff 73 0c             	pushl  0xc(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e54:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80103e57:	e8 64 e4 ff ff       	call   801022c0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e5c:	5a                   	pop    %edx
80103e5d:	ff 73 08             	pushl  0x8(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e60:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
80103e67:	e8 d4 2d 00 00       	call   80106c40 <freevm>
        p->pid = 0;
80103e6c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80103e73:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
80103e7a:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80103e7e:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80103e85:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
80103e8c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e93:	e8 08 05 00 00       	call   801043a0 <release>
        return pid;
80103e98:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103e9e:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ea0:	5b                   	pop    %ebx
80103ea1:	5e                   	pop    %esi
80103ea2:	5d                   	pop    %ebp
80103ea3:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103ea4:	83 ec 0c             	sub    $0xc,%esp
80103ea7:	68 20 2d 11 80       	push   $0x80112d20
80103eac:	e8 ef 04 00 00       	call   801043a0 <release>
      return -1;
80103eb1:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103eb4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ebc:	5b                   	pop    %ebx
80103ebd:	5e                   	pop    %esi
80103ebe:	5d                   	pop    %ebp
80103ebf:	c3                   	ret    

80103ec0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	53                   	push   %ebx
80103ec4:	83 ec 10             	sub    $0x10,%esp
80103ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103eca:	68 20 2d 11 80       	push   $0x80112d20
80103ecf:	e8 ac 03 00 00       	call   80104280 <acquire>
80103ed4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ed7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103edc:	eb 0c                	jmp    80103eea <wakeup+0x2a>
80103ede:	66 90                	xchg   %ax,%ax
80103ee0:	83 e8 80             	sub    $0xffffff80,%eax
80103ee3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ee8:	74 1c                	je     80103f06 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103eea:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103eee:	75 f0                	jne    80103ee0 <wakeup+0x20>
80103ef0:	3b 58 24             	cmp    0x24(%eax),%ebx
80103ef3:	75 eb                	jne    80103ee0 <wakeup+0x20>
      p->state = RUNNABLE;
80103ef5:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103efc:	83 e8 80             	sub    $0xffffff80,%eax
80103eff:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103f04:	75 e4                	jne    80103eea <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f06:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103f0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f10:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f11:	e9 8a 04 00 00       	jmp    801043a0 <release>
80103f16:	8d 76 00             	lea    0x0(%esi),%esi
80103f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f20 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
80103f24:	83 ec 10             	sub    $0x10,%esp
80103f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f2a:	68 20 2d 11 80       	push   $0x80112d20
80103f2f:	e8 4c 03 00 00       	call   80104280 <acquire>
80103f34:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f37:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f3c:	eb 0c                	jmp    80103f4a <kill+0x2a>
80103f3e:	66 90                	xchg   %ax,%ax
80103f40:	83 e8 80             	sub    $0xffffff80,%eax
80103f43:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103f48:	74 3e                	je     80103f88 <kill+0x68>
    if(p->pid == pid){
80103f4a:	39 58 14             	cmp    %ebx,0x14(%eax)
80103f4d:	75 f1                	jne    80103f40 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f4f:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103f53:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f5a:	74 1c                	je     80103f78 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f5c:	83 ec 0c             	sub    $0xc,%esp
80103f5f:	68 20 2d 11 80       	push   $0x80112d20
80103f64:	e8 37 04 00 00       	call   801043a0 <release>
      return 0;
80103f69:	83 c4 10             	add    $0x10,%esp
80103f6c:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f71:	c9                   	leave  
80103f72:	c3                   	ret    
80103f73:	90                   	nop
80103f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103f78:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
80103f7f:	eb db                	jmp    80103f5c <kill+0x3c>
80103f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103f88:	83 ec 0c             	sub    $0xc,%esp
80103f8b:	68 20 2d 11 80       	push   $0x80112d20
80103f90:	e8 0b 04 00 00       	call   801043a0 <release>
  return -1;
80103f95:	83 c4 10             	add    $0x10,%esp
80103f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fa0:	c9                   	leave  
80103fa1:	c3                   	ret    
80103fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fb0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	57                   	push   %edi
80103fb4:	56                   	push   %esi
80103fb5:	53                   	push   %ebx
80103fb6:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103fb9:	bb c4 2d 11 80       	mov    $0x80112dc4,%ebx
80103fbe:	83 ec 3c             	sub    $0x3c,%esp
80103fc1:	eb 24                	jmp    80103fe7 <procdump+0x37>
80103fc3:	90                   	nop
80103fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103fc8:	83 ec 0c             	sub    $0xc,%esp
80103fcb:	68 47 7a 10 80       	push   $0x80107a47
80103fd0:	e8 8b c6 ff ff       	call   80100660 <cprintf>
80103fd5:	83 c4 10             	add    $0x10,%esp
80103fd8:	83 eb 80             	sub    $0xffffff80,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fdb:	81 fb c4 4d 11 80    	cmp    $0x80114dc4,%ebx
80103fe1:	0f 84 81 00 00 00    	je     80104068 <procdump+0xb8>
    if(p->state == UNUSED)
80103fe7:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103fea:	85 c0                	test   %eax,%eax
80103fec:	74 ea                	je     80103fd8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fee:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103ff1:	ba 80 76 10 80       	mov    $0x80107680,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103ff6:	77 11                	ja     80104009 <procdump+0x59>
80103ff8:	8b 14 85 e0 76 10 80 	mov    -0x7fef8920(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103fff:	b8 80 76 10 80       	mov    $0x80107680,%eax
80104004:	85 d2                	test   %edx,%edx
80104006:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104009:	53                   	push   %ebx
8010400a:	52                   	push   %edx
8010400b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010400e:	68 84 76 10 80       	push   $0x80107684
80104013:	e8 48 c6 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104018:	83 c4 10             	add    $0x10,%esp
8010401b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010401f:	75 a7                	jne    80103fc8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104021:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104024:	83 ec 08             	sub    $0x8,%esp
80104027:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010402a:	50                   	push   %eax
8010402b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010402e:	8b 40 0c             	mov    0xc(%eax),%eax
80104031:	83 c0 08             	add    $0x8,%eax
80104034:	50                   	push   %eax
80104035:	e8 66 01 00 00       	call   801041a0 <getcallerpcs>
8010403a:	83 c4 10             	add    $0x10,%esp
8010403d:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104040:	8b 17                	mov    (%edi),%edx
80104042:	85 d2                	test   %edx,%edx
80104044:	74 82                	je     80103fc8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104046:	83 ec 08             	sub    $0x8,%esp
80104049:	83 c7 04             	add    $0x4,%edi
8010404c:	52                   	push   %edx
8010404d:	68 c1 70 10 80       	push   $0x801070c1
80104052:	e8 09 c6 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104057:	83 c4 10             	add    $0x10,%esp
8010405a:	39 f7                	cmp    %esi,%edi
8010405c:	75 e2                	jne    80104040 <procdump+0x90>
8010405e:	e9 65 ff ff ff       	jmp    80103fc8 <procdump+0x18>
80104063:	90                   	nop
80104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104068:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010406b:	5b                   	pop    %ebx
8010406c:	5e                   	pop    %esi
8010406d:	5f                   	pop    %edi
8010406e:	5d                   	pop    %ebp
8010406f:	c3                   	ret    

80104070 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	53                   	push   %ebx
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010407a:	68 f8 76 10 80       	push   $0x801076f8
8010407f:	8d 43 04             	lea    0x4(%ebx),%eax
80104082:	50                   	push   %eax
80104083:	e8 f8 00 00 00       	call   80104180 <initlock>
  lk->name = name;
80104088:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010408b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104091:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104094:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010409b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010409e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040a1:	c9                   	leave  
801040a2:	c3                   	ret    
801040a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	56                   	push   %esi
801040b4:	53                   	push   %ebx
801040b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	8d 73 04             	lea    0x4(%ebx),%esi
801040be:	56                   	push   %esi
801040bf:	e8 bc 01 00 00       	call   80104280 <acquire>
  while (lk->locked) {
801040c4:	8b 13                	mov    (%ebx),%edx
801040c6:	83 c4 10             	add    $0x10,%esp
801040c9:	85 d2                	test   %edx,%edx
801040cb:	74 16                	je     801040e3 <acquiresleep+0x33>
801040cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801040d0:	83 ec 08             	sub    $0x8,%esp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
801040d5:	e8 36 fc ff ff       	call   80103d10 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801040da:	8b 03                	mov    (%ebx),%eax
801040dc:	83 c4 10             	add    $0x10,%esp
801040df:	85 c0                	test   %eax,%eax
801040e1:	75 ed                	jne    801040d0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801040e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801040e9:	e8 72 f6 ff ff       	call   80103760 <myproc>
801040ee:	8b 40 14             	mov    0x14(%eax),%eax
801040f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801040f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040fa:	5b                   	pop    %ebx
801040fb:	5e                   	pop    %esi
801040fc:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801040fd:	e9 9e 02 00 00       	jmp    801043a0 <release>
80104102:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104110 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	56                   	push   %esi
80104114:	53                   	push   %ebx
80104115:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104118:	83 ec 0c             	sub    $0xc,%esp
8010411b:	8d 73 04             	lea    0x4(%ebx),%esi
8010411e:	56                   	push   %esi
8010411f:	e8 5c 01 00 00       	call   80104280 <acquire>
  lk->locked = 0;
80104124:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010412a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104131:	89 1c 24             	mov    %ebx,(%esp)
80104134:	e8 87 fd ff ff       	call   80103ec0 <wakeup>
  release(&lk->lk);
80104139:	89 75 08             	mov    %esi,0x8(%ebp)
8010413c:	83 c4 10             	add    $0x10,%esp
}
8010413f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104142:	5b                   	pop    %ebx
80104143:	5e                   	pop    %esi
80104144:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104145:	e9 56 02 00 00       	jmp    801043a0 <release>
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	56                   	push   %esi
80104154:	53                   	push   %ebx
80104155:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104158:	83 ec 0c             	sub    $0xc,%esp
8010415b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010415e:	53                   	push   %ebx
8010415f:	e8 1c 01 00 00       	call   80104280 <acquire>
  r = lk->locked;
80104164:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104166:	89 1c 24             	mov    %ebx,(%esp)
80104169:	e8 32 02 00 00       	call   801043a0 <release>
  return r;
}
8010416e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104171:	89 f0                	mov    %esi,%eax
80104173:	5b                   	pop    %ebx
80104174:	5e                   	pop    %esi
80104175:	5d                   	pop    %ebp
80104176:	c3                   	ret    
80104177:	66 90                	xchg   %ax,%ax
80104179:	66 90                	xchg   %ax,%ax
8010417b:	66 90                	xchg   %ax,%ax
8010417d:	66 90                	xchg   %ax,%ax
8010417f:	90                   	nop

80104180 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104186:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104189:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010418f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104192:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104199:	5d                   	pop    %ebp
8010419a:	c3                   	ret    
8010419b:	90                   	nop
8010419c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041a4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801041a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801041aa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801041ad:	31 c0                	xor    %eax,%eax
801041af:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801041b0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801041b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801041bc:	77 1a                	ja     801041d8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801041be:	8b 5a 04             	mov    0x4(%edx),%ebx
801041c1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041c4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801041c7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041c9:	83 f8 0a             	cmp    $0xa,%eax
801041cc:	75 e2                	jne    801041b0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801041ce:	5b                   	pop    %ebx
801041cf:	5d                   	pop    %ebp
801041d0:	c3                   	ret    
801041d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801041d8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041df:	83 c0 01             	add    $0x1,%eax
801041e2:	83 f8 0a             	cmp    $0xa,%eax
801041e5:	74 e7                	je     801041ce <getcallerpcs+0x2e>
    pcs[i] = 0;
801041e7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041ee:	83 c0 01             	add    $0x1,%eax
801041f1:	83 f8 0a             	cmp    $0xa,%eax
801041f4:	75 e2                	jne    801041d8 <getcallerpcs+0x38>
801041f6:	eb d6                	jmp    801041ce <getcallerpcs+0x2e>
801041f8:	90                   	nop
801041f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104200 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	53                   	push   %ebx
80104204:	83 ec 04             	sub    $0x4,%esp
80104207:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010420a:	8b 02                	mov    (%edx),%eax
8010420c:	85 c0                	test   %eax,%eax
8010420e:	75 10                	jne    80104220 <holding+0x20>
}
80104210:	83 c4 04             	add    $0x4,%esp
80104213:	31 c0                	xor    %eax,%eax
80104215:	5b                   	pop    %ebx
80104216:	5d                   	pop    %ebp
80104217:	c3                   	ret    
80104218:	90                   	nop
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104220:	8b 5a 08             	mov    0x8(%edx),%ebx
80104223:	e8 98 f4 ff ff       	call   801036c0 <mycpu>
80104228:	39 c3                	cmp    %eax,%ebx
8010422a:	0f 94 c0             	sete   %al
}
8010422d:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104230:	0f b6 c0             	movzbl %al,%eax
}
80104233:	5b                   	pop    %ebx
80104234:	5d                   	pop    %ebp
80104235:	c3                   	ret    
80104236:	8d 76 00             	lea    0x0(%esi),%esi
80104239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104240 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 04             	sub    $0x4,%esp
80104247:	9c                   	pushf  
80104248:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104249:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010424a:	e8 71 f4 ff ff       	call   801036c0 <mycpu>
8010424f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104255:	85 c0                	test   %eax,%eax
80104257:	75 11                	jne    8010426a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104259:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010425f:	e8 5c f4 ff ff       	call   801036c0 <mycpu>
80104264:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010426a:	e8 51 f4 ff ff       	call   801036c0 <mycpu>
8010426f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104276:	83 c4 04             	add    $0x4,%esp
80104279:	5b                   	pop    %ebx
8010427a:	5d                   	pop    %ebp
8010427b:	c3                   	ret    
8010427c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104280 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	56                   	push   %esi
80104284:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104285:	e8 b6 ff ff ff       	call   80104240 <pushcli>
  if(holding(lk))
8010428a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010428d:	8b 03                	mov    (%ebx),%eax
8010428f:	85 c0                	test   %eax,%eax
80104291:	75 7d                	jne    80104310 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104293:	ba 01 00 00 00       	mov    $0x1,%edx
80104298:	eb 09                	jmp    801042a3 <acquire+0x23>
8010429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042a3:	89 d0                	mov    %edx,%eax
801042a5:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801042a8:	85 c0                	test   %eax,%eax
801042aa:	75 f4                	jne    801042a0 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801042ac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801042b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042b4:	e8 07 f4 ff ff       	call   801036c0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801042b9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801042bb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801042be:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042c1:	31 c0                	xor    %eax,%eax
801042c3:	90                   	nop
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042c8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801042ce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801042d4:	77 1a                	ja     801042f0 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
801042d6:	8b 5a 04             	mov    0x4(%edx),%ebx
801042d9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042dc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801042df:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042e1:	83 f8 0a             	cmp    $0xa,%eax
801042e4:	75 e2                	jne    801042c8 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801042e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042e9:	5b                   	pop    %ebx
801042ea:	5e                   	pop    %esi
801042eb:	5d                   	pop    %ebp
801042ec:	c3                   	ret    
801042ed:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801042f0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042f7:	83 c0 01             	add    $0x1,%eax
801042fa:	83 f8 0a             	cmp    $0xa,%eax
801042fd:	74 e7                	je     801042e6 <acquire+0x66>
    pcs[i] = 0;
801042ff:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104306:	83 c0 01             	add    $0x1,%eax
80104309:	83 f8 0a             	cmp    $0xa,%eax
8010430c:	75 e2                	jne    801042f0 <acquire+0x70>
8010430e:	eb d6                	jmp    801042e6 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104310:	8b 73 08             	mov    0x8(%ebx),%esi
80104313:	e8 a8 f3 ff ff       	call   801036c0 <mycpu>
80104318:	39 c6                	cmp    %eax,%esi
8010431a:	0f 85 73 ff ff ff    	jne    80104293 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104320:	83 ec 0c             	sub    $0xc,%esp
80104323:	68 03 77 10 80       	push   $0x80107703
80104328:	e8 43 c0 ff ff       	call   80100370 <panic>
8010432d:	8d 76 00             	lea    0x0(%esi),%esi

80104330 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104336:	9c                   	pushf  
80104337:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104338:	f6 c4 02             	test   $0x2,%ah
8010433b:	75 52                	jne    8010438f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010433d:	e8 7e f3 ff ff       	call   801036c0 <mycpu>
80104342:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104348:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010434b:	85 d2                	test   %edx,%edx
8010434d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104353:	78 2d                	js     80104382 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104355:	e8 66 f3 ff ff       	call   801036c0 <mycpu>
8010435a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104360:	85 d2                	test   %edx,%edx
80104362:	74 0c                	je     80104370 <popcli+0x40>
    sti();
}
80104364:	c9                   	leave  
80104365:	c3                   	ret    
80104366:	8d 76 00             	lea    0x0(%esi),%esi
80104369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104370:	e8 4b f3 ff ff       	call   801036c0 <mycpu>
80104375:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010437b:	85 c0                	test   %eax,%eax
8010437d:	74 e5                	je     80104364 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010437f:	fb                   	sti    
    sti();
}
80104380:	c9                   	leave  
80104381:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104382:	83 ec 0c             	sub    $0xc,%esp
80104385:	68 22 77 10 80       	push   $0x80107722
8010438a:	e8 e1 bf ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010438f:	83 ec 0c             	sub    $0xc,%esp
80104392:	68 0b 77 10 80       	push   $0x8010770b
80104397:	e8 d4 bf ff ff       	call   80100370 <panic>
8010439c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043a0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
801043a5:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801043a8:	8b 03                	mov    (%ebx),%eax
801043aa:	85 c0                	test   %eax,%eax
801043ac:	75 12                	jne    801043c0 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801043ae:	83 ec 0c             	sub    $0xc,%esp
801043b1:	68 29 77 10 80       	push   $0x80107729
801043b6:	e8 b5 bf ff ff       	call   80100370 <panic>
801043bb:	90                   	nop
801043bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801043c0:	8b 73 08             	mov    0x8(%ebx),%esi
801043c3:	e8 f8 f2 ff ff       	call   801036c0 <mycpu>
801043c8:	39 c6                	cmp    %eax,%esi
801043ca:	75 e2                	jne    801043ae <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
801043cc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801043d3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801043da:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801043df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801043e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043e8:	5b                   	pop    %ebx
801043e9:	5e                   	pop    %esi
801043ea:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801043eb:	e9 40 ff ff ff       	jmp    80104330 <popcli>

801043f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	53                   	push   %ebx
801043f5:	8b 55 08             	mov    0x8(%ebp),%edx
801043f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801043fb:	f6 c2 03             	test   $0x3,%dl
801043fe:	75 05                	jne    80104405 <memset+0x15>
80104400:	f6 c1 03             	test   $0x3,%cl
80104403:	74 13                	je     80104418 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104405:	89 d7                	mov    %edx,%edi
80104407:	8b 45 0c             	mov    0xc(%ebp),%eax
8010440a:	fc                   	cld    
8010440b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010440d:	5b                   	pop    %ebx
8010440e:	89 d0                	mov    %edx,%eax
80104410:	5f                   	pop    %edi
80104411:	5d                   	pop    %ebp
80104412:	c3                   	ret    
80104413:	90                   	nop
80104414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104418:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010441c:	c1 e9 02             	shr    $0x2,%ecx
8010441f:	89 fb                	mov    %edi,%ebx
80104421:	89 f8                	mov    %edi,%eax
80104423:	c1 e3 18             	shl    $0x18,%ebx
80104426:	c1 e0 10             	shl    $0x10,%eax
80104429:	09 d8                	or     %ebx,%eax
8010442b:	09 f8                	or     %edi,%eax
8010442d:	c1 e7 08             	shl    $0x8,%edi
80104430:	09 f8                	or     %edi,%eax
80104432:	89 d7                	mov    %edx,%edi
80104434:	fc                   	cld    
80104435:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104437:	5b                   	pop    %ebx
80104438:	89 d0                	mov    %edx,%eax
8010443a:	5f                   	pop    %edi
8010443b:	5d                   	pop    %ebp
8010443c:	c3                   	ret    
8010443d:	8d 76 00             	lea    0x0(%esi),%esi

80104440 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	57                   	push   %edi
80104444:	56                   	push   %esi
80104445:	8b 45 10             	mov    0x10(%ebp),%eax
80104448:	53                   	push   %ebx
80104449:	8b 75 0c             	mov    0xc(%ebp),%esi
8010444c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010444f:	85 c0                	test   %eax,%eax
80104451:	74 29                	je     8010447c <memcmp+0x3c>
    if(*s1 != *s2)
80104453:	0f b6 13             	movzbl (%ebx),%edx
80104456:	0f b6 0e             	movzbl (%esi),%ecx
80104459:	38 d1                	cmp    %dl,%cl
8010445b:	75 2b                	jne    80104488 <memcmp+0x48>
8010445d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104460:	31 c0                	xor    %eax,%eax
80104462:	eb 14                	jmp    80104478 <memcmp+0x38>
80104464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104468:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010446d:	83 c0 01             	add    $0x1,%eax
80104470:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104474:	38 ca                	cmp    %cl,%dl
80104476:	75 10                	jne    80104488 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104478:	39 f8                	cmp    %edi,%eax
8010447a:	75 ec                	jne    80104468 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010447c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010447d:	31 c0                	xor    %eax,%eax
}
8010447f:	5e                   	pop    %esi
80104480:	5f                   	pop    %edi
80104481:	5d                   	pop    %ebp
80104482:	c3                   	ret    
80104483:	90                   	nop
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104488:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010448b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010448c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010448e:	5e                   	pop    %esi
8010448f:	5f                   	pop    %edi
80104490:	5d                   	pop    %ebp
80104491:	c3                   	ret    
80104492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044a0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
801044a5:	8b 45 08             	mov    0x8(%ebp),%eax
801044a8:	8b 75 0c             	mov    0xc(%ebp),%esi
801044ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801044ae:	39 c6                	cmp    %eax,%esi
801044b0:	73 2e                	jae    801044e0 <memmove+0x40>
801044b2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801044b5:	39 c8                	cmp    %ecx,%eax
801044b7:	73 27                	jae    801044e0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
801044b9:	85 db                	test   %ebx,%ebx
801044bb:	8d 53 ff             	lea    -0x1(%ebx),%edx
801044be:	74 17                	je     801044d7 <memmove+0x37>
      *--d = *--s;
801044c0:	29 d9                	sub    %ebx,%ecx
801044c2:	89 cb                	mov    %ecx,%ebx
801044c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044c8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801044cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801044cf:	83 ea 01             	sub    $0x1,%edx
801044d2:	83 fa ff             	cmp    $0xffffffff,%edx
801044d5:	75 f1                	jne    801044c8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801044d7:	5b                   	pop    %ebx
801044d8:	5e                   	pop    %esi
801044d9:	5d                   	pop    %ebp
801044da:	c3                   	ret    
801044db:	90                   	nop
801044dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044e0:	31 d2                	xor    %edx,%edx
801044e2:	85 db                	test   %ebx,%ebx
801044e4:	74 f1                	je     801044d7 <memmove+0x37>
801044e6:	8d 76 00             	lea    0x0(%esi),%esi
801044e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801044f0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801044f7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044fa:	39 d3                	cmp    %edx,%ebx
801044fc:	75 f2                	jne    801044f0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801044fe:	5b                   	pop    %ebx
801044ff:	5e                   	pop    %esi
80104500:	5d                   	pop    %ebp
80104501:	c3                   	ret    
80104502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104510 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104513:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104514:	eb 8a                	jmp    801044a0 <memmove>
80104516:	8d 76 00             	lea    0x0(%esi),%esi
80104519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104520 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	56                   	push   %esi
80104525:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104528:	53                   	push   %ebx
80104529:	8b 7d 08             	mov    0x8(%ebp),%edi
8010452c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010452f:	85 c9                	test   %ecx,%ecx
80104531:	74 37                	je     8010456a <strncmp+0x4a>
80104533:	0f b6 17             	movzbl (%edi),%edx
80104536:	0f b6 1e             	movzbl (%esi),%ebx
80104539:	84 d2                	test   %dl,%dl
8010453b:	74 3f                	je     8010457c <strncmp+0x5c>
8010453d:	38 d3                	cmp    %dl,%bl
8010453f:	75 3b                	jne    8010457c <strncmp+0x5c>
80104541:	8d 47 01             	lea    0x1(%edi),%eax
80104544:	01 cf                	add    %ecx,%edi
80104546:	eb 1b                	jmp    80104563 <strncmp+0x43>
80104548:	90                   	nop
80104549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104550:	0f b6 10             	movzbl (%eax),%edx
80104553:	84 d2                	test   %dl,%dl
80104555:	74 21                	je     80104578 <strncmp+0x58>
80104557:	0f b6 19             	movzbl (%ecx),%ebx
8010455a:	83 c0 01             	add    $0x1,%eax
8010455d:	89 ce                	mov    %ecx,%esi
8010455f:	38 da                	cmp    %bl,%dl
80104561:	75 19                	jne    8010457c <strncmp+0x5c>
80104563:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104565:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104568:	75 e6                	jne    80104550 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010456a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010456b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010456d:	5e                   	pop    %esi
8010456e:	5f                   	pop    %edi
8010456f:	5d                   	pop    %ebp
80104570:	c3                   	ret    
80104571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104578:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010457c:	0f b6 c2             	movzbl %dl,%eax
8010457f:	29 d8                	sub    %ebx,%eax
}
80104581:	5b                   	pop    %ebx
80104582:	5e                   	pop    %esi
80104583:	5f                   	pop    %edi
80104584:	5d                   	pop    %ebp
80104585:	c3                   	ret    
80104586:	8d 76 00             	lea    0x0(%esi),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 45 08             	mov    0x8(%ebp),%eax
80104598:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010459b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010459e:	89 c2                	mov    %eax,%edx
801045a0:	eb 19                	jmp    801045bb <strncpy+0x2b>
801045a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045a8:	83 c3 01             	add    $0x1,%ebx
801045ab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801045af:	83 c2 01             	add    $0x1,%edx
801045b2:	84 c9                	test   %cl,%cl
801045b4:	88 4a ff             	mov    %cl,-0x1(%edx)
801045b7:	74 09                	je     801045c2 <strncpy+0x32>
801045b9:	89 f1                	mov    %esi,%ecx
801045bb:	85 c9                	test   %ecx,%ecx
801045bd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801045c0:	7f e6                	jg     801045a8 <strncpy+0x18>
    ;
  while(n-- > 0)
801045c2:	31 c9                	xor    %ecx,%ecx
801045c4:	85 f6                	test   %esi,%esi
801045c6:	7e 17                	jle    801045df <strncpy+0x4f>
801045c8:	90                   	nop
801045c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801045d0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801045d4:	89 f3                	mov    %esi,%ebx
801045d6:	83 c1 01             	add    $0x1,%ecx
801045d9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801045db:	85 db                	test   %ebx,%ebx
801045dd:	7f f1                	jg     801045d0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
801045df:	5b                   	pop    %ebx
801045e0:	5e                   	pop    %esi
801045e1:	5d                   	pop    %ebp
801045e2:	c3                   	ret    
801045e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045f8:	8b 45 08             	mov    0x8(%ebp),%eax
801045fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801045fe:	85 c9                	test   %ecx,%ecx
80104600:	7e 26                	jle    80104628 <safestrcpy+0x38>
80104602:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104606:	89 c1                	mov    %eax,%ecx
80104608:	eb 17                	jmp    80104621 <safestrcpy+0x31>
8010460a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104610:	83 c2 01             	add    $0x1,%edx
80104613:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104617:	83 c1 01             	add    $0x1,%ecx
8010461a:	84 db                	test   %bl,%bl
8010461c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010461f:	74 04                	je     80104625 <safestrcpy+0x35>
80104621:	39 f2                	cmp    %esi,%edx
80104623:	75 eb                	jne    80104610 <safestrcpy+0x20>
    ;
  *s = 0;
80104625:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104628:	5b                   	pop    %ebx
80104629:	5e                   	pop    %esi
8010462a:	5d                   	pop    %ebp
8010462b:	c3                   	ret    
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104630 <strlen>:

int
strlen(const char *s)
{
80104630:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104631:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104633:	89 e5                	mov    %esp,%ebp
80104635:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104638:	80 3a 00             	cmpb   $0x0,(%edx)
8010463b:	74 0c                	je     80104649 <strlen+0x19>
8010463d:	8d 76 00             	lea    0x0(%esi),%esi
80104640:	83 c0 01             	add    $0x1,%eax
80104643:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104647:	75 f7                	jne    80104640 <strlen+0x10>
    ;
  return n;
}
80104649:	5d                   	pop    %ebp
8010464a:	c3                   	ret    

8010464b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010464b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010464f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104653:	55                   	push   %ebp
  pushl %ebx
80104654:	53                   	push   %ebx
  pushl %esi
80104655:	56                   	push   %esi
  pushl %edi
80104656:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104657:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104659:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010465b:	5f                   	pop    %edi
  popl %esi
8010465c:	5e                   	pop    %esi
  popl %ebx
8010465d:	5b                   	pop    %ebx
  popl %ebp
8010465e:	5d                   	pop    %ebp
  ret
8010465f:	c3                   	ret    

80104660 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	8b 45 08             	mov    0x8(%ebp),%eax
  //struct proc *curproc = myproc();
  //if(addr >= curproc->sz || addr+4 > curproc->sz)
  if (addr >= KERNBASE - 4) //cs153_lab3: addr shouldn't come from above user statck base
80104666:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
8010466b:	77 13                	ja     80104680 <fetchint+0x20>
    return -1;

  *ip = *(int*)(addr);
8010466d:	8b 10                	mov    (%eax),%edx
8010466f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104672:	89 10                	mov    %edx,(%eax)
  return 0;
80104674:	31 c0                	xor    %eax,%eax
}
80104676:	5d                   	pop    %ebp
80104677:	c3                   	ret    
80104678:	90                   	nop
80104679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  //struct proc *curproc = myproc();
  //if(addr >= curproc->sz || addr+4 > curproc->sz)
  if (addr >= KERNBASE - 4) //cs153_lab3: addr shouldn't come from above user statck base
    return -1;
80104680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  *ip = *(int*)(addr);
  return 0;
}
80104685:	5d                   	pop    %ebp
80104686:	c3                   	ret    
80104687:	89 f6                	mov    %esi,%esi
80104689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104690 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	8b 55 08             	mov    0x8(%ebp),%edx
  char *s, *ep;
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz)
  if (addr >= KERNBASE - 4) //cs153_lab3: addr shouldn't come from above user stack base
80104696:	81 fa fb ff ff 7f    	cmp    $0x7ffffffb,%edx
8010469c:	77 21                	ja     801046bf <fetchstr+0x2f>
    return -1;

  *pp = (char*)addr;
8010469e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801046a1:	89 d0                	mov    %edx,%eax
801046a3:	89 11                	mov    %edx,(%ecx)
  ep = (char*)(KERNBASE - 4); //cs153_lab3: s shouldn't go above user stack base in thr following for loop
  //ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
801046a5:	80 3a 00             	cmpb   $0x0,(%edx)
801046a8:	75 0b                	jne    801046b5 <fetchstr+0x25>
801046aa:	eb 24                	jmp    801046d0 <fetchstr+0x40>
801046ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046b0:	80 38 00             	cmpb   $0x0,(%eax)
801046b3:	74 1b                	je     801046d0 <fetchstr+0x40>
    return -1;

  *pp = (char*)addr;
  ep = (char*)(KERNBASE - 4); //cs153_lab3: s shouldn't go above user stack base in thr following for loop
  //ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
801046b5:	83 c0 01             	add    $0x1,%eax
801046b8:	3d fc ff ff 7f       	cmp    $0x7ffffffc,%eax
801046bd:	75 f1                	jne    801046b0 <fetchstr+0x20>
  char *s, *ep;
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz)
  if (addr >= KERNBASE - 4) //cs153_lab3: addr shouldn't come from above user stack base
    return -1;
801046bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801046c4:	5d                   	pop    %ebp
801046c5:	c3                   	ret    
801046c6:	8d 76 00             	lea    0x0(%esi),%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  *pp = (char*)addr;
  ep = (char*)(KERNBASE - 4); //cs153_lab3: s shouldn't go above user stack base in thr following for loop
  //ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801046d0:	29 d0                	sub    %edx,%eax
  }
  return -1;
}
801046d2:	5d                   	pop    %ebp
801046d3:	c3                   	ret    
801046d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801046e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046e6:	e8 75 f0 ff ff       	call   80103760 <myproc>
801046eb:	8b 40 1c             	mov    0x1c(%eax),%eax
801046ee:	8b 55 08             	mov    0x8(%ebp),%edx
801046f1:	8b 40 44             	mov    0x44(%eax),%eax
801046f4:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
int
fetchint(uint addr, int *ip)
{
  //struct proc *curproc = myproc();
  //if(addr >= curproc->sz || addr+4 > curproc->sz)
  if (addr >= KERNBASE - 4) //cs153_lab3: addr shouldn't come from above user statck base
801046f8:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
801046fd:	77 11                	ja     80104710 <argint+0x30>
    return -1;

  *ip = *(int*)(addr);
801046ff:	8b 10                	mov    (%eax),%edx
80104701:	8b 45 0c             	mov    0xc(%ebp),%eax
80104704:	89 10                	mov    %edx,(%eax)
  return 0;
80104706:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104708:	c9                   	leave  
80104709:	c3                   	ret    
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fetchint(uint addr, int *ip)
{
  //struct proc *curproc = myproc();
  //if(addr >= curproc->sz || addr+4 > curproc->sz)
  if (addr >= KERNBASE - 4) //cs153_lab3: addr shouldn't come from above user statck base
    return -1;
80104710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104715:	c9                   	leave  
80104716:	c3                   	ret    
80104717:	89 f6                	mov    %esi,%esi
80104719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104720 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 04             	sub    $0x4,%esp
80104727:	8b 5d 10             	mov    0x10(%ebp),%ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010472a:	e8 31 f0 ff ff       	call   80103760 <myproc>
8010472f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104732:	8b 55 08             	mov    0x8(%ebp),%edx
80104735:	8b 40 44             	mov    0x44(%eax),%eax
80104738:	8d 54 90 04          	lea    0x4(%eax,%edx,4),%edx
  int i;
  //struct proc *curproc = myproc();
  uint ustackbase = KERNBASE - 4; 

  if(argint(n, &i) < 0)
    return -1;
8010473c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
int
fetchint(uint addr, int *ip)
{
  //struct proc *curproc = myproc();
  //if(addr >= curproc->sz || addr+4 > curproc->sz)
  if (addr >= KERNBASE - 4) //cs153_lab3: addr shouldn't come from above user statck base
80104741:	81 fa fb ff ff 7f    	cmp    $0x7ffffffb,%edx
80104747:	77 1f                	ja     80104768 <argptr+0x48>
  uint ustackbase = KERNBASE - 4; 

  if(argint(n, &i) < 0)
    return -1;
  //if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
  if(size < 0 || (uint)i >= ustackbase || (uint)i+size > ustackbase)
80104749:	85 db                	test   %ebx,%ebx
  //struct proc *curproc = myproc();
  //if(addr >= curproc->sz || addr+4 > curproc->sz)
  if (addr >= KERNBASE - 4) //cs153_lab3: addr shouldn't come from above user statck base
    return -1;

  *ip = *(int*)(addr);
8010474b:	8b 12                	mov    (%edx),%edx
  uint ustackbase = KERNBASE - 4; 

  if(argint(n, &i) < 0)
    return -1;
  //if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
  if(size < 0 || (uint)i >= ustackbase || (uint)i+size > ustackbase)
8010474d:	78 19                	js     80104768 <argptr+0x48>
8010474f:	81 fa fb ff ff 7f    	cmp    $0x7ffffffb,%edx
80104755:	77 11                	ja     80104768 <argptr+0x48>
80104757:	01 d3                	add    %edx,%ebx
80104759:	81 fb fc ff ff 7f    	cmp    $0x7ffffffc,%ebx
8010475f:	77 07                	ja     80104768 <argptr+0x48>
    return -1;


  *pp = (char*)i;
80104761:	8b 45 0c             	mov    0xc(%ebp),%eax
80104764:	89 10                	mov    %edx,(%eax)
  return 0;
80104766:	31 c0                	xor    %eax,%eax
}
80104768:	83 c4 04             	add    $0x4,%esp
8010476b:	5b                   	pop    %ebx
8010476c:	5d                   	pop    %ebp
8010476d:	c3                   	ret    
8010476e:	66 90                	xchg   %ax,%ax

80104770 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	83 ec 08             	sub    $0x8,%esp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104776:	e8 e5 ef ff ff       	call   80103760 <myproc>
8010477b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010477e:	8b 55 08             	mov    0x8(%ebp),%edx
80104781:	8b 40 44             	mov    0x44(%eax),%eax
80104784:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
int
fetchint(uint addr, int *ip)
{
  //struct proc *curproc = myproc();
  //if(addr >= curproc->sz || addr+4 > curproc->sz)
  if (addr >= KERNBASE - 4) //cs153_lab3: addr shouldn't come from above user statck base
80104788:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
8010478d:	77 30                	ja     801047bf <argstr+0x4f>
    return -1;

  *ip = *(int*)(addr);
8010478f:	8b 10                	mov    (%eax),%edx
{
  char *s, *ep;
  //struct proc *curproc = myproc();

  //if(addr >= curproc->sz)
  if (addr >= KERNBASE - 4) //cs153_lab3: addr shouldn't come from above user stack base
80104791:	81 fa fb ff ff 7f    	cmp    $0x7ffffffb,%edx
80104797:	77 26                	ja     801047bf <argstr+0x4f>
    return -1;

  *pp = (char*)addr;
80104799:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010479c:	89 d0                	mov    %edx,%eax
8010479e:	89 11                	mov    %edx,(%ecx)
  ep = (char*)(KERNBASE - 4); //cs153_lab3: s shouldn't go above user stack base in thr following for loop
  //ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
801047a0:	7f 1d                	jg     801047bf <argstr+0x4f>
    if(*s == 0)
801047a2:	80 3a 00             	cmpb   $0x0,(%edx)
801047a5:	75 0e                	jne    801047b5 <argstr+0x45>
801047a7:	eb 27                	jmp    801047d0 <argstr+0x60>
801047a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047b0:	80 38 00             	cmpb   $0x0,(%eax)
801047b3:	74 1b                	je     801047d0 <argstr+0x60>
    return -1;

  *pp = (char*)addr;
  ep = (char*)(KERNBASE - 4); //cs153_lab3: s shouldn't go above user stack base in thr following for loop
  //ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
801047b5:	83 c0 01             	add    $0x1,%eax
801047b8:	3d fb ff ff 7f       	cmp    $0x7ffffffb,%eax
801047bd:	76 f1                	jbe    801047b0 <argstr+0x40>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801047bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801047c4:	c9                   	leave  
801047c5:	c3                   	ret    
801047c6:	8d 76 00             	lea    0x0(%esi),%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  *pp = (char*)addr;
  ep = (char*)(KERNBASE - 4); //cs153_lab3: s shouldn't go above user stack base in thr following for loop
  //ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801047d0:	29 d0                	sub    %edx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801047d2:	c9                   	leave  
801047d3:	c3                   	ret    
801047d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801047e0 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801047e5:	e8 76 ef ff ff       	call   80103760 <myproc>

  num = curproc->tf->eax;
801047ea:	8b 70 1c             	mov    0x1c(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801047ed:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801047ef:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801047f2:	8d 50 ff             	lea    -0x1(%eax),%edx
801047f5:	83 fa 16             	cmp    $0x16,%edx
801047f8:	77 1e                	ja     80104818 <syscall+0x38>
801047fa:	8b 14 85 60 77 10 80 	mov    -0x7fef88a0(,%eax,4),%edx
80104801:	85 d2                	test   %edx,%edx
80104803:	74 13                	je     80104818 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104805:	ff d2                	call   *%edx
80104807:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010480a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010480d:	5b                   	pop    %ebx
8010480e:	5e                   	pop    %esi
8010480f:	5d                   	pop    %ebp
80104810:	c3                   	ret    
80104811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104818:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104819:	8d 43 70             	lea    0x70(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010481c:	50                   	push   %eax
8010481d:	ff 73 14             	pushl  0x14(%ebx)
80104820:	68 31 77 10 80       	push   $0x80107731
80104825:	e8 36 be ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010482a:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010482d:	83 c4 10             	add    $0x10,%esp
80104830:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104837:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010483a:	5b                   	pop    %ebx
8010483b:	5e                   	pop    %esi
8010483c:	5d                   	pop    %ebp
8010483d:	c3                   	ret    
8010483e:	66 90                	xchg   %ax,%ax

80104840 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	56                   	push   %esi
80104845:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104846:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104849:	83 ec 44             	sub    $0x44,%esp
8010484c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010484f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104852:	56                   	push   %esi
80104853:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104854:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104857:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010485a:	e8 61 d6 ff ff       	call   80101ec0 <nameiparent>
8010485f:	83 c4 10             	add    $0x10,%esp
80104862:	85 c0                	test   %eax,%eax
80104864:	0f 84 f6 00 00 00    	je     80104960 <create+0x120>
    return 0;
  ilock(dp);
8010486a:	83 ec 0c             	sub    $0xc,%esp
8010486d:	89 c7                	mov    %eax,%edi
8010486f:	50                   	push   %eax
80104870:	e8 db cd ff ff       	call   80101650 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104875:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104878:	83 c4 0c             	add    $0xc,%esp
8010487b:	50                   	push   %eax
8010487c:	56                   	push   %esi
8010487d:	57                   	push   %edi
8010487e:	e8 fd d2 ff ff       	call   80101b80 <dirlookup>
80104883:	83 c4 10             	add    $0x10,%esp
80104886:	85 c0                	test   %eax,%eax
80104888:	89 c3                	mov    %eax,%ebx
8010488a:	74 54                	je     801048e0 <create+0xa0>
    iunlockput(dp);
8010488c:	83 ec 0c             	sub    $0xc,%esp
8010488f:	57                   	push   %edi
80104890:	e8 4b d0 ff ff       	call   801018e0 <iunlockput>
    ilock(ip);
80104895:	89 1c 24             	mov    %ebx,(%esp)
80104898:	e8 b3 cd ff ff       	call   80101650 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010489d:	83 c4 10             	add    $0x10,%esp
801048a0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801048a5:	75 19                	jne    801048c0 <create+0x80>
801048a7:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801048ac:	89 d8                	mov    %ebx,%eax
801048ae:	75 10                	jne    801048c0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048b3:	5b                   	pop    %ebx
801048b4:	5e                   	pop    %esi
801048b5:	5f                   	pop    %edi
801048b6:	5d                   	pop    %ebp
801048b7:	c3                   	ret    
801048b8:	90                   	nop
801048b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801048c0:	83 ec 0c             	sub    $0xc,%esp
801048c3:	53                   	push   %ebx
801048c4:	e8 17 d0 ff ff       	call   801018e0 <iunlockput>
    return 0;
801048c9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801048cf:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801048d1:	5b                   	pop    %ebx
801048d2:	5e                   	pop    %esi
801048d3:	5f                   	pop    %edi
801048d4:	5d                   	pop    %ebp
801048d5:	c3                   	ret    
801048d6:	8d 76 00             	lea    0x0(%esi),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801048e0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801048e4:	83 ec 08             	sub    $0x8,%esp
801048e7:	50                   	push   %eax
801048e8:	ff 37                	pushl  (%edi)
801048ea:	e8 f1 cb ff ff       	call   801014e0 <ialloc>
801048ef:	83 c4 10             	add    $0x10,%esp
801048f2:	85 c0                	test   %eax,%eax
801048f4:	89 c3                	mov    %eax,%ebx
801048f6:	0f 84 cc 00 00 00    	je     801049c8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
801048fc:	83 ec 0c             	sub    $0xc,%esp
801048ff:	50                   	push   %eax
80104900:	e8 4b cd ff ff       	call   80101650 <ilock>
  ip->major = major;
80104905:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104909:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010490d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104911:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104915:	b8 01 00 00 00       	mov    $0x1,%eax
8010491a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010491e:	89 1c 24             	mov    %ebx,(%esp)
80104921:	e8 7a cc ff ff       	call   801015a0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104926:	83 c4 10             	add    $0x10,%esp
80104929:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010492e:	74 40                	je     80104970 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104930:	83 ec 04             	sub    $0x4,%esp
80104933:	ff 73 04             	pushl  0x4(%ebx)
80104936:	56                   	push   %esi
80104937:	57                   	push   %edi
80104938:	e8 a3 d4 ff ff       	call   80101de0 <dirlink>
8010493d:	83 c4 10             	add    $0x10,%esp
80104940:	85 c0                	test   %eax,%eax
80104942:	78 77                	js     801049bb <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104944:	83 ec 0c             	sub    $0xc,%esp
80104947:	57                   	push   %edi
80104948:	e8 93 cf ff ff       	call   801018e0 <iunlockput>

  return ip;
8010494d:	83 c4 10             	add    $0x10,%esp
}
80104950:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104953:	89 d8                	mov    %ebx,%eax
}
80104955:	5b                   	pop    %ebx
80104956:	5e                   	pop    %esi
80104957:	5f                   	pop    %edi
80104958:	5d                   	pop    %ebp
80104959:	c3                   	ret    
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104960:	31 c0                	xor    %eax,%eax
80104962:	e9 49 ff ff ff       	jmp    801048b0 <create+0x70>
80104967:	89 f6                	mov    %esi,%esi
80104969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104970:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104975:	83 ec 0c             	sub    $0xc,%esp
80104978:	57                   	push   %edi
80104979:	e8 22 cc ff ff       	call   801015a0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010497e:	83 c4 0c             	add    $0xc,%esp
80104981:	ff 73 04             	pushl  0x4(%ebx)
80104984:	68 dc 77 10 80       	push   $0x801077dc
80104989:	53                   	push   %ebx
8010498a:	e8 51 d4 ff ff       	call   80101de0 <dirlink>
8010498f:	83 c4 10             	add    $0x10,%esp
80104992:	85 c0                	test   %eax,%eax
80104994:	78 18                	js     801049ae <create+0x16e>
80104996:	83 ec 04             	sub    $0x4,%esp
80104999:	ff 77 04             	pushl  0x4(%edi)
8010499c:	68 db 77 10 80       	push   $0x801077db
801049a1:	53                   	push   %ebx
801049a2:	e8 39 d4 ff ff       	call   80101de0 <dirlink>
801049a7:	83 c4 10             	add    $0x10,%esp
801049aa:	85 c0                	test   %eax,%eax
801049ac:	79 82                	jns    80104930 <create+0xf0>
      panic("create dots");
801049ae:	83 ec 0c             	sub    $0xc,%esp
801049b1:	68 cf 77 10 80       	push   $0x801077cf
801049b6:	e8 b5 b9 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
801049bb:	83 ec 0c             	sub    $0xc,%esp
801049be:	68 de 77 10 80       	push   $0x801077de
801049c3:	e8 a8 b9 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	68 c0 77 10 80       	push   $0x801077c0
801049d0:	e8 9b b9 ff ff       	call   80100370 <panic>
801049d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801049e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801049ea:	89 d3                	mov    %edx,%ebx
801049ec:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801049ef:	50                   	push   %eax
801049f0:	6a 00                	push   $0x0
801049f2:	e8 e9 fc ff ff       	call   801046e0 <argint>
801049f7:	83 c4 10             	add    $0x10,%esp
801049fa:	85 c0                	test   %eax,%eax
801049fc:	78 32                	js     80104a30 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801049fe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a02:	77 2c                	ja     80104a30 <argfd.constprop.0+0x50>
80104a04:	e8 57 ed ff ff       	call   80103760 <myproc>
80104a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a0c:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
80104a10:	85 c0                	test   %eax,%eax
80104a12:	74 1c                	je     80104a30 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104a14:	85 f6                	test   %esi,%esi
80104a16:	74 02                	je     80104a1a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104a18:	89 16                	mov    %edx,(%esi)
  if(pf)
80104a1a:	85 db                	test   %ebx,%ebx
80104a1c:	74 22                	je     80104a40 <argfd.constprop.0+0x60>
    *pf = f;
80104a1e:	89 03                	mov    %eax,(%ebx)
  return 0;
80104a20:	31 c0                	xor    %eax,%eax
}
80104a22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a25:	5b                   	pop    %ebx
80104a26:	5e                   	pop    %esi
80104a27:	5d                   	pop    %ebp
80104a28:	c3                   	ret    
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a30:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104a33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104a38:	5b                   	pop    %ebx
80104a39:	5e                   	pop    %esi
80104a3a:	5d                   	pop    %ebp
80104a3b:	c3                   	ret    
80104a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104a40:	31 c0                	xor    %eax,%eax
80104a42:	eb de                	jmp    80104a22 <argfd.constprop.0+0x42>
80104a44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a50 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104a50:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a51:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104a53:	89 e5                	mov    %esp,%ebp
80104a55:	56                   	push   %esi
80104a56:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a57:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104a5a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104a5d:	e8 7e ff ff ff       	call   801049e0 <argfd.constprop.0>
80104a62:	85 c0                	test   %eax,%eax
80104a64:	78 1a                	js     80104a80 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104a66:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104a68:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104a6b:	e8 f0 ec ff ff       	call   80103760 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104a70:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80104a74:	85 d2                	test   %edx,%edx
80104a76:	74 18                	je     80104a90 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104a78:	83 c3 01             	add    $0x1,%ebx
80104a7b:	83 fb 10             	cmp    $0x10,%ebx
80104a7e:	75 f0                	jne    80104a70 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a80:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104a83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a88:	5b                   	pop    %ebx
80104a89:	5e                   	pop    %esi
80104a8a:	5d                   	pop    %ebp
80104a8b:	c3                   	ret    
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104a90:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104a94:	83 ec 0c             	sub    $0xc,%esp
80104a97:	ff 75 f4             	pushl  -0xc(%ebp)
80104a9a:	e8 21 c3 ff ff       	call   80100dc0 <filedup>
  return fd;
80104a9f:	83 c4 10             	add    $0x10,%esp
}
80104aa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104aa5:	89 d8                	mov    %ebx,%eax
}
80104aa7:	5b                   	pop    %ebx
80104aa8:	5e                   	pop    %esi
80104aa9:	5d                   	pop    %ebp
80104aaa:	c3                   	ret    
80104aab:	90                   	nop
80104aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ab0 <sys_read>:

int
sys_read(void)
{
80104ab0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ab1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104ab3:	89 e5                	mov    %esp,%ebp
80104ab5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ab8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104abb:	e8 20 ff ff ff       	call   801049e0 <argfd.constprop.0>
80104ac0:	85 c0                	test   %eax,%eax
80104ac2:	78 4c                	js     80104b10 <sys_read+0x60>
80104ac4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ac7:	83 ec 08             	sub    $0x8,%esp
80104aca:	50                   	push   %eax
80104acb:	6a 02                	push   $0x2
80104acd:	e8 0e fc ff ff       	call   801046e0 <argint>
80104ad2:	83 c4 10             	add    $0x10,%esp
80104ad5:	85 c0                	test   %eax,%eax
80104ad7:	78 37                	js     80104b10 <sys_read+0x60>
80104ad9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104adc:	83 ec 04             	sub    $0x4,%esp
80104adf:	ff 75 f0             	pushl  -0x10(%ebp)
80104ae2:	50                   	push   %eax
80104ae3:	6a 01                	push   $0x1
80104ae5:	e8 36 fc ff ff       	call   80104720 <argptr>
80104aea:	83 c4 10             	add    $0x10,%esp
80104aed:	85 c0                	test   %eax,%eax
80104aef:	78 1f                	js     80104b10 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104af1:	83 ec 04             	sub    $0x4,%esp
80104af4:	ff 75 f0             	pushl  -0x10(%ebp)
80104af7:	ff 75 f4             	pushl  -0xc(%ebp)
80104afa:	ff 75 ec             	pushl  -0x14(%ebp)
80104afd:	e8 2e c4 ff ff       	call   80100f30 <fileread>
80104b02:	83 c4 10             	add    $0x10,%esp
}
80104b05:	c9                   	leave  
80104b06:	c3                   	ret    
80104b07:	89 f6                	mov    %esi,%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104b15:	c9                   	leave  
80104b16:	c3                   	ret    
80104b17:	89 f6                	mov    %esi,%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <sys_write>:

int
sys_write(void)
{
80104b20:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b21:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104b23:	89 e5                	mov    %esp,%ebp
80104b25:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b28:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b2b:	e8 b0 fe ff ff       	call   801049e0 <argfd.constprop.0>
80104b30:	85 c0                	test   %eax,%eax
80104b32:	78 4c                	js     80104b80 <sys_write+0x60>
80104b34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b37:	83 ec 08             	sub    $0x8,%esp
80104b3a:	50                   	push   %eax
80104b3b:	6a 02                	push   $0x2
80104b3d:	e8 9e fb ff ff       	call   801046e0 <argint>
80104b42:	83 c4 10             	add    $0x10,%esp
80104b45:	85 c0                	test   %eax,%eax
80104b47:	78 37                	js     80104b80 <sys_write+0x60>
80104b49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b4c:	83 ec 04             	sub    $0x4,%esp
80104b4f:	ff 75 f0             	pushl  -0x10(%ebp)
80104b52:	50                   	push   %eax
80104b53:	6a 01                	push   $0x1
80104b55:	e8 c6 fb ff ff       	call   80104720 <argptr>
80104b5a:	83 c4 10             	add    $0x10,%esp
80104b5d:	85 c0                	test   %eax,%eax
80104b5f:	78 1f                	js     80104b80 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104b61:	83 ec 04             	sub    $0x4,%esp
80104b64:	ff 75 f0             	pushl  -0x10(%ebp)
80104b67:	ff 75 f4             	pushl  -0xc(%ebp)
80104b6a:	ff 75 ec             	pushl  -0x14(%ebp)
80104b6d:	e8 4e c4 ff ff       	call   80100fc0 <filewrite>
80104b72:	83 c4 10             	add    $0x10,%esp
}
80104b75:	c9                   	leave  
80104b76:	c3                   	ret    
80104b77:	89 f6                	mov    %esi,%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104b85:	c9                   	leave  
80104b86:	c3                   	ret    
80104b87:	89 f6                	mov    %esi,%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b90 <sys_close>:

int
sys_close(void)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104b96:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b99:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b9c:	e8 3f fe ff ff       	call   801049e0 <argfd.constprop.0>
80104ba1:	85 c0                	test   %eax,%eax
80104ba3:	78 2b                	js     80104bd0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104ba5:	e8 b6 eb ff ff       	call   80103760 <myproc>
80104baa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104bad:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104bb0:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
80104bb7:	00 
  fileclose(f);
80104bb8:	ff 75 f4             	pushl  -0xc(%ebp)
80104bbb:	e8 50 c2 ff ff       	call   80100e10 <fileclose>
  return 0;
80104bc0:	83 c4 10             	add    $0x10,%esp
80104bc3:	31 c0                	xor    %eax,%eax
}
80104bc5:	c9                   	leave  
80104bc6:	c3                   	ret    
80104bc7:	89 f6                	mov    %esi,%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104bd5:	c9                   	leave  
80104bd6:	c3                   	ret    
80104bd7:	89 f6                	mov    %esi,%esi
80104bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104be0 <sys_fstat>:

int
sys_fstat(void)
{
80104be0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104be1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104be8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104beb:	e8 f0 fd ff ff       	call   801049e0 <argfd.constprop.0>
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	78 2c                	js     80104c20 <sys_fstat+0x40>
80104bf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bf7:	83 ec 04             	sub    $0x4,%esp
80104bfa:	6a 14                	push   $0x14
80104bfc:	50                   	push   %eax
80104bfd:	6a 01                	push   $0x1
80104bff:	e8 1c fb ff ff       	call   80104720 <argptr>
80104c04:	83 c4 10             	add    $0x10,%esp
80104c07:	85 c0                	test   %eax,%eax
80104c09:	78 15                	js     80104c20 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104c0b:	83 ec 08             	sub    $0x8,%esp
80104c0e:	ff 75 f4             	pushl  -0xc(%ebp)
80104c11:	ff 75 f0             	pushl  -0x10(%ebp)
80104c14:	e8 c7 c2 ff ff       	call   80100ee0 <filestat>
80104c19:	83 c4 10             	add    $0x10,%esp
}
80104c1c:	c9                   	leave  
80104c1d:	c3                   	ret    
80104c1e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104c25:	c9                   	leave  
80104c26:	c3                   	ret    
80104c27:	89 f6                	mov    %esi,%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	57                   	push   %edi
80104c34:	56                   	push   %esi
80104c35:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104c36:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104c39:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104c3c:	50                   	push   %eax
80104c3d:	6a 00                	push   $0x0
80104c3f:	e8 2c fb ff ff       	call   80104770 <argstr>
80104c44:	83 c4 10             	add    $0x10,%esp
80104c47:	85 c0                	test   %eax,%eax
80104c49:	0f 88 fb 00 00 00    	js     80104d4a <sys_link+0x11a>
80104c4f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104c52:	83 ec 08             	sub    $0x8,%esp
80104c55:	50                   	push   %eax
80104c56:	6a 01                	push   $0x1
80104c58:	e8 13 fb ff ff       	call   80104770 <argstr>
80104c5d:	83 c4 10             	add    $0x10,%esp
80104c60:	85 c0                	test   %eax,%eax
80104c62:	0f 88 e2 00 00 00    	js     80104d4a <sys_link+0x11a>
    return -1;

  begin_op();
80104c68:	e8 c3 de ff ff       	call   80102b30 <begin_op>
  if((ip = namei(old)) == 0){
80104c6d:	83 ec 0c             	sub    $0xc,%esp
80104c70:	ff 75 d4             	pushl  -0x2c(%ebp)
80104c73:	e8 28 d2 ff ff       	call   80101ea0 <namei>
80104c78:	83 c4 10             	add    $0x10,%esp
80104c7b:	85 c0                	test   %eax,%eax
80104c7d:	89 c3                	mov    %eax,%ebx
80104c7f:	0f 84 f3 00 00 00    	je     80104d78 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104c85:	83 ec 0c             	sub    $0xc,%esp
80104c88:	50                   	push   %eax
80104c89:	e8 c2 c9 ff ff       	call   80101650 <ilock>
  if(ip->type == T_DIR){
80104c8e:	83 c4 10             	add    $0x10,%esp
80104c91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c96:	0f 84 c4 00 00 00    	je     80104d60 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104c9c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ca1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104ca4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104ca7:	53                   	push   %ebx
80104ca8:	e8 f3 c8 ff ff       	call   801015a0 <iupdate>
  iunlock(ip);
80104cad:	89 1c 24             	mov    %ebx,(%esp)
80104cb0:	e8 7b ca ff ff       	call   80101730 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104cb5:	58                   	pop    %eax
80104cb6:	5a                   	pop    %edx
80104cb7:	57                   	push   %edi
80104cb8:	ff 75 d0             	pushl  -0x30(%ebp)
80104cbb:	e8 00 d2 ff ff       	call   80101ec0 <nameiparent>
80104cc0:	83 c4 10             	add    $0x10,%esp
80104cc3:	85 c0                	test   %eax,%eax
80104cc5:	89 c6                	mov    %eax,%esi
80104cc7:	74 5b                	je     80104d24 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104cc9:	83 ec 0c             	sub    $0xc,%esp
80104ccc:	50                   	push   %eax
80104ccd:	e8 7e c9 ff ff       	call   80101650 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104cd2:	83 c4 10             	add    $0x10,%esp
80104cd5:	8b 03                	mov    (%ebx),%eax
80104cd7:	39 06                	cmp    %eax,(%esi)
80104cd9:	75 3d                	jne    80104d18 <sys_link+0xe8>
80104cdb:	83 ec 04             	sub    $0x4,%esp
80104cde:	ff 73 04             	pushl  0x4(%ebx)
80104ce1:	57                   	push   %edi
80104ce2:	56                   	push   %esi
80104ce3:	e8 f8 d0 ff ff       	call   80101de0 <dirlink>
80104ce8:	83 c4 10             	add    $0x10,%esp
80104ceb:	85 c0                	test   %eax,%eax
80104ced:	78 29                	js     80104d18 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104cef:	83 ec 0c             	sub    $0xc,%esp
80104cf2:	56                   	push   %esi
80104cf3:	e8 e8 cb ff ff       	call   801018e0 <iunlockput>
  iput(ip);
80104cf8:	89 1c 24             	mov    %ebx,(%esp)
80104cfb:	e8 80 ca ff ff       	call   80101780 <iput>

  end_op();
80104d00:	e8 9b de ff ff       	call   80102ba0 <end_op>

  return 0;
80104d05:	83 c4 10             	add    $0x10,%esp
80104d08:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d0d:	5b                   	pop    %ebx
80104d0e:	5e                   	pop    %esi
80104d0f:	5f                   	pop    %edi
80104d10:	5d                   	pop    %ebp
80104d11:	c3                   	ret    
80104d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104d18:	83 ec 0c             	sub    $0xc,%esp
80104d1b:	56                   	push   %esi
80104d1c:	e8 bf cb ff ff       	call   801018e0 <iunlockput>
    goto bad;
80104d21:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104d24:	83 ec 0c             	sub    $0xc,%esp
80104d27:	53                   	push   %ebx
80104d28:	e8 23 c9 ff ff       	call   80101650 <ilock>
  ip->nlink--;
80104d2d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d32:	89 1c 24             	mov    %ebx,(%esp)
80104d35:	e8 66 c8 ff ff       	call   801015a0 <iupdate>
  iunlockput(ip);
80104d3a:	89 1c 24             	mov    %ebx,(%esp)
80104d3d:	e8 9e cb ff ff       	call   801018e0 <iunlockput>
  end_op();
80104d42:	e8 59 de ff ff       	call   80102ba0 <end_op>
  return -1;
80104d47:	83 c4 10             	add    $0x10,%esp
}
80104d4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104d4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d52:	5b                   	pop    %ebx
80104d53:	5e                   	pop    %esi
80104d54:	5f                   	pop    %edi
80104d55:	5d                   	pop    %ebp
80104d56:	c3                   	ret    
80104d57:	89 f6                	mov    %esi,%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104d60:	83 ec 0c             	sub    $0xc,%esp
80104d63:	53                   	push   %ebx
80104d64:	e8 77 cb ff ff       	call   801018e0 <iunlockput>
    end_op();
80104d69:	e8 32 de ff ff       	call   80102ba0 <end_op>
    return -1;
80104d6e:	83 c4 10             	add    $0x10,%esp
80104d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d76:	eb 92                	jmp    80104d0a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104d78:	e8 23 de ff ff       	call   80102ba0 <end_op>
    return -1;
80104d7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d82:	eb 86                	jmp    80104d0a <sys_link+0xda>
80104d84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d90 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	57                   	push   %edi
80104d94:	56                   	push   %esi
80104d95:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104d96:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104d99:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104d9c:	50                   	push   %eax
80104d9d:	6a 00                	push   $0x0
80104d9f:	e8 cc f9 ff ff       	call   80104770 <argstr>
80104da4:	83 c4 10             	add    $0x10,%esp
80104da7:	85 c0                	test   %eax,%eax
80104da9:	0f 88 82 01 00 00    	js     80104f31 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104daf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104db2:	e8 79 dd ff ff       	call   80102b30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104db7:	83 ec 08             	sub    $0x8,%esp
80104dba:	53                   	push   %ebx
80104dbb:	ff 75 c0             	pushl  -0x40(%ebp)
80104dbe:	e8 fd d0 ff ff       	call   80101ec0 <nameiparent>
80104dc3:	83 c4 10             	add    $0x10,%esp
80104dc6:	85 c0                	test   %eax,%eax
80104dc8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104dcb:	0f 84 6a 01 00 00    	je     80104f3b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104dd1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104dd4:	83 ec 0c             	sub    $0xc,%esp
80104dd7:	56                   	push   %esi
80104dd8:	e8 73 c8 ff ff       	call   80101650 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ddd:	58                   	pop    %eax
80104dde:	5a                   	pop    %edx
80104ddf:	68 dc 77 10 80       	push   $0x801077dc
80104de4:	53                   	push   %ebx
80104de5:	e8 76 cd ff ff       	call   80101b60 <namecmp>
80104dea:	83 c4 10             	add    $0x10,%esp
80104ded:	85 c0                	test   %eax,%eax
80104def:	0f 84 fc 00 00 00    	je     80104ef1 <sys_unlink+0x161>
80104df5:	83 ec 08             	sub    $0x8,%esp
80104df8:	68 db 77 10 80       	push   $0x801077db
80104dfd:	53                   	push   %ebx
80104dfe:	e8 5d cd ff ff       	call   80101b60 <namecmp>
80104e03:	83 c4 10             	add    $0x10,%esp
80104e06:	85 c0                	test   %eax,%eax
80104e08:	0f 84 e3 00 00 00    	je     80104ef1 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104e0e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104e11:	83 ec 04             	sub    $0x4,%esp
80104e14:	50                   	push   %eax
80104e15:	53                   	push   %ebx
80104e16:	56                   	push   %esi
80104e17:	e8 64 cd ff ff       	call   80101b80 <dirlookup>
80104e1c:	83 c4 10             	add    $0x10,%esp
80104e1f:	85 c0                	test   %eax,%eax
80104e21:	89 c3                	mov    %eax,%ebx
80104e23:	0f 84 c8 00 00 00    	je     80104ef1 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104e29:	83 ec 0c             	sub    $0xc,%esp
80104e2c:	50                   	push   %eax
80104e2d:	e8 1e c8 ff ff       	call   80101650 <ilock>

  if(ip->nlink < 1)
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104e3a:	0f 8e 24 01 00 00    	jle    80104f64 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104e40:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e45:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104e48:	74 66                	je     80104eb0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104e4a:	83 ec 04             	sub    $0x4,%esp
80104e4d:	6a 10                	push   $0x10
80104e4f:	6a 00                	push   $0x0
80104e51:	56                   	push   %esi
80104e52:	e8 99 f5 ff ff       	call   801043f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e57:	6a 10                	push   $0x10
80104e59:	ff 75 c4             	pushl  -0x3c(%ebp)
80104e5c:	56                   	push   %esi
80104e5d:	ff 75 b4             	pushl  -0x4c(%ebp)
80104e60:	e8 cb cb ff ff       	call   80101a30 <writei>
80104e65:	83 c4 20             	add    $0x20,%esp
80104e68:	83 f8 10             	cmp    $0x10,%eax
80104e6b:	0f 85 e6 00 00 00    	jne    80104f57 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104e71:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e76:	0f 84 9c 00 00 00    	je     80104f18 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104e7c:	83 ec 0c             	sub    $0xc,%esp
80104e7f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104e82:	e8 59 ca ff ff       	call   801018e0 <iunlockput>

  ip->nlink--;
80104e87:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e8c:	89 1c 24             	mov    %ebx,(%esp)
80104e8f:	e8 0c c7 ff ff       	call   801015a0 <iupdate>
  iunlockput(ip);
80104e94:	89 1c 24             	mov    %ebx,(%esp)
80104e97:	e8 44 ca ff ff       	call   801018e0 <iunlockput>

  end_op();
80104e9c:	e8 ff dc ff ff       	call   80102ba0 <end_op>

  return 0;
80104ea1:	83 c4 10             	add    $0x10,%esp
80104ea4:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104ea6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ea9:	5b                   	pop    %ebx
80104eaa:	5e                   	pop    %esi
80104eab:	5f                   	pop    %edi
80104eac:	5d                   	pop    %ebp
80104ead:	c3                   	ret    
80104eae:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104eb0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104eb4:	76 94                	jbe    80104e4a <sys_unlink+0xba>
80104eb6:	bf 20 00 00 00       	mov    $0x20,%edi
80104ebb:	eb 0f                	jmp    80104ecc <sys_unlink+0x13c>
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi
80104ec0:	83 c7 10             	add    $0x10,%edi
80104ec3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104ec6:	0f 83 7e ff ff ff    	jae    80104e4a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ecc:	6a 10                	push   $0x10
80104ece:	57                   	push   %edi
80104ecf:	56                   	push   %esi
80104ed0:	53                   	push   %ebx
80104ed1:	e8 5a ca ff ff       	call   80101930 <readi>
80104ed6:	83 c4 10             	add    $0x10,%esp
80104ed9:	83 f8 10             	cmp    $0x10,%eax
80104edc:	75 6c                	jne    80104f4a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104ede:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104ee3:	74 db                	je     80104ec0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104ee5:	83 ec 0c             	sub    $0xc,%esp
80104ee8:	53                   	push   %ebx
80104ee9:	e8 f2 c9 ff ff       	call   801018e0 <iunlockput>
    goto bad;
80104eee:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104ef1:	83 ec 0c             	sub    $0xc,%esp
80104ef4:	ff 75 b4             	pushl  -0x4c(%ebp)
80104ef7:	e8 e4 c9 ff ff       	call   801018e0 <iunlockput>
  end_op();
80104efc:	e8 9f dc ff ff       	call   80102ba0 <end_op>
  return -1;
80104f01:	83 c4 10             	add    $0x10,%esp
}
80104f04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f0c:	5b                   	pop    %ebx
80104f0d:	5e                   	pop    %esi
80104f0e:	5f                   	pop    %edi
80104f0f:	5d                   	pop    %ebp
80104f10:	c3                   	ret    
80104f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104f18:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104f1b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104f1e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104f23:	50                   	push   %eax
80104f24:	e8 77 c6 ff ff       	call   801015a0 <iupdate>
80104f29:	83 c4 10             	add    $0x10,%esp
80104f2c:	e9 4b ff ff ff       	jmp    80104e7c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80104f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f36:	e9 6b ff ff ff       	jmp    80104ea6 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80104f3b:	e8 60 dc ff ff       	call   80102ba0 <end_op>
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f45:	e9 5c ff ff ff       	jmp    80104ea6 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104f4a:	83 ec 0c             	sub    $0xc,%esp
80104f4d:	68 00 78 10 80       	push   $0x80107800
80104f52:	e8 19 b4 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104f57:	83 ec 0c             	sub    $0xc,%esp
80104f5a:	68 12 78 10 80       	push   $0x80107812
80104f5f:	e8 0c b4 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104f64:	83 ec 0c             	sub    $0xc,%esp
80104f67:	68 ee 77 10 80       	push   $0x801077ee
80104f6c:	e8 ff b3 ff ff       	call   80100370 <panic>
80104f71:	eb 0d                	jmp    80104f80 <sys_open>
80104f73:	90                   	nop
80104f74:	90                   	nop
80104f75:	90                   	nop
80104f76:	90                   	nop
80104f77:	90                   	nop
80104f78:	90                   	nop
80104f79:	90                   	nop
80104f7a:	90                   	nop
80104f7b:	90                   	nop
80104f7c:	90                   	nop
80104f7d:	90                   	nop
80104f7e:	90                   	nop
80104f7f:	90                   	nop

80104f80 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	57                   	push   %edi
80104f84:	56                   	push   %esi
80104f85:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f86:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80104f89:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f8c:	50                   	push   %eax
80104f8d:	6a 00                	push   $0x0
80104f8f:	e8 dc f7 ff ff       	call   80104770 <argstr>
80104f94:	83 c4 10             	add    $0x10,%esp
80104f97:	85 c0                	test   %eax,%eax
80104f99:	0f 88 9e 00 00 00    	js     8010503d <sys_open+0xbd>
80104f9f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104fa2:	83 ec 08             	sub    $0x8,%esp
80104fa5:	50                   	push   %eax
80104fa6:	6a 01                	push   $0x1
80104fa8:	e8 33 f7 ff ff       	call   801046e0 <argint>
80104fad:	83 c4 10             	add    $0x10,%esp
80104fb0:	85 c0                	test   %eax,%eax
80104fb2:	0f 88 85 00 00 00    	js     8010503d <sys_open+0xbd>
    return -1;

  begin_op();
80104fb8:	e8 73 db ff ff       	call   80102b30 <begin_op>

  if(omode & O_CREATE){
80104fbd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104fc1:	0f 85 89 00 00 00    	jne    80105050 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104fc7:	83 ec 0c             	sub    $0xc,%esp
80104fca:	ff 75 e0             	pushl  -0x20(%ebp)
80104fcd:	e8 ce ce ff ff       	call   80101ea0 <namei>
80104fd2:	83 c4 10             	add    $0x10,%esp
80104fd5:	85 c0                	test   %eax,%eax
80104fd7:	89 c6                	mov    %eax,%esi
80104fd9:	0f 84 8e 00 00 00    	je     8010506d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
80104fdf:	83 ec 0c             	sub    $0xc,%esp
80104fe2:	50                   	push   %eax
80104fe3:	e8 68 c6 ff ff       	call   80101650 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104fe8:	83 c4 10             	add    $0x10,%esp
80104feb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104ff0:	0f 84 d2 00 00 00    	je     801050c8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104ff6:	e8 55 bd ff ff       	call   80100d50 <filealloc>
80104ffb:	85 c0                	test   %eax,%eax
80104ffd:	89 c7                	mov    %eax,%edi
80104fff:	74 2b                	je     8010502c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105001:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105003:	e8 58 e7 ff ff       	call   80103760 <myproc>
80105008:	90                   	nop
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105010:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105014:	85 d2                	test   %edx,%edx
80105016:	74 68                	je     80105080 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105018:	83 c3 01             	add    $0x1,%ebx
8010501b:	83 fb 10             	cmp    $0x10,%ebx
8010501e:	75 f0                	jne    80105010 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105020:	83 ec 0c             	sub    $0xc,%esp
80105023:	57                   	push   %edi
80105024:	e8 e7 bd ff ff       	call   80100e10 <fileclose>
80105029:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010502c:	83 ec 0c             	sub    $0xc,%esp
8010502f:	56                   	push   %esi
80105030:	e8 ab c8 ff ff       	call   801018e0 <iunlockput>
    end_op();
80105035:	e8 66 db ff ff       	call   80102ba0 <end_op>
    return -1;
8010503a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010503d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105045:	5b                   	pop    %ebx
80105046:	5e                   	pop    %esi
80105047:	5f                   	pop    %edi
80105048:	5d                   	pop    %ebp
80105049:	c3                   	ret    
8010504a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105050:	83 ec 0c             	sub    $0xc,%esp
80105053:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105056:	31 c9                	xor    %ecx,%ecx
80105058:	6a 00                	push   $0x0
8010505a:	ba 02 00 00 00       	mov    $0x2,%edx
8010505f:	e8 dc f7 ff ff       	call   80104840 <create>
    if(ip == 0){
80105064:	83 c4 10             	add    $0x10,%esp
80105067:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105069:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010506b:	75 89                	jne    80104ff6 <sys_open+0x76>
      end_op();
8010506d:	e8 2e db ff ff       	call   80102ba0 <end_op>
      return -1;
80105072:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105077:	eb 43                	jmp    801050bc <sys_open+0x13c>
80105079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105080:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105083:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105087:	56                   	push   %esi
80105088:	e8 a3 c6 ff ff       	call   80101730 <iunlock>
  end_op();
8010508d:	e8 0e db ff ff       	call   80102ba0 <end_op>

  f->type = FD_INODE;
80105092:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105098:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010509b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010509e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801050a1:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801050a8:	89 d0                	mov    %edx,%eax
801050aa:	83 e0 01             	and    $0x1,%eax
801050ad:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050b0:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801050b3:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801050b6:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
801050ba:	89 d8                	mov    %ebx,%eax
}
801050bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050bf:	5b                   	pop    %ebx
801050c0:	5e                   	pop    %esi
801050c1:	5f                   	pop    %edi
801050c2:	5d                   	pop    %ebp
801050c3:	c3                   	ret    
801050c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801050c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801050cb:	85 c9                	test   %ecx,%ecx
801050cd:	0f 84 23 ff ff ff    	je     80104ff6 <sys_open+0x76>
801050d3:	e9 54 ff ff ff       	jmp    8010502c <sys_open+0xac>
801050d8:	90                   	nop
801050d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801050e0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801050e6:	e8 45 da ff ff       	call   80102b30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801050eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050ee:	83 ec 08             	sub    $0x8,%esp
801050f1:	50                   	push   %eax
801050f2:	6a 00                	push   $0x0
801050f4:	e8 77 f6 ff ff       	call   80104770 <argstr>
801050f9:	83 c4 10             	add    $0x10,%esp
801050fc:	85 c0                	test   %eax,%eax
801050fe:	78 30                	js     80105130 <sys_mkdir+0x50>
80105100:	83 ec 0c             	sub    $0xc,%esp
80105103:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105106:	31 c9                	xor    %ecx,%ecx
80105108:	6a 00                	push   $0x0
8010510a:	ba 01 00 00 00       	mov    $0x1,%edx
8010510f:	e8 2c f7 ff ff       	call   80104840 <create>
80105114:	83 c4 10             	add    $0x10,%esp
80105117:	85 c0                	test   %eax,%eax
80105119:	74 15                	je     80105130 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010511b:	83 ec 0c             	sub    $0xc,%esp
8010511e:	50                   	push   %eax
8010511f:	e8 bc c7 ff ff       	call   801018e0 <iunlockput>
  end_op();
80105124:	e8 77 da ff ff       	call   80102ba0 <end_op>
  return 0;
80105129:	83 c4 10             	add    $0x10,%esp
8010512c:	31 c0                	xor    %eax,%eax
}
8010512e:	c9                   	leave  
8010512f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105130:	e8 6b da ff ff       	call   80102ba0 <end_op>
    return -1;
80105135:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010513a:	c9                   	leave  
8010513b:	c3                   	ret    
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105140 <sys_mknod>:

int
sys_mknod(void)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105146:	e8 e5 d9 ff ff       	call   80102b30 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010514b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010514e:	83 ec 08             	sub    $0x8,%esp
80105151:	50                   	push   %eax
80105152:	6a 00                	push   $0x0
80105154:	e8 17 f6 ff ff       	call   80104770 <argstr>
80105159:	83 c4 10             	add    $0x10,%esp
8010515c:	85 c0                	test   %eax,%eax
8010515e:	78 60                	js     801051c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105160:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105163:	83 ec 08             	sub    $0x8,%esp
80105166:	50                   	push   %eax
80105167:	6a 01                	push   $0x1
80105169:	e8 72 f5 ff ff       	call   801046e0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010516e:	83 c4 10             	add    $0x10,%esp
80105171:	85 c0                	test   %eax,%eax
80105173:	78 4b                	js     801051c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105175:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105178:	83 ec 08             	sub    $0x8,%esp
8010517b:	50                   	push   %eax
8010517c:	6a 02                	push   $0x2
8010517e:	e8 5d f5 ff ff       	call   801046e0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105183:	83 c4 10             	add    $0x10,%esp
80105186:	85 c0                	test   %eax,%eax
80105188:	78 36                	js     801051c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010518a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010518e:	83 ec 0c             	sub    $0xc,%esp
80105191:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105195:	ba 03 00 00 00       	mov    $0x3,%edx
8010519a:	50                   	push   %eax
8010519b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010519e:	e8 9d f6 ff ff       	call   80104840 <create>
801051a3:	83 c4 10             	add    $0x10,%esp
801051a6:	85 c0                	test   %eax,%eax
801051a8:	74 16                	je     801051c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801051aa:	83 ec 0c             	sub    $0xc,%esp
801051ad:	50                   	push   %eax
801051ae:	e8 2d c7 ff ff       	call   801018e0 <iunlockput>
  end_op();
801051b3:	e8 e8 d9 ff ff       	call   80102ba0 <end_op>
  return 0;
801051b8:	83 c4 10             	add    $0x10,%esp
801051bb:	31 c0                	xor    %eax,%eax
}
801051bd:	c9                   	leave  
801051be:	c3                   	ret    
801051bf:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801051c0:	e8 db d9 ff ff       	call   80102ba0 <end_op>
    return -1;
801051c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801051ca:	c9                   	leave  
801051cb:	c3                   	ret    
801051cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051d0 <sys_chdir>:

int
sys_chdir(void)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	56                   	push   %esi
801051d4:	53                   	push   %ebx
801051d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801051d8:	e8 83 e5 ff ff       	call   80103760 <myproc>
801051dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801051df:	e8 4c d9 ff ff       	call   80102b30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801051e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051e7:	83 ec 08             	sub    $0x8,%esp
801051ea:	50                   	push   %eax
801051eb:	6a 00                	push   $0x0
801051ed:	e8 7e f5 ff ff       	call   80104770 <argstr>
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	85 c0                	test   %eax,%eax
801051f7:	78 77                	js     80105270 <sys_chdir+0xa0>
801051f9:	83 ec 0c             	sub    $0xc,%esp
801051fc:	ff 75 f4             	pushl  -0xc(%ebp)
801051ff:	e8 9c cc ff ff       	call   80101ea0 <namei>
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	85 c0                	test   %eax,%eax
80105209:	89 c3                	mov    %eax,%ebx
8010520b:	74 63                	je     80105270 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010520d:	83 ec 0c             	sub    $0xc,%esp
80105210:	50                   	push   %eax
80105211:	e8 3a c4 ff ff       	call   80101650 <ilock>
  if(ip->type != T_DIR){
80105216:	83 c4 10             	add    $0x10,%esp
80105219:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010521e:	75 30                	jne    80105250 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	53                   	push   %ebx
80105224:	e8 07 c5 ff ff       	call   80101730 <iunlock>
  iput(curproc->cwd);
80105229:	58                   	pop    %eax
8010522a:	ff 76 6c             	pushl  0x6c(%esi)
8010522d:	e8 4e c5 ff ff       	call   80101780 <iput>
  end_op();
80105232:	e8 69 d9 ff ff       	call   80102ba0 <end_op>
  curproc->cwd = ip;
80105237:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
8010523a:	83 c4 10             	add    $0x10,%esp
8010523d:	31 c0                	xor    %eax,%eax
}
8010523f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105242:	5b                   	pop    %ebx
80105243:	5e                   	pop    %esi
80105244:	5d                   	pop    %ebp
80105245:	c3                   	ret    
80105246:	8d 76 00             	lea    0x0(%esi),%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	53                   	push   %ebx
80105254:	e8 87 c6 ff ff       	call   801018e0 <iunlockput>
    end_op();
80105259:	e8 42 d9 ff ff       	call   80102ba0 <end_op>
    return -1;
8010525e:	83 c4 10             	add    $0x10,%esp
80105261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105266:	eb d7                	jmp    8010523f <sys_chdir+0x6f>
80105268:	90                   	nop
80105269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105270:	e8 2b d9 ff ff       	call   80102ba0 <end_op>
    return -1;
80105275:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527a:	eb c3                	jmp    8010523f <sys_chdir+0x6f>
8010527c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105280 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
80105285:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105286:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010528c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105292:	50                   	push   %eax
80105293:	6a 00                	push   $0x0
80105295:	e8 d6 f4 ff ff       	call   80104770 <argstr>
8010529a:	83 c4 10             	add    $0x10,%esp
8010529d:	85 c0                	test   %eax,%eax
8010529f:	78 7f                	js     80105320 <sys_exec+0xa0>
801052a1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801052a7:	83 ec 08             	sub    $0x8,%esp
801052aa:	50                   	push   %eax
801052ab:	6a 01                	push   $0x1
801052ad:	e8 2e f4 ff ff       	call   801046e0 <argint>
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	85 c0                	test   %eax,%eax
801052b7:	78 67                	js     80105320 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801052b9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801052bf:	83 ec 04             	sub    $0x4,%esp
801052c2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801052c8:	68 80 00 00 00       	push   $0x80
801052cd:	6a 00                	push   $0x0
801052cf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801052d5:	50                   	push   %eax
801052d6:	31 db                	xor    %ebx,%ebx
801052d8:	e8 13 f1 ff ff       	call   801043f0 <memset>
801052dd:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801052e0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801052e6:	83 ec 08             	sub    $0x8,%esp
801052e9:	57                   	push   %edi
801052ea:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801052ed:	50                   	push   %eax
801052ee:	e8 6d f3 ff ff       	call   80104660 <fetchint>
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	85 c0                	test   %eax,%eax
801052f8:	78 26                	js     80105320 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
801052fa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105300:	85 c0                	test   %eax,%eax
80105302:	74 2c                	je     80105330 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105304:	83 ec 08             	sub    $0x8,%esp
80105307:	56                   	push   %esi
80105308:	50                   	push   %eax
80105309:	e8 82 f3 ff ff       	call   80104690 <fetchstr>
8010530e:	83 c4 10             	add    $0x10,%esp
80105311:	85 c0                	test   %eax,%eax
80105313:	78 0b                	js     80105320 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105315:	83 c3 01             	add    $0x1,%ebx
80105318:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010531b:	83 fb 20             	cmp    $0x20,%ebx
8010531e:	75 c0                	jne    801052e0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105323:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105328:	5b                   	pop    %ebx
80105329:	5e                   	pop    %esi
8010532a:	5f                   	pop    %edi
8010532b:	5d                   	pop    %ebp
8010532c:	c3                   	ret    
8010532d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105330:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105336:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105339:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105340:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105344:	50                   	push   %eax
80105345:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010534b:	e8 a0 b6 ff ff       	call   801009f0 <exec>
80105350:	83 c4 10             	add    $0x10,%esp
}
80105353:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105356:	5b                   	pop    %ebx
80105357:	5e                   	pop    %esi
80105358:	5f                   	pop    %edi
80105359:	5d                   	pop    %ebp
8010535a:	c3                   	ret    
8010535b:	90                   	nop
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_pipe>:

int
sys_pipe(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
80105365:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105366:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105369:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010536c:	6a 08                	push   $0x8
8010536e:	50                   	push   %eax
8010536f:	6a 00                	push   $0x0
80105371:	e8 aa f3 ff ff       	call   80104720 <argptr>
80105376:	83 c4 10             	add    $0x10,%esp
80105379:	85 c0                	test   %eax,%eax
8010537b:	78 4a                	js     801053c7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010537d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105380:	83 ec 08             	sub    $0x8,%esp
80105383:	50                   	push   %eax
80105384:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105387:	50                   	push   %eax
80105388:	e8 43 de ff ff       	call   801031d0 <pipealloc>
8010538d:	83 c4 10             	add    $0x10,%esp
80105390:	85 c0                	test   %eax,%eax
80105392:	78 33                	js     801053c7 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105394:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105396:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105399:	e8 c2 e3 ff ff       	call   80103760 <myproc>
8010539e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801053a0:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
801053a4:	85 f6                	test   %esi,%esi
801053a6:	74 30                	je     801053d8 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801053a8:	83 c3 01             	add    $0x1,%ebx
801053ab:	83 fb 10             	cmp    $0x10,%ebx
801053ae:	75 f0                	jne    801053a0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	ff 75 e0             	pushl  -0x20(%ebp)
801053b6:	e8 55 ba ff ff       	call   80100e10 <fileclose>
    fileclose(wf);
801053bb:	58                   	pop    %eax
801053bc:	ff 75 e4             	pushl  -0x1c(%ebp)
801053bf:	e8 4c ba ff ff       	call   80100e10 <fileclose>
    return -1;
801053c4:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801053c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
801053ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
801053cf:	5b                   	pop    %ebx
801053d0:	5e                   	pop    %esi
801053d1:	5f                   	pop    %edi
801053d2:	5d                   	pop    %ebp
801053d3:	c3                   	ret    
801053d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801053d8:	8d 73 08             	lea    0x8(%ebx),%esi
801053db:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801053df:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801053e2:	e8 79 e3 ff ff       	call   80103760 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801053e7:	31 d2                	xor    %edx,%edx
801053e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801053f0:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
801053f4:	85 c9                	test   %ecx,%ecx
801053f6:	74 18                	je     80105410 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801053f8:	83 c2 01             	add    $0x1,%edx
801053fb:	83 fa 10             	cmp    $0x10,%edx
801053fe:	75 f0                	jne    801053f0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105400:	e8 5b e3 ff ff       	call   80103760 <myproc>
80105405:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
8010540c:	00 
8010540d:	eb a1                	jmp    801053b0 <sys_pipe+0x50>
8010540f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105410:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105414:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105417:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105419:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010541c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010541f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105422:	31 c0                	xor    %eax,%eax
}
80105424:	5b                   	pop    %ebx
80105425:	5e                   	pop    %esi
80105426:	5f                   	pop    %edi
80105427:	5d                   	pop    %ebp
80105428:	c3                   	ret    
80105429:	66 90                	xchg   %ax,%ax
8010542b:	66 90                	xchg   %ax,%ax
8010542d:	66 90                	xchg   %ax,%ax
8010542f:	90                   	nop

80105430 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	83 ec 20             	sub    $0x20,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
80105436:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105439:	50                   	push   %eax
8010543a:	6a 00                	push   $0x0
8010543c:	e8 9f f2 ff ff       	call   801046e0 <argint>
80105441:	83 c4 10             	add    $0x10,%esp
80105444:	85 c0                	test   %eax,%eax
80105446:	78 30                	js     80105478 <sys_shm_open+0x48>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
80105448:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544b:	83 ec 04             	sub    $0x4,%esp
8010544e:	6a 04                	push   $0x4
80105450:	50                   	push   %eax
80105451:	6a 01                	push   $0x1
80105453:	e8 c8 f2 ff ff       	call   80104720 <argptr>
80105458:	83 c4 10             	add    $0x10,%esp
8010545b:	85 c0                	test   %eax,%eax
8010545d:	78 19                	js     80105478 <sys_shm_open+0x48>
    return -1;
  return shm_open(id, pointer);
8010545f:	83 ec 08             	sub    $0x8,%esp
80105462:	ff 75 f4             	pushl  -0xc(%ebp)
80105465:	ff 75 f0             	pushl  -0x10(%ebp)
80105468:	e8 f3 1b 00 00       	call   80107060 <shm_open>
8010546d:	83 c4 10             	add    $0x10,%esp
}
80105470:	c9                   	leave  
80105471:	c3                   	ret    
80105472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int sys_shm_open(void) {
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
    return -1;
80105478:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  if(argptr(1, (char **) (&pointer),4)<0)
    return -1;
  return shm_open(id, pointer);
}
8010547d:	c9                   	leave  
8010547e:	c3                   	ret    
8010547f:	90                   	nop

80105480 <sys_shm_close>:

int sys_shm_close(void) {
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	83 ec 20             	sub    $0x20,%esp
  int id;

  if(argint(0, &id) < 0)
80105486:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105489:	50                   	push   %eax
8010548a:	6a 00                	push   $0x0
8010548c:	e8 4f f2 ff ff       	call   801046e0 <argint>
80105491:	83 c4 10             	add    $0x10,%esp
80105494:	85 c0                	test   %eax,%eax
80105496:	78 18                	js     801054b0 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
80105498:	83 ec 0c             	sub    $0xc,%esp
8010549b:	ff 75 f4             	pushl  -0xc(%ebp)
8010549e:	e8 cd 1b 00 00       	call   80107070 <shm_close>
801054a3:	83 c4 10             	add    $0x10,%esp
}
801054a6:	c9                   	leave  
801054a7:	c3                   	ret    
801054a8:	90                   	nop
801054a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int sys_shm_close(void) {
  int id;

  if(argint(0, &id) < 0)
    return -1;
801054b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  
  return shm_close(id);
}
801054b5:	c9                   	leave  
801054b6:	c3                   	ret    
801054b7:	89 f6                	mov    %esi,%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054c0 <sys_fork>:

int
sys_fork(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801054c3:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
801054c4:	e9 37 e4 ff ff       	jmp    80103900 <fork>
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054d0 <sys_exit>:
}

int
sys_exit(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801054d6:	e8 b5 e6 ff ff       	call   80103b90 <exit>
  return 0;  // not reached
}
801054db:	31 c0                	xor    %eax,%eax
801054dd:	c9                   	leave  
801054de:	c3                   	ret    
801054df:	90                   	nop

801054e0 <sys_wait>:

int
sys_wait(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801054e3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801054e4:	e9 e7 e8 ff ff       	jmp    80103dd0 <wait>
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054f0 <sys_kill>:
}

int
sys_kill(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801054f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f9:	50                   	push   %eax
801054fa:	6a 00                	push   $0x0
801054fc:	e8 df f1 ff ff       	call   801046e0 <argint>
80105501:	83 c4 10             	add    $0x10,%esp
80105504:	85 c0                	test   %eax,%eax
80105506:	78 18                	js     80105520 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105508:	83 ec 0c             	sub    $0xc,%esp
8010550b:	ff 75 f4             	pushl  -0xc(%ebp)
8010550e:	e8 0d ea ff ff       	call   80103f20 <kill>
80105513:	83 c4 10             	add    $0x10,%esp
}
80105516:	c9                   	leave  
80105517:	c3                   	ret    
80105518:	90                   	nop
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105525:	c9                   	leave  
80105526:	c3                   	ret    
80105527:	89 f6                	mov    %esi,%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <sys_getpid>:

int
sys_getpid(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105536:	e8 25 e2 ff ff       	call   80103760 <myproc>
8010553b:	8b 40 14             	mov    0x14(%eax),%eax
}
8010553e:	c9                   	leave  
8010553f:	c3                   	ret    

80105540 <sys_sbrk>:

int
sys_sbrk(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105544:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105547:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010554a:	50                   	push   %eax
8010554b:	6a 00                	push   $0x0
8010554d:	e8 8e f1 ff ff       	call   801046e0 <argint>
80105552:	83 c4 10             	add    $0x10,%esp
80105555:	85 c0                	test   %eax,%eax
80105557:	78 27                	js     80105580 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105559:	e8 02 e2 ff ff       	call   80103760 <myproc>
  if(growproc(n) < 0)
8010555e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105561:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105563:	ff 75 f4             	pushl  -0xc(%ebp)
80105566:	e8 15 e3 ff ff       	call   80103880 <growproc>
8010556b:	83 c4 10             	add    $0x10,%esp
8010556e:	85 c0                	test   %eax,%eax
80105570:	78 0e                	js     80105580 <sys_sbrk+0x40>
    return -1;
  return addr;
80105572:	89 d8                	mov    %ebx,%eax
}
80105574:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105577:	c9                   	leave  
80105578:	c3                   	ret    
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105585:	eb ed                	jmp    80105574 <sys_sbrk+0x34>
80105587:	89 f6                	mov    %esi,%esi
80105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105590 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105594:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105597:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010559a:	50                   	push   %eax
8010559b:	6a 00                	push   $0x0
8010559d:	e8 3e f1 ff ff       	call   801046e0 <argint>
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	85 c0                	test   %eax,%eax
801055a7:	0f 88 8a 00 00 00    	js     80105637 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801055ad:	83 ec 0c             	sub    $0xc,%esp
801055b0:	68 60 4d 11 80       	push   $0x80114d60
801055b5:	e8 c6 ec ff ff       	call   80104280 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801055ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055bd:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801055c0:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
801055c6:	85 d2                	test   %edx,%edx
801055c8:	75 27                	jne    801055f1 <sys_sleep+0x61>
801055ca:	eb 54                	jmp    80105620 <sys_sleep+0x90>
801055cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801055d0:	83 ec 08             	sub    $0x8,%esp
801055d3:	68 60 4d 11 80       	push   $0x80114d60
801055d8:	68 a0 55 11 80       	push   $0x801155a0
801055dd:	e8 2e e7 ff ff       	call   80103d10 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801055e2:	a1 a0 55 11 80       	mov    0x801155a0,%eax
801055e7:	83 c4 10             	add    $0x10,%esp
801055ea:	29 d8                	sub    %ebx,%eax
801055ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801055ef:	73 2f                	jae    80105620 <sys_sleep+0x90>
    if(myproc()->killed){
801055f1:	e8 6a e1 ff ff       	call   80103760 <myproc>
801055f6:	8b 40 28             	mov    0x28(%eax),%eax
801055f9:	85 c0                	test   %eax,%eax
801055fb:	74 d3                	je     801055d0 <sys_sleep+0x40>
      release(&tickslock);
801055fd:	83 ec 0c             	sub    $0xc,%esp
80105600:	68 60 4d 11 80       	push   $0x80114d60
80105605:	e8 96 ed ff ff       	call   801043a0 <release>
      return -1;
8010560a:	83 c4 10             	add    $0x10,%esp
8010560d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105612:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105615:	c9                   	leave  
80105616:	c3                   	ret    
80105617:	89 f6                	mov    %esi,%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105620:	83 ec 0c             	sub    $0xc,%esp
80105623:	68 60 4d 11 80       	push   $0x80114d60
80105628:	e8 73 ed ff ff       	call   801043a0 <release>
  return 0;
8010562d:	83 c4 10             	add    $0x10,%esp
80105630:	31 c0                	xor    %eax,%eax
}
80105632:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105635:	c9                   	leave  
80105636:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105637:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010563c:	eb d4                	jmp    80105612 <sys_sleep+0x82>
8010563e:	66 90                	xchg   %ax,%ax

80105640 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	53                   	push   %ebx
80105644:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105647:	68 60 4d 11 80       	push   $0x80114d60
8010564c:	e8 2f ec ff ff       	call   80104280 <acquire>
  xticks = ticks;
80105651:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
80105657:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
8010565e:	e8 3d ed ff ff       	call   801043a0 <release>
  return xticks;
}
80105663:	89 d8                	mov    %ebx,%eax
80105665:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105668:	c9                   	leave  
80105669:	c3                   	ret    

8010566a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010566a:	1e                   	push   %ds
  pushl %es
8010566b:	06                   	push   %es
  pushl %fs
8010566c:	0f a0                	push   %fs
  pushl %gs
8010566e:	0f a8                	push   %gs
  pushal
80105670:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105671:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105675:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105677:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105679:	54                   	push   %esp
  call trap
8010567a:	e8 e1 00 00 00       	call   80105760 <trap>
  addl $4, %esp
8010567f:	83 c4 04             	add    $0x4,%esp

80105682 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105682:	61                   	popa   
  popl %gs
80105683:	0f a9                	pop    %gs
  popl %fs
80105685:	0f a1                	pop    %fs
  popl %es
80105687:	07                   	pop    %es
  popl %ds
80105688:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105689:	83 c4 08             	add    $0x8,%esp
  iret
8010568c:	cf                   	iret   
8010568d:	66 90                	xchg   %ax,%ax
8010568f:	90                   	nop

80105690 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105690:	31 c0                	xor    %eax,%eax
80105692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105698:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010569f:	b9 08 00 00 00       	mov    $0x8,%ecx
801056a4:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
801056ab:	00 
801056ac:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
801056b3:	80 
801056b4:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
801056bb:	8e 
801056bc:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
801056c3:	80 
801056c4:	c1 ea 10             	shr    $0x10,%edx
801056c7:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
801056ce:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801056cf:	83 c0 01             	add    $0x1,%eax
801056d2:	3d 00 01 00 00       	cmp    $0x100,%eax
801056d7:	75 bf                	jne    80105698 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801056d9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056da:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801056df:	89 e5                	mov    %esp,%ebp
801056e1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056e4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801056e9:	68 21 78 10 80       	push   $0x80107821
801056ee:	68 60 4d 11 80       	push   $0x80114d60
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801056f3:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
801056fa:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
80105701:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105707:	c1 e8 10             	shr    $0x10,%eax
8010570a:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
80105711:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6

  initlock(&tickslock, "time");
80105717:	e8 64 ea ff ff       	call   80104180 <initlock>
}
8010571c:	83 c4 10             	add    $0x10,%esp
8010571f:	c9                   	leave  
80105720:	c3                   	ret    
80105721:	eb 0d                	jmp    80105730 <idtinit>
80105723:	90                   	nop
80105724:	90                   	nop
80105725:	90                   	nop
80105726:	90                   	nop
80105727:	90                   	nop
80105728:	90                   	nop
80105729:	90                   	nop
8010572a:	90                   	nop
8010572b:	90                   	nop
8010572c:	90                   	nop
8010572d:	90                   	nop
8010572e:	90                   	nop
8010572f:	90                   	nop

80105730 <idtinit>:

void
idtinit(void)
{
80105730:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105731:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105736:	89 e5                	mov    %esp,%ebp
80105738:	83 ec 10             	sub    $0x10,%esp
8010573b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010573f:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105744:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105748:	c1 e8 10             	shr    $0x10,%eax
8010574b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010574f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105752:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105755:	c9                   	leave  
80105756:	c3                   	ret    
80105757:	89 f6                	mov    %esi,%esi
80105759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105760 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	57                   	push   %edi
80105764:	56                   	push   %esi
80105765:	53                   	push   %ebx
80105766:	83 ec 1c             	sub    $0x1c,%esp
80105769:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010576c:	8b 47 30             	mov    0x30(%edi),%eax
8010576f:	83 f8 40             	cmp    $0x40,%eax
80105772:	0f 84 a8 01 00 00    	je     80105920 <trap+0x1c0>
    return;
  }

  uint lowAddress, highAddress, faultyAddress;

  switch(tf->trapno){
80105778:	83 e8 0e             	sub    $0xe,%eax
8010577b:	83 f8 31             	cmp    $0x31,%eax
8010577e:	77 38                	ja     801057b8 <trap+0x58>
80105780:	ff 24 85 c8 78 10 80 	jmp    *-0x7fef8738(,%eax,4)
80105787:	89 f6                	mov    %esi,%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_PGFLT: //cs153_lab3: page fault handler
    highAddress = KERNBASE - (myproc()->userStack_numPages * PGSIZE); //cs153_lab3: the current top of the stack
80105790:	e8 cb df ff ff       	call   80103760 <myproc>
80105795:	8b 40 04             	mov    0x4(%eax),%eax
80105798:	f7 d8                	neg    %eax
8010579a:	c1 e0 0c             	shl    $0xc,%eax
8010579d:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    lowAddress = highAddress - PGSIZE; //cs153_lab3: the page right under the current top of the stack
801057a3:	8d 98 00 f0 ff 7f    	lea    0x7ffff000(%eax),%ebx

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801057a9:	0f 20 d0             	mov    %cr2,%eax
    faultyAddress = rcr2();

    if (faultyAddress > lowAddress && faultyAddress < highAddress) //cs153_lab3: check if the page fault was caused by an access to the page right under the current top of the stack
801057ac:	39 c3                	cmp    %eax,%ebx
801057ae:	73 08                	jae    801057b8 <trap+0x58>
801057b0:	39 c6                	cmp    %eax,%esi
801057b2:	0f 87 a0 01 00 00    	ja     80105958 <trap+0x1f8>
    break;

  Default:
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801057b8:	e8 a3 df ff ff       	call   80103760 <myproc>
801057bd:	85 c0                	test   %eax,%eax
801057bf:	0f 84 ff 01 00 00    	je     801059c4 <trap+0x264>
801057c5:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801057c9:	0f 84 f5 01 00 00    	je     801059c4 <trap+0x264>
801057cf:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057d2:	8b 57 38             	mov    0x38(%edi),%edx
801057d5:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801057d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
801057db:	e8 60 df ff ff       	call   80103740 <cpuid>
801057e0:	8b 77 34             	mov    0x34(%edi),%esi
801057e3:	8b 5f 30             	mov    0x30(%edi),%ebx
801057e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801057e9:	e8 72 df ff ff       	call   80103760 <myproc>
801057ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801057f1:	e8 6a df ff ff       	call   80103760 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801057f6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801057f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801057fc:	51                   	push   %ecx
801057fd:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801057fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105801:	ff 75 e4             	pushl  -0x1c(%ebp)
80105804:	56                   	push   %esi
80105805:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105806:	83 c2 70             	add    $0x70,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105809:	52                   	push   %edx
8010580a:	ff 70 14             	pushl  0x14(%eax)
8010580d:	68 84 78 10 80       	push   $0x80107884
80105812:	e8 49 ae ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105817:	83 c4 20             	add    $0x20,%esp
8010581a:	e8 41 df ff ff       	call   80103760 <myproc>
8010581f:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105826:	e8 35 df ff ff       	call   80103760 <myproc>
8010582b:	85 c0                	test   %eax,%eax
8010582d:	74 0c                	je     8010583b <trap+0xdb>
8010582f:	e8 2c df ff ff       	call   80103760 <myproc>
80105834:	8b 50 28             	mov    0x28(%eax),%edx
80105837:	85 d2                	test   %edx,%edx
80105839:	75 45                	jne    80105880 <trap+0x120>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010583b:	e8 20 df ff ff       	call   80103760 <myproc>
80105840:	85 c0                	test   %eax,%eax
80105842:	74 0b                	je     8010584f <trap+0xef>
80105844:	e8 17 df ff ff       	call   80103760 <myproc>
80105849:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
8010584d:	74 49                	je     80105898 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010584f:	e8 0c df ff ff       	call   80103760 <myproc>
80105854:	85 c0                	test   %eax,%eax
80105856:	74 1d                	je     80105875 <trap+0x115>
80105858:	e8 03 df ff ff       	call   80103760 <myproc>
8010585d:	8b 40 28             	mov    0x28(%eax),%eax
80105860:	85 c0                	test   %eax,%eax
80105862:	74 11                	je     80105875 <trap+0x115>
80105864:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105868:	83 e0 03             	and    $0x3,%eax
8010586b:	66 83 f8 03          	cmp    $0x3,%ax
8010586f:	0f 84 d4 00 00 00    	je     80105949 <trap+0x1e9>
    exit();
}
80105875:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105878:	5b                   	pop    %ebx
80105879:	5e                   	pop    %esi
8010587a:	5f                   	pop    %edi
8010587b:	5d                   	pop    %ebp
8010587c:	c3                   	ret    
8010587d:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105880:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105884:	83 e0 03             	and    $0x3,%eax
80105887:	66 83 f8 03          	cmp    $0x3,%ax
8010588b:	75 ae                	jne    8010583b <trap+0xdb>
    exit();
8010588d:	e8 fe e2 ff ff       	call   80103b90 <exit>
80105892:	eb a7                	jmp    8010583b <trap+0xdb>
80105894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105898:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010589c:	75 b1                	jne    8010584f <trap+0xef>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
8010589e:	e8 1d e4 ff ff       	call   80103cc0 <yield>
801058a3:	eb aa                	jmp    8010584f <trap+0xef>
801058a5:	8d 76 00             	lea    0x0(%esi),%esi
      goto Default; //cs153_lab3: go to the default handler and do a kernel panic like we did before

    break;

  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801058a8:	e8 93 de ff ff       	call   80103740 <cpuid>
801058ad:	85 c0                	test   %eax,%eax
801058af:	0f 84 db 00 00 00    	je     80105990 <trap+0x230>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801058b5:	e8 36 ce ff ff       	call   801026f0 <lapiceoi>
    break;
801058ba:	e9 67 ff ff ff       	jmp    80105826 <trap+0xc6>
801058bf:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801058c0:	e8 eb cc ff ff       	call   801025b0 <kbdintr>
    lapiceoi();
801058c5:	e8 26 ce ff ff       	call   801026f0 <lapiceoi>
    break;
801058ca:	e9 57 ff ff ff       	jmp    80105826 <trap+0xc6>
801058cf:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801058d0:	e8 8b 02 00 00       	call   80105b60 <uartintr>
    lapiceoi();
801058d5:	e8 16 ce ff ff       	call   801026f0 <lapiceoi>
    break;
801058da:	e9 47 ff ff ff       	jmp    80105826 <trap+0xc6>
801058df:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801058e0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801058e4:	8b 77 38             	mov    0x38(%edi),%esi
801058e7:	e8 54 de ff ff       	call   80103740 <cpuid>
801058ec:	56                   	push   %esi
801058ed:	53                   	push   %ebx
801058ee:	50                   	push   %eax
801058ef:	68 2c 78 10 80       	push   $0x8010782c
801058f4:	e8 67 ad ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
801058f9:	e8 f2 cd ff ff       	call   801026f0 <lapiceoi>
    break;
801058fe:	83 c4 10             	add    $0x10,%esp
80105901:	e9 20 ff ff ff       	jmp    80105826 <trap+0xc6>
80105906:	8d 76 00             	lea    0x0(%esi),%esi
80105909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105910:	e8 1b c7 ff ff       	call   80102030 <ideintr>
80105915:	eb 9e                	jmp    801058b5 <trap+0x155>
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105920:	e8 3b de ff ff       	call   80103760 <myproc>
80105925:	8b 58 28             	mov    0x28(%eax),%ebx
80105928:	85 db                	test   %ebx,%ebx
8010592a:	75 54                	jne    80105980 <trap+0x220>
      exit();
    myproc()->tf = tf;
8010592c:	e8 2f de ff ff       	call   80103760 <myproc>
80105931:	89 78 1c             	mov    %edi,0x1c(%eax)
    syscall();
80105934:	e8 a7 ee ff ff       	call   801047e0 <syscall>
    if(myproc()->killed)
80105939:	e8 22 de ff ff       	call   80103760 <myproc>
8010593e:	8b 48 28             	mov    0x28(%eax),%ecx
80105941:	85 c9                	test   %ecx,%ecx
80105943:	0f 84 2c ff ff ff    	je     80105875 <trap+0x115>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105949:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010594c:	5b                   	pop    %ebx
8010594d:	5e                   	pop    %esi
8010594e:	5f                   	pop    %edi
8010594f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105950:	e9 3b e2 ff ff       	jmp    80103b90 <exit>
80105955:	8d 76 00             	lea    0x0(%esi),%esi
    lowAddress = highAddress - PGSIZE; //cs153_lab3: the page right under the current top of the stack
    faultyAddress = rcr2();

    if (faultyAddress > lowAddress && faultyAddress < highAddress) //cs153_lab3: check if the page fault was caused by an access to the page right under the current top of the stack
    {
      allocuvm(myproc()->pgdir, lowAddress, highAddress); //cs153_lab3: allocate and map the page
80105958:	e8 03 de ff ff       	call   80103760 <myproc>
8010595d:	83 ec 04             	sub    $0x4,%esp
80105960:	56                   	push   %esi
80105961:	53                   	push   %ebx
80105962:	ff 70 08             	pushl  0x8(%eax)
80105965:	e8 a6 11 00 00       	call   80106b10 <allocuvm>
      myproc()->userStack_numPages++; //cs153_lab3: add a single page to the user stack
8010596a:	e8 f1 dd ff ff       	call   80103760 <myproc>
    }
    else
      goto Default; //cs153_lab3: go to the default handler and do a kernel panic like we did before

    break;
8010596f:	83 c4 10             	add    $0x10,%esp
    faultyAddress = rcr2();

    if (faultyAddress > lowAddress && faultyAddress < highAddress) //cs153_lab3: check if the page fault was caused by an access to the page right under the current top of the stack
    {
      allocuvm(myproc()->pgdir, lowAddress, highAddress); //cs153_lab3: allocate and map the page
      myproc()->userStack_numPages++; //cs153_lab3: add a single page to the user stack
80105972:	83 40 04 01          	addl   $0x1,0x4(%eax)
    }
    else
      goto Default; //cs153_lab3: go to the default handler and do a kernel panic like we did before

    break;
80105976:	e9 ab fe ff ff       	jmp    80105826 <trap+0xc6>
8010597b:	90                   	nop
8010597c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105980:	e8 0b e2 ff ff       	call   80103b90 <exit>
80105985:	eb a5                	jmp    8010592c <trap+0x1cc>
80105987:	89 f6                	mov    %esi,%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

    break;

  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	68 60 4d 11 80       	push   $0x80114d60
80105998:	e8 e3 e8 ff ff       	call   80104280 <acquire>
      ticks++;
      wakeup(&ticks);
8010599d:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
    break;

  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801059a4:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
801059ab:	e8 10 e5 ff ff       	call   80103ec0 <wakeup>
      release(&tickslock);
801059b0:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801059b7:	e8 e4 e9 ff ff       	call   801043a0 <release>
801059bc:	83 c4 10             	add    $0x10,%esp
801059bf:	e9 f1 fe ff ff       	jmp    801058b5 <trap+0x155>
801059c4:	0f 20 d6             	mov    %cr2,%esi
  Default:
  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801059c7:	8b 5f 38             	mov    0x38(%edi),%ebx
801059ca:	e8 71 dd ff ff       	call   80103740 <cpuid>
801059cf:	83 ec 0c             	sub    $0xc,%esp
801059d2:	56                   	push   %esi
801059d3:	53                   	push   %ebx
801059d4:	50                   	push   %eax
801059d5:	ff 77 30             	pushl  0x30(%edi)
801059d8:	68 50 78 10 80       	push   $0x80107850
801059dd:	e8 7e ac ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801059e2:	83 c4 14             	add    $0x14,%esp
801059e5:	68 26 78 10 80       	push   $0x80107826
801059ea:	e8 81 a9 ff ff       	call   80100370 <panic>
801059ef:	90                   	nop

801059f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801059f0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801059f5:	55                   	push   %ebp
801059f6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801059f8:	85 c0                	test   %eax,%eax
801059fa:	74 1c                	je     80105a18 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059fc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a01:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a02:	a8 01                	test   $0x1,%al
80105a04:	74 12                	je     80105a18 <uartgetc+0x28>
80105a06:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a0b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a0c:	0f b6 c0             	movzbl %al,%eax
}
80105a0f:	5d                   	pop    %ebp
80105a10:	c3                   	ret    
80105a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105a1d:	5d                   	pop    %ebp
80105a1e:	c3                   	ret    
80105a1f:	90                   	nop

80105a20 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	57                   	push   %edi
80105a24:	56                   	push   %esi
80105a25:	53                   	push   %ebx
80105a26:	89 c7                	mov    %eax,%edi
80105a28:	bb 80 00 00 00       	mov    $0x80,%ebx
80105a2d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a32:	83 ec 0c             	sub    $0xc,%esp
80105a35:	eb 1b                	jmp    80105a52 <uartputc.part.0+0x32>
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	6a 0a                	push   $0xa
80105a45:	e8 c6 cc ff ff       	call   80102710 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105a4a:	83 c4 10             	add    $0x10,%esp
80105a4d:	83 eb 01             	sub    $0x1,%ebx
80105a50:	74 07                	je     80105a59 <uartputc.part.0+0x39>
80105a52:	89 f2                	mov    %esi,%edx
80105a54:	ec                   	in     (%dx),%al
80105a55:	a8 20                	test   $0x20,%al
80105a57:	74 e7                	je     80105a40 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a59:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a5e:	89 f8                	mov    %edi,%eax
80105a60:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a64:	5b                   	pop    %ebx
80105a65:	5e                   	pop    %esi
80105a66:	5f                   	pop    %edi
80105a67:	5d                   	pop    %ebp
80105a68:	c3                   	ret    
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a70 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105a70:	55                   	push   %ebp
80105a71:	31 c9                	xor    %ecx,%ecx
80105a73:	89 c8                	mov    %ecx,%eax
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	57                   	push   %edi
80105a78:	56                   	push   %esi
80105a79:	53                   	push   %ebx
80105a7a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105a7f:	89 da                	mov    %ebx,%edx
80105a81:	83 ec 0c             	sub    $0xc,%esp
80105a84:	ee                   	out    %al,(%dx)
80105a85:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105a8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105a8f:	89 fa                	mov    %edi,%edx
80105a91:	ee                   	out    %al,(%dx)
80105a92:	b8 0c 00 00 00       	mov    $0xc,%eax
80105a97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a9c:	ee                   	out    %al,(%dx)
80105a9d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105aa2:	89 c8                	mov    %ecx,%eax
80105aa4:	89 f2                	mov    %esi,%edx
80105aa6:	ee                   	out    %al,(%dx)
80105aa7:	b8 03 00 00 00       	mov    $0x3,%eax
80105aac:	89 fa                	mov    %edi,%edx
80105aae:	ee                   	out    %al,(%dx)
80105aaf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ab4:	89 c8                	mov    %ecx,%eax
80105ab6:	ee                   	out    %al,(%dx)
80105ab7:	b8 01 00 00 00       	mov    $0x1,%eax
80105abc:	89 f2                	mov    %esi,%edx
80105abe:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105abf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ac4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105ac5:	3c ff                	cmp    $0xff,%al
80105ac7:	74 5a                	je     80105b23 <uartinit+0xb3>
    return;
  uart = 1;
80105ac9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ad0:	00 00 00 
80105ad3:	89 da                	mov    %ebx,%edx
80105ad5:	ec                   	in     (%dx),%al
80105ad6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105adb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105adc:	83 ec 08             	sub    $0x8,%esp
80105adf:	bb 90 79 10 80       	mov    $0x80107990,%ebx
80105ae4:	6a 00                	push   $0x0
80105ae6:	6a 04                	push   $0x4
80105ae8:	e8 93 c7 ff ff       	call   80102280 <ioapicenable>
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	b8 78 00 00 00       	mov    $0x78,%eax
80105af5:	eb 13                	jmp    80105b0a <uartinit+0x9a>
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b00:	83 c3 01             	add    $0x1,%ebx
80105b03:	0f be 03             	movsbl (%ebx),%eax
80105b06:	84 c0                	test   %al,%al
80105b08:	74 19                	je     80105b23 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b0a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105b10:	85 d2                	test   %edx,%edx
80105b12:	74 ec                	je     80105b00 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b14:	83 c3 01             	add    $0x1,%ebx
80105b17:	e8 04 ff ff ff       	call   80105a20 <uartputc.part.0>
80105b1c:	0f be 03             	movsbl (%ebx),%eax
80105b1f:	84 c0                	test   %al,%al
80105b21:	75 e7                	jne    80105b0a <uartinit+0x9a>
    uartputc(*p);
}
80105b23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b26:	5b                   	pop    %ebx
80105b27:	5e                   	pop    %esi
80105b28:	5f                   	pop    %edi
80105b29:	5d                   	pop    %ebp
80105b2a:	c3                   	ret    
80105b2b:	90                   	nop
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b30 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b30:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b36:	55                   	push   %ebp
80105b37:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105b39:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105b3e:	74 10                	je     80105b50 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105b40:	5d                   	pop    %ebp
80105b41:	e9 da fe ff ff       	jmp    80105a20 <uartputc.part.0>
80105b46:	8d 76 00             	lea    0x0(%esi),%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105b50:	5d                   	pop    %ebp
80105b51:	c3                   	ret    
80105b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b60 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105b66:	68 f0 59 10 80       	push   $0x801059f0
80105b6b:	e8 80 ac ff ff       	call   801007f0 <consoleintr>
}
80105b70:	83 c4 10             	add    $0x10,%esp
80105b73:	c9                   	leave  
80105b74:	c3                   	ret    

80105b75 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $0
80105b77:	6a 00                	push   $0x0
  jmp alltraps
80105b79:	e9 ec fa ff ff       	jmp    8010566a <alltraps>

80105b7e <vector1>:
.globl vector1
vector1:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $1
80105b80:	6a 01                	push   $0x1
  jmp alltraps
80105b82:	e9 e3 fa ff ff       	jmp    8010566a <alltraps>

80105b87 <vector2>:
.globl vector2
vector2:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $2
80105b89:	6a 02                	push   $0x2
  jmp alltraps
80105b8b:	e9 da fa ff ff       	jmp    8010566a <alltraps>

80105b90 <vector3>:
.globl vector3
vector3:
  pushl $0
80105b90:	6a 00                	push   $0x0
  pushl $3
80105b92:	6a 03                	push   $0x3
  jmp alltraps
80105b94:	e9 d1 fa ff ff       	jmp    8010566a <alltraps>

80105b99 <vector4>:
.globl vector4
vector4:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $4
80105b9b:	6a 04                	push   $0x4
  jmp alltraps
80105b9d:	e9 c8 fa ff ff       	jmp    8010566a <alltraps>

80105ba2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ba2:	6a 00                	push   $0x0
  pushl $5
80105ba4:	6a 05                	push   $0x5
  jmp alltraps
80105ba6:	e9 bf fa ff ff       	jmp    8010566a <alltraps>

80105bab <vector6>:
.globl vector6
vector6:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $6
80105bad:	6a 06                	push   $0x6
  jmp alltraps
80105baf:	e9 b6 fa ff ff       	jmp    8010566a <alltraps>

80105bb4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105bb4:	6a 00                	push   $0x0
  pushl $7
80105bb6:	6a 07                	push   $0x7
  jmp alltraps
80105bb8:	e9 ad fa ff ff       	jmp    8010566a <alltraps>

80105bbd <vector8>:
.globl vector8
vector8:
  pushl $8
80105bbd:	6a 08                	push   $0x8
  jmp alltraps
80105bbf:	e9 a6 fa ff ff       	jmp    8010566a <alltraps>

80105bc4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105bc4:	6a 00                	push   $0x0
  pushl $9
80105bc6:	6a 09                	push   $0x9
  jmp alltraps
80105bc8:	e9 9d fa ff ff       	jmp    8010566a <alltraps>

80105bcd <vector10>:
.globl vector10
vector10:
  pushl $10
80105bcd:	6a 0a                	push   $0xa
  jmp alltraps
80105bcf:	e9 96 fa ff ff       	jmp    8010566a <alltraps>

80105bd4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105bd4:	6a 0b                	push   $0xb
  jmp alltraps
80105bd6:	e9 8f fa ff ff       	jmp    8010566a <alltraps>

80105bdb <vector12>:
.globl vector12
vector12:
  pushl $12
80105bdb:	6a 0c                	push   $0xc
  jmp alltraps
80105bdd:	e9 88 fa ff ff       	jmp    8010566a <alltraps>

80105be2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105be2:	6a 0d                	push   $0xd
  jmp alltraps
80105be4:	e9 81 fa ff ff       	jmp    8010566a <alltraps>

80105be9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105be9:	6a 0e                	push   $0xe
  jmp alltraps
80105beb:	e9 7a fa ff ff       	jmp    8010566a <alltraps>

80105bf0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105bf0:	6a 00                	push   $0x0
  pushl $15
80105bf2:	6a 0f                	push   $0xf
  jmp alltraps
80105bf4:	e9 71 fa ff ff       	jmp    8010566a <alltraps>

80105bf9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105bf9:	6a 00                	push   $0x0
  pushl $16
80105bfb:	6a 10                	push   $0x10
  jmp alltraps
80105bfd:	e9 68 fa ff ff       	jmp    8010566a <alltraps>

80105c02 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c02:	6a 11                	push   $0x11
  jmp alltraps
80105c04:	e9 61 fa ff ff       	jmp    8010566a <alltraps>

80105c09 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c09:	6a 00                	push   $0x0
  pushl $18
80105c0b:	6a 12                	push   $0x12
  jmp alltraps
80105c0d:	e9 58 fa ff ff       	jmp    8010566a <alltraps>

80105c12 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $19
80105c14:	6a 13                	push   $0x13
  jmp alltraps
80105c16:	e9 4f fa ff ff       	jmp    8010566a <alltraps>

80105c1b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c1b:	6a 00                	push   $0x0
  pushl $20
80105c1d:	6a 14                	push   $0x14
  jmp alltraps
80105c1f:	e9 46 fa ff ff       	jmp    8010566a <alltraps>

80105c24 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c24:	6a 00                	push   $0x0
  pushl $21
80105c26:	6a 15                	push   $0x15
  jmp alltraps
80105c28:	e9 3d fa ff ff       	jmp    8010566a <alltraps>

80105c2d <vector22>:
.globl vector22
vector22:
  pushl $0
80105c2d:	6a 00                	push   $0x0
  pushl $22
80105c2f:	6a 16                	push   $0x16
  jmp alltraps
80105c31:	e9 34 fa ff ff       	jmp    8010566a <alltraps>

80105c36 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c36:	6a 00                	push   $0x0
  pushl $23
80105c38:	6a 17                	push   $0x17
  jmp alltraps
80105c3a:	e9 2b fa ff ff       	jmp    8010566a <alltraps>

80105c3f <vector24>:
.globl vector24
vector24:
  pushl $0
80105c3f:	6a 00                	push   $0x0
  pushl $24
80105c41:	6a 18                	push   $0x18
  jmp alltraps
80105c43:	e9 22 fa ff ff       	jmp    8010566a <alltraps>

80105c48 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c48:	6a 00                	push   $0x0
  pushl $25
80105c4a:	6a 19                	push   $0x19
  jmp alltraps
80105c4c:	e9 19 fa ff ff       	jmp    8010566a <alltraps>

80105c51 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c51:	6a 00                	push   $0x0
  pushl $26
80105c53:	6a 1a                	push   $0x1a
  jmp alltraps
80105c55:	e9 10 fa ff ff       	jmp    8010566a <alltraps>

80105c5a <vector27>:
.globl vector27
vector27:
  pushl $0
80105c5a:	6a 00                	push   $0x0
  pushl $27
80105c5c:	6a 1b                	push   $0x1b
  jmp alltraps
80105c5e:	e9 07 fa ff ff       	jmp    8010566a <alltraps>

80105c63 <vector28>:
.globl vector28
vector28:
  pushl $0
80105c63:	6a 00                	push   $0x0
  pushl $28
80105c65:	6a 1c                	push   $0x1c
  jmp alltraps
80105c67:	e9 fe f9 ff ff       	jmp    8010566a <alltraps>

80105c6c <vector29>:
.globl vector29
vector29:
  pushl $0
80105c6c:	6a 00                	push   $0x0
  pushl $29
80105c6e:	6a 1d                	push   $0x1d
  jmp alltraps
80105c70:	e9 f5 f9 ff ff       	jmp    8010566a <alltraps>

80105c75 <vector30>:
.globl vector30
vector30:
  pushl $0
80105c75:	6a 00                	push   $0x0
  pushl $30
80105c77:	6a 1e                	push   $0x1e
  jmp alltraps
80105c79:	e9 ec f9 ff ff       	jmp    8010566a <alltraps>

80105c7e <vector31>:
.globl vector31
vector31:
  pushl $0
80105c7e:	6a 00                	push   $0x0
  pushl $31
80105c80:	6a 1f                	push   $0x1f
  jmp alltraps
80105c82:	e9 e3 f9 ff ff       	jmp    8010566a <alltraps>

80105c87 <vector32>:
.globl vector32
vector32:
  pushl $0
80105c87:	6a 00                	push   $0x0
  pushl $32
80105c89:	6a 20                	push   $0x20
  jmp alltraps
80105c8b:	e9 da f9 ff ff       	jmp    8010566a <alltraps>

80105c90 <vector33>:
.globl vector33
vector33:
  pushl $0
80105c90:	6a 00                	push   $0x0
  pushl $33
80105c92:	6a 21                	push   $0x21
  jmp alltraps
80105c94:	e9 d1 f9 ff ff       	jmp    8010566a <alltraps>

80105c99 <vector34>:
.globl vector34
vector34:
  pushl $0
80105c99:	6a 00                	push   $0x0
  pushl $34
80105c9b:	6a 22                	push   $0x22
  jmp alltraps
80105c9d:	e9 c8 f9 ff ff       	jmp    8010566a <alltraps>

80105ca2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $35
80105ca4:	6a 23                	push   $0x23
  jmp alltraps
80105ca6:	e9 bf f9 ff ff       	jmp    8010566a <alltraps>

80105cab <vector36>:
.globl vector36
vector36:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $36
80105cad:	6a 24                	push   $0x24
  jmp alltraps
80105caf:	e9 b6 f9 ff ff       	jmp    8010566a <alltraps>

80105cb4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105cb4:	6a 00                	push   $0x0
  pushl $37
80105cb6:	6a 25                	push   $0x25
  jmp alltraps
80105cb8:	e9 ad f9 ff ff       	jmp    8010566a <alltraps>

80105cbd <vector38>:
.globl vector38
vector38:
  pushl $0
80105cbd:	6a 00                	push   $0x0
  pushl $38
80105cbf:	6a 26                	push   $0x26
  jmp alltraps
80105cc1:	e9 a4 f9 ff ff       	jmp    8010566a <alltraps>

80105cc6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $39
80105cc8:	6a 27                	push   $0x27
  jmp alltraps
80105cca:	e9 9b f9 ff ff       	jmp    8010566a <alltraps>

80105ccf <vector40>:
.globl vector40
vector40:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $40
80105cd1:	6a 28                	push   $0x28
  jmp alltraps
80105cd3:	e9 92 f9 ff ff       	jmp    8010566a <alltraps>

80105cd8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105cd8:	6a 00                	push   $0x0
  pushl $41
80105cda:	6a 29                	push   $0x29
  jmp alltraps
80105cdc:	e9 89 f9 ff ff       	jmp    8010566a <alltraps>

80105ce1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ce1:	6a 00                	push   $0x0
  pushl $42
80105ce3:	6a 2a                	push   $0x2a
  jmp alltraps
80105ce5:	e9 80 f9 ff ff       	jmp    8010566a <alltraps>

80105cea <vector43>:
.globl vector43
vector43:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $43
80105cec:	6a 2b                	push   $0x2b
  jmp alltraps
80105cee:	e9 77 f9 ff ff       	jmp    8010566a <alltraps>

80105cf3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $44
80105cf5:	6a 2c                	push   $0x2c
  jmp alltraps
80105cf7:	e9 6e f9 ff ff       	jmp    8010566a <alltraps>

80105cfc <vector45>:
.globl vector45
vector45:
  pushl $0
80105cfc:	6a 00                	push   $0x0
  pushl $45
80105cfe:	6a 2d                	push   $0x2d
  jmp alltraps
80105d00:	e9 65 f9 ff ff       	jmp    8010566a <alltraps>

80105d05 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d05:	6a 00                	push   $0x0
  pushl $46
80105d07:	6a 2e                	push   $0x2e
  jmp alltraps
80105d09:	e9 5c f9 ff ff       	jmp    8010566a <alltraps>

80105d0e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $47
80105d10:	6a 2f                	push   $0x2f
  jmp alltraps
80105d12:	e9 53 f9 ff ff       	jmp    8010566a <alltraps>

80105d17 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $48
80105d19:	6a 30                	push   $0x30
  jmp alltraps
80105d1b:	e9 4a f9 ff ff       	jmp    8010566a <alltraps>

80105d20 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d20:	6a 00                	push   $0x0
  pushl $49
80105d22:	6a 31                	push   $0x31
  jmp alltraps
80105d24:	e9 41 f9 ff ff       	jmp    8010566a <alltraps>

80105d29 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d29:	6a 00                	push   $0x0
  pushl $50
80105d2b:	6a 32                	push   $0x32
  jmp alltraps
80105d2d:	e9 38 f9 ff ff       	jmp    8010566a <alltraps>

80105d32 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $51
80105d34:	6a 33                	push   $0x33
  jmp alltraps
80105d36:	e9 2f f9 ff ff       	jmp    8010566a <alltraps>

80105d3b <vector52>:
.globl vector52
vector52:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $52
80105d3d:	6a 34                	push   $0x34
  jmp alltraps
80105d3f:	e9 26 f9 ff ff       	jmp    8010566a <alltraps>

80105d44 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d44:	6a 00                	push   $0x0
  pushl $53
80105d46:	6a 35                	push   $0x35
  jmp alltraps
80105d48:	e9 1d f9 ff ff       	jmp    8010566a <alltraps>

80105d4d <vector54>:
.globl vector54
vector54:
  pushl $0
80105d4d:	6a 00                	push   $0x0
  pushl $54
80105d4f:	6a 36                	push   $0x36
  jmp alltraps
80105d51:	e9 14 f9 ff ff       	jmp    8010566a <alltraps>

80105d56 <vector55>:
.globl vector55
vector55:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $55
80105d58:	6a 37                	push   $0x37
  jmp alltraps
80105d5a:	e9 0b f9 ff ff       	jmp    8010566a <alltraps>

80105d5f <vector56>:
.globl vector56
vector56:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $56
80105d61:	6a 38                	push   $0x38
  jmp alltraps
80105d63:	e9 02 f9 ff ff       	jmp    8010566a <alltraps>

80105d68 <vector57>:
.globl vector57
vector57:
  pushl $0
80105d68:	6a 00                	push   $0x0
  pushl $57
80105d6a:	6a 39                	push   $0x39
  jmp alltraps
80105d6c:	e9 f9 f8 ff ff       	jmp    8010566a <alltraps>

80105d71 <vector58>:
.globl vector58
vector58:
  pushl $0
80105d71:	6a 00                	push   $0x0
  pushl $58
80105d73:	6a 3a                	push   $0x3a
  jmp alltraps
80105d75:	e9 f0 f8 ff ff       	jmp    8010566a <alltraps>

80105d7a <vector59>:
.globl vector59
vector59:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $59
80105d7c:	6a 3b                	push   $0x3b
  jmp alltraps
80105d7e:	e9 e7 f8 ff ff       	jmp    8010566a <alltraps>

80105d83 <vector60>:
.globl vector60
vector60:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $60
80105d85:	6a 3c                	push   $0x3c
  jmp alltraps
80105d87:	e9 de f8 ff ff       	jmp    8010566a <alltraps>

80105d8c <vector61>:
.globl vector61
vector61:
  pushl $0
80105d8c:	6a 00                	push   $0x0
  pushl $61
80105d8e:	6a 3d                	push   $0x3d
  jmp alltraps
80105d90:	e9 d5 f8 ff ff       	jmp    8010566a <alltraps>

80105d95 <vector62>:
.globl vector62
vector62:
  pushl $0
80105d95:	6a 00                	push   $0x0
  pushl $62
80105d97:	6a 3e                	push   $0x3e
  jmp alltraps
80105d99:	e9 cc f8 ff ff       	jmp    8010566a <alltraps>

80105d9e <vector63>:
.globl vector63
vector63:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $63
80105da0:	6a 3f                	push   $0x3f
  jmp alltraps
80105da2:	e9 c3 f8 ff ff       	jmp    8010566a <alltraps>

80105da7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $64
80105da9:	6a 40                	push   $0x40
  jmp alltraps
80105dab:	e9 ba f8 ff ff       	jmp    8010566a <alltraps>

80105db0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105db0:	6a 00                	push   $0x0
  pushl $65
80105db2:	6a 41                	push   $0x41
  jmp alltraps
80105db4:	e9 b1 f8 ff ff       	jmp    8010566a <alltraps>

80105db9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105db9:	6a 00                	push   $0x0
  pushl $66
80105dbb:	6a 42                	push   $0x42
  jmp alltraps
80105dbd:	e9 a8 f8 ff ff       	jmp    8010566a <alltraps>

80105dc2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $67
80105dc4:	6a 43                	push   $0x43
  jmp alltraps
80105dc6:	e9 9f f8 ff ff       	jmp    8010566a <alltraps>

80105dcb <vector68>:
.globl vector68
vector68:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $68
80105dcd:	6a 44                	push   $0x44
  jmp alltraps
80105dcf:	e9 96 f8 ff ff       	jmp    8010566a <alltraps>

80105dd4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105dd4:	6a 00                	push   $0x0
  pushl $69
80105dd6:	6a 45                	push   $0x45
  jmp alltraps
80105dd8:	e9 8d f8 ff ff       	jmp    8010566a <alltraps>

80105ddd <vector70>:
.globl vector70
vector70:
  pushl $0
80105ddd:	6a 00                	push   $0x0
  pushl $70
80105ddf:	6a 46                	push   $0x46
  jmp alltraps
80105de1:	e9 84 f8 ff ff       	jmp    8010566a <alltraps>

80105de6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $71
80105de8:	6a 47                	push   $0x47
  jmp alltraps
80105dea:	e9 7b f8 ff ff       	jmp    8010566a <alltraps>

80105def <vector72>:
.globl vector72
vector72:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $72
80105df1:	6a 48                	push   $0x48
  jmp alltraps
80105df3:	e9 72 f8 ff ff       	jmp    8010566a <alltraps>

80105df8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105df8:	6a 00                	push   $0x0
  pushl $73
80105dfa:	6a 49                	push   $0x49
  jmp alltraps
80105dfc:	e9 69 f8 ff ff       	jmp    8010566a <alltraps>

80105e01 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e01:	6a 00                	push   $0x0
  pushl $74
80105e03:	6a 4a                	push   $0x4a
  jmp alltraps
80105e05:	e9 60 f8 ff ff       	jmp    8010566a <alltraps>

80105e0a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $75
80105e0c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e0e:	e9 57 f8 ff ff       	jmp    8010566a <alltraps>

80105e13 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $76
80105e15:	6a 4c                	push   $0x4c
  jmp alltraps
80105e17:	e9 4e f8 ff ff       	jmp    8010566a <alltraps>

80105e1c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e1c:	6a 00                	push   $0x0
  pushl $77
80105e1e:	6a 4d                	push   $0x4d
  jmp alltraps
80105e20:	e9 45 f8 ff ff       	jmp    8010566a <alltraps>

80105e25 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e25:	6a 00                	push   $0x0
  pushl $78
80105e27:	6a 4e                	push   $0x4e
  jmp alltraps
80105e29:	e9 3c f8 ff ff       	jmp    8010566a <alltraps>

80105e2e <vector79>:
.globl vector79
vector79:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $79
80105e30:	6a 4f                	push   $0x4f
  jmp alltraps
80105e32:	e9 33 f8 ff ff       	jmp    8010566a <alltraps>

80105e37 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $80
80105e39:	6a 50                	push   $0x50
  jmp alltraps
80105e3b:	e9 2a f8 ff ff       	jmp    8010566a <alltraps>

80105e40 <vector81>:
.globl vector81
vector81:
  pushl $0
80105e40:	6a 00                	push   $0x0
  pushl $81
80105e42:	6a 51                	push   $0x51
  jmp alltraps
80105e44:	e9 21 f8 ff ff       	jmp    8010566a <alltraps>

80105e49 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $82
80105e4b:	6a 52                	push   $0x52
  jmp alltraps
80105e4d:	e9 18 f8 ff ff       	jmp    8010566a <alltraps>

80105e52 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $83
80105e54:	6a 53                	push   $0x53
  jmp alltraps
80105e56:	e9 0f f8 ff ff       	jmp    8010566a <alltraps>

80105e5b <vector84>:
.globl vector84
vector84:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $84
80105e5d:	6a 54                	push   $0x54
  jmp alltraps
80105e5f:	e9 06 f8 ff ff       	jmp    8010566a <alltraps>

80105e64 <vector85>:
.globl vector85
vector85:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $85
80105e66:	6a 55                	push   $0x55
  jmp alltraps
80105e68:	e9 fd f7 ff ff       	jmp    8010566a <alltraps>

80105e6d <vector86>:
.globl vector86
vector86:
  pushl $0
80105e6d:	6a 00                	push   $0x0
  pushl $86
80105e6f:	6a 56                	push   $0x56
  jmp alltraps
80105e71:	e9 f4 f7 ff ff       	jmp    8010566a <alltraps>

80105e76 <vector87>:
.globl vector87
vector87:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $87
80105e78:	6a 57                	push   $0x57
  jmp alltraps
80105e7a:	e9 eb f7 ff ff       	jmp    8010566a <alltraps>

80105e7f <vector88>:
.globl vector88
vector88:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $88
80105e81:	6a 58                	push   $0x58
  jmp alltraps
80105e83:	e9 e2 f7 ff ff       	jmp    8010566a <alltraps>

80105e88 <vector89>:
.globl vector89
vector89:
  pushl $0
80105e88:	6a 00                	push   $0x0
  pushl $89
80105e8a:	6a 59                	push   $0x59
  jmp alltraps
80105e8c:	e9 d9 f7 ff ff       	jmp    8010566a <alltraps>

80105e91 <vector90>:
.globl vector90
vector90:
  pushl $0
80105e91:	6a 00                	push   $0x0
  pushl $90
80105e93:	6a 5a                	push   $0x5a
  jmp alltraps
80105e95:	e9 d0 f7 ff ff       	jmp    8010566a <alltraps>

80105e9a <vector91>:
.globl vector91
vector91:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $91
80105e9c:	6a 5b                	push   $0x5b
  jmp alltraps
80105e9e:	e9 c7 f7 ff ff       	jmp    8010566a <alltraps>

80105ea3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $92
80105ea5:	6a 5c                	push   $0x5c
  jmp alltraps
80105ea7:	e9 be f7 ff ff       	jmp    8010566a <alltraps>

80105eac <vector93>:
.globl vector93
vector93:
  pushl $0
80105eac:	6a 00                	push   $0x0
  pushl $93
80105eae:	6a 5d                	push   $0x5d
  jmp alltraps
80105eb0:	e9 b5 f7 ff ff       	jmp    8010566a <alltraps>

80105eb5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $94
80105eb7:	6a 5e                	push   $0x5e
  jmp alltraps
80105eb9:	e9 ac f7 ff ff       	jmp    8010566a <alltraps>

80105ebe <vector95>:
.globl vector95
vector95:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $95
80105ec0:	6a 5f                	push   $0x5f
  jmp alltraps
80105ec2:	e9 a3 f7 ff ff       	jmp    8010566a <alltraps>

80105ec7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $96
80105ec9:	6a 60                	push   $0x60
  jmp alltraps
80105ecb:	e9 9a f7 ff ff       	jmp    8010566a <alltraps>

80105ed0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $97
80105ed2:	6a 61                	push   $0x61
  jmp alltraps
80105ed4:	e9 91 f7 ff ff       	jmp    8010566a <alltraps>

80105ed9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $98
80105edb:	6a 62                	push   $0x62
  jmp alltraps
80105edd:	e9 88 f7 ff ff       	jmp    8010566a <alltraps>

80105ee2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $99
80105ee4:	6a 63                	push   $0x63
  jmp alltraps
80105ee6:	e9 7f f7 ff ff       	jmp    8010566a <alltraps>

80105eeb <vector100>:
.globl vector100
vector100:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $100
80105eed:	6a 64                	push   $0x64
  jmp alltraps
80105eef:	e9 76 f7 ff ff       	jmp    8010566a <alltraps>

80105ef4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $101
80105ef6:	6a 65                	push   $0x65
  jmp alltraps
80105ef8:	e9 6d f7 ff ff       	jmp    8010566a <alltraps>

80105efd <vector102>:
.globl vector102
vector102:
  pushl $0
80105efd:	6a 00                	push   $0x0
  pushl $102
80105eff:	6a 66                	push   $0x66
  jmp alltraps
80105f01:	e9 64 f7 ff ff       	jmp    8010566a <alltraps>

80105f06 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $103
80105f08:	6a 67                	push   $0x67
  jmp alltraps
80105f0a:	e9 5b f7 ff ff       	jmp    8010566a <alltraps>

80105f0f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $104
80105f11:	6a 68                	push   $0x68
  jmp alltraps
80105f13:	e9 52 f7 ff ff       	jmp    8010566a <alltraps>

80105f18 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f18:	6a 00                	push   $0x0
  pushl $105
80105f1a:	6a 69                	push   $0x69
  jmp alltraps
80105f1c:	e9 49 f7 ff ff       	jmp    8010566a <alltraps>

80105f21 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f21:	6a 00                	push   $0x0
  pushl $106
80105f23:	6a 6a                	push   $0x6a
  jmp alltraps
80105f25:	e9 40 f7 ff ff       	jmp    8010566a <alltraps>

80105f2a <vector107>:
.globl vector107
vector107:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $107
80105f2c:	6a 6b                	push   $0x6b
  jmp alltraps
80105f2e:	e9 37 f7 ff ff       	jmp    8010566a <alltraps>

80105f33 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $108
80105f35:	6a 6c                	push   $0x6c
  jmp alltraps
80105f37:	e9 2e f7 ff ff       	jmp    8010566a <alltraps>

80105f3c <vector109>:
.globl vector109
vector109:
  pushl $0
80105f3c:	6a 00                	push   $0x0
  pushl $109
80105f3e:	6a 6d                	push   $0x6d
  jmp alltraps
80105f40:	e9 25 f7 ff ff       	jmp    8010566a <alltraps>

80105f45 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $110
80105f47:	6a 6e                	push   $0x6e
  jmp alltraps
80105f49:	e9 1c f7 ff ff       	jmp    8010566a <alltraps>

80105f4e <vector111>:
.globl vector111
vector111:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $111
80105f50:	6a 6f                	push   $0x6f
  jmp alltraps
80105f52:	e9 13 f7 ff ff       	jmp    8010566a <alltraps>

80105f57 <vector112>:
.globl vector112
vector112:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $112
80105f59:	6a 70                	push   $0x70
  jmp alltraps
80105f5b:	e9 0a f7 ff ff       	jmp    8010566a <alltraps>

80105f60 <vector113>:
.globl vector113
vector113:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $113
80105f62:	6a 71                	push   $0x71
  jmp alltraps
80105f64:	e9 01 f7 ff ff       	jmp    8010566a <alltraps>

80105f69 <vector114>:
.globl vector114
vector114:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $114
80105f6b:	6a 72                	push   $0x72
  jmp alltraps
80105f6d:	e9 f8 f6 ff ff       	jmp    8010566a <alltraps>

80105f72 <vector115>:
.globl vector115
vector115:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $115
80105f74:	6a 73                	push   $0x73
  jmp alltraps
80105f76:	e9 ef f6 ff ff       	jmp    8010566a <alltraps>

80105f7b <vector116>:
.globl vector116
vector116:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $116
80105f7d:	6a 74                	push   $0x74
  jmp alltraps
80105f7f:	e9 e6 f6 ff ff       	jmp    8010566a <alltraps>

80105f84 <vector117>:
.globl vector117
vector117:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $117
80105f86:	6a 75                	push   $0x75
  jmp alltraps
80105f88:	e9 dd f6 ff ff       	jmp    8010566a <alltraps>

80105f8d <vector118>:
.globl vector118
vector118:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $118
80105f8f:	6a 76                	push   $0x76
  jmp alltraps
80105f91:	e9 d4 f6 ff ff       	jmp    8010566a <alltraps>

80105f96 <vector119>:
.globl vector119
vector119:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $119
80105f98:	6a 77                	push   $0x77
  jmp alltraps
80105f9a:	e9 cb f6 ff ff       	jmp    8010566a <alltraps>

80105f9f <vector120>:
.globl vector120
vector120:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $120
80105fa1:	6a 78                	push   $0x78
  jmp alltraps
80105fa3:	e9 c2 f6 ff ff       	jmp    8010566a <alltraps>

80105fa8 <vector121>:
.globl vector121
vector121:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $121
80105faa:	6a 79                	push   $0x79
  jmp alltraps
80105fac:	e9 b9 f6 ff ff       	jmp    8010566a <alltraps>

80105fb1 <vector122>:
.globl vector122
vector122:
  pushl $0
80105fb1:	6a 00                	push   $0x0
  pushl $122
80105fb3:	6a 7a                	push   $0x7a
  jmp alltraps
80105fb5:	e9 b0 f6 ff ff       	jmp    8010566a <alltraps>

80105fba <vector123>:
.globl vector123
vector123:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $123
80105fbc:	6a 7b                	push   $0x7b
  jmp alltraps
80105fbe:	e9 a7 f6 ff ff       	jmp    8010566a <alltraps>

80105fc3 <vector124>:
.globl vector124
vector124:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $124
80105fc5:	6a 7c                	push   $0x7c
  jmp alltraps
80105fc7:	e9 9e f6 ff ff       	jmp    8010566a <alltraps>

80105fcc <vector125>:
.globl vector125
vector125:
  pushl $0
80105fcc:	6a 00                	push   $0x0
  pushl $125
80105fce:	6a 7d                	push   $0x7d
  jmp alltraps
80105fd0:	e9 95 f6 ff ff       	jmp    8010566a <alltraps>

80105fd5 <vector126>:
.globl vector126
vector126:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $126
80105fd7:	6a 7e                	push   $0x7e
  jmp alltraps
80105fd9:	e9 8c f6 ff ff       	jmp    8010566a <alltraps>

80105fde <vector127>:
.globl vector127
vector127:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $127
80105fe0:	6a 7f                	push   $0x7f
  jmp alltraps
80105fe2:	e9 83 f6 ff ff       	jmp    8010566a <alltraps>

80105fe7 <vector128>:
.globl vector128
vector128:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $128
80105fe9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105fee:	e9 77 f6 ff ff       	jmp    8010566a <alltraps>

80105ff3 <vector129>:
.globl vector129
vector129:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $129
80105ff5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105ffa:	e9 6b f6 ff ff       	jmp    8010566a <alltraps>

80105fff <vector130>:
.globl vector130
vector130:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $130
80106001:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106006:	e9 5f f6 ff ff       	jmp    8010566a <alltraps>

8010600b <vector131>:
.globl vector131
vector131:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $131
8010600d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106012:	e9 53 f6 ff ff       	jmp    8010566a <alltraps>

80106017 <vector132>:
.globl vector132
vector132:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $132
80106019:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010601e:	e9 47 f6 ff ff       	jmp    8010566a <alltraps>

80106023 <vector133>:
.globl vector133
vector133:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $133
80106025:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010602a:	e9 3b f6 ff ff       	jmp    8010566a <alltraps>

8010602f <vector134>:
.globl vector134
vector134:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $134
80106031:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106036:	e9 2f f6 ff ff       	jmp    8010566a <alltraps>

8010603b <vector135>:
.globl vector135
vector135:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $135
8010603d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106042:	e9 23 f6 ff ff       	jmp    8010566a <alltraps>

80106047 <vector136>:
.globl vector136
vector136:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $136
80106049:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010604e:	e9 17 f6 ff ff       	jmp    8010566a <alltraps>

80106053 <vector137>:
.globl vector137
vector137:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $137
80106055:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010605a:	e9 0b f6 ff ff       	jmp    8010566a <alltraps>

8010605f <vector138>:
.globl vector138
vector138:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $138
80106061:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106066:	e9 ff f5 ff ff       	jmp    8010566a <alltraps>

8010606b <vector139>:
.globl vector139
vector139:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $139
8010606d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106072:	e9 f3 f5 ff ff       	jmp    8010566a <alltraps>

80106077 <vector140>:
.globl vector140
vector140:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $140
80106079:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010607e:	e9 e7 f5 ff ff       	jmp    8010566a <alltraps>

80106083 <vector141>:
.globl vector141
vector141:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $141
80106085:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010608a:	e9 db f5 ff ff       	jmp    8010566a <alltraps>

8010608f <vector142>:
.globl vector142
vector142:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $142
80106091:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106096:	e9 cf f5 ff ff       	jmp    8010566a <alltraps>

8010609b <vector143>:
.globl vector143
vector143:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $143
8010609d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801060a2:	e9 c3 f5 ff ff       	jmp    8010566a <alltraps>

801060a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $144
801060a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801060ae:	e9 b7 f5 ff ff       	jmp    8010566a <alltraps>

801060b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $145
801060b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801060ba:	e9 ab f5 ff ff       	jmp    8010566a <alltraps>

801060bf <vector146>:
.globl vector146
vector146:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $146
801060c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801060c6:	e9 9f f5 ff ff       	jmp    8010566a <alltraps>

801060cb <vector147>:
.globl vector147
vector147:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $147
801060cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801060d2:	e9 93 f5 ff ff       	jmp    8010566a <alltraps>

801060d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $148
801060d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801060de:	e9 87 f5 ff ff       	jmp    8010566a <alltraps>

801060e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $149
801060e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801060ea:	e9 7b f5 ff ff       	jmp    8010566a <alltraps>

801060ef <vector150>:
.globl vector150
vector150:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $150
801060f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801060f6:	e9 6f f5 ff ff       	jmp    8010566a <alltraps>

801060fb <vector151>:
.globl vector151
vector151:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $151
801060fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106102:	e9 63 f5 ff ff       	jmp    8010566a <alltraps>

80106107 <vector152>:
.globl vector152
vector152:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $152
80106109:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010610e:	e9 57 f5 ff ff       	jmp    8010566a <alltraps>

80106113 <vector153>:
.globl vector153
vector153:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $153
80106115:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010611a:	e9 4b f5 ff ff       	jmp    8010566a <alltraps>

8010611f <vector154>:
.globl vector154
vector154:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $154
80106121:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106126:	e9 3f f5 ff ff       	jmp    8010566a <alltraps>

8010612b <vector155>:
.globl vector155
vector155:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $155
8010612d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106132:	e9 33 f5 ff ff       	jmp    8010566a <alltraps>

80106137 <vector156>:
.globl vector156
vector156:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $156
80106139:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010613e:	e9 27 f5 ff ff       	jmp    8010566a <alltraps>

80106143 <vector157>:
.globl vector157
vector157:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $157
80106145:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010614a:	e9 1b f5 ff ff       	jmp    8010566a <alltraps>

8010614f <vector158>:
.globl vector158
vector158:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $158
80106151:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106156:	e9 0f f5 ff ff       	jmp    8010566a <alltraps>

8010615b <vector159>:
.globl vector159
vector159:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $159
8010615d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106162:	e9 03 f5 ff ff       	jmp    8010566a <alltraps>

80106167 <vector160>:
.globl vector160
vector160:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $160
80106169:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010616e:	e9 f7 f4 ff ff       	jmp    8010566a <alltraps>

80106173 <vector161>:
.globl vector161
vector161:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $161
80106175:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010617a:	e9 eb f4 ff ff       	jmp    8010566a <alltraps>

8010617f <vector162>:
.globl vector162
vector162:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $162
80106181:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106186:	e9 df f4 ff ff       	jmp    8010566a <alltraps>

8010618b <vector163>:
.globl vector163
vector163:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $163
8010618d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106192:	e9 d3 f4 ff ff       	jmp    8010566a <alltraps>

80106197 <vector164>:
.globl vector164
vector164:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $164
80106199:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010619e:	e9 c7 f4 ff ff       	jmp    8010566a <alltraps>

801061a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $165
801061a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801061aa:	e9 bb f4 ff ff       	jmp    8010566a <alltraps>

801061af <vector166>:
.globl vector166
vector166:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $166
801061b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801061b6:	e9 af f4 ff ff       	jmp    8010566a <alltraps>

801061bb <vector167>:
.globl vector167
vector167:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $167
801061bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801061c2:	e9 a3 f4 ff ff       	jmp    8010566a <alltraps>

801061c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $168
801061c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801061ce:	e9 97 f4 ff ff       	jmp    8010566a <alltraps>

801061d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $169
801061d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801061da:	e9 8b f4 ff ff       	jmp    8010566a <alltraps>

801061df <vector170>:
.globl vector170
vector170:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $170
801061e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801061e6:	e9 7f f4 ff ff       	jmp    8010566a <alltraps>

801061eb <vector171>:
.globl vector171
vector171:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $171
801061ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801061f2:	e9 73 f4 ff ff       	jmp    8010566a <alltraps>

801061f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $172
801061f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801061fe:	e9 67 f4 ff ff       	jmp    8010566a <alltraps>

80106203 <vector173>:
.globl vector173
vector173:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $173
80106205:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010620a:	e9 5b f4 ff ff       	jmp    8010566a <alltraps>

8010620f <vector174>:
.globl vector174
vector174:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $174
80106211:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106216:	e9 4f f4 ff ff       	jmp    8010566a <alltraps>

8010621b <vector175>:
.globl vector175
vector175:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $175
8010621d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106222:	e9 43 f4 ff ff       	jmp    8010566a <alltraps>

80106227 <vector176>:
.globl vector176
vector176:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $176
80106229:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010622e:	e9 37 f4 ff ff       	jmp    8010566a <alltraps>

80106233 <vector177>:
.globl vector177
vector177:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $177
80106235:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010623a:	e9 2b f4 ff ff       	jmp    8010566a <alltraps>

8010623f <vector178>:
.globl vector178
vector178:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $178
80106241:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106246:	e9 1f f4 ff ff       	jmp    8010566a <alltraps>

8010624b <vector179>:
.globl vector179
vector179:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $179
8010624d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106252:	e9 13 f4 ff ff       	jmp    8010566a <alltraps>

80106257 <vector180>:
.globl vector180
vector180:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $180
80106259:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010625e:	e9 07 f4 ff ff       	jmp    8010566a <alltraps>

80106263 <vector181>:
.globl vector181
vector181:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $181
80106265:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010626a:	e9 fb f3 ff ff       	jmp    8010566a <alltraps>

8010626f <vector182>:
.globl vector182
vector182:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $182
80106271:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106276:	e9 ef f3 ff ff       	jmp    8010566a <alltraps>

8010627b <vector183>:
.globl vector183
vector183:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $183
8010627d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106282:	e9 e3 f3 ff ff       	jmp    8010566a <alltraps>

80106287 <vector184>:
.globl vector184
vector184:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $184
80106289:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010628e:	e9 d7 f3 ff ff       	jmp    8010566a <alltraps>

80106293 <vector185>:
.globl vector185
vector185:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $185
80106295:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010629a:	e9 cb f3 ff ff       	jmp    8010566a <alltraps>

8010629f <vector186>:
.globl vector186
vector186:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $186
801062a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801062a6:	e9 bf f3 ff ff       	jmp    8010566a <alltraps>

801062ab <vector187>:
.globl vector187
vector187:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $187
801062ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801062b2:	e9 b3 f3 ff ff       	jmp    8010566a <alltraps>

801062b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $188
801062b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801062be:	e9 a7 f3 ff ff       	jmp    8010566a <alltraps>

801062c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $189
801062c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801062ca:	e9 9b f3 ff ff       	jmp    8010566a <alltraps>

801062cf <vector190>:
.globl vector190
vector190:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $190
801062d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801062d6:	e9 8f f3 ff ff       	jmp    8010566a <alltraps>

801062db <vector191>:
.globl vector191
vector191:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $191
801062dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801062e2:	e9 83 f3 ff ff       	jmp    8010566a <alltraps>

801062e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $192
801062e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801062ee:	e9 77 f3 ff ff       	jmp    8010566a <alltraps>

801062f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $193
801062f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801062fa:	e9 6b f3 ff ff       	jmp    8010566a <alltraps>

801062ff <vector194>:
.globl vector194
vector194:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $194
80106301:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106306:	e9 5f f3 ff ff       	jmp    8010566a <alltraps>

8010630b <vector195>:
.globl vector195
vector195:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $195
8010630d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106312:	e9 53 f3 ff ff       	jmp    8010566a <alltraps>

80106317 <vector196>:
.globl vector196
vector196:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $196
80106319:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010631e:	e9 47 f3 ff ff       	jmp    8010566a <alltraps>

80106323 <vector197>:
.globl vector197
vector197:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $197
80106325:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010632a:	e9 3b f3 ff ff       	jmp    8010566a <alltraps>

8010632f <vector198>:
.globl vector198
vector198:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $198
80106331:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106336:	e9 2f f3 ff ff       	jmp    8010566a <alltraps>

8010633b <vector199>:
.globl vector199
vector199:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $199
8010633d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106342:	e9 23 f3 ff ff       	jmp    8010566a <alltraps>

80106347 <vector200>:
.globl vector200
vector200:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $200
80106349:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010634e:	e9 17 f3 ff ff       	jmp    8010566a <alltraps>

80106353 <vector201>:
.globl vector201
vector201:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $201
80106355:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010635a:	e9 0b f3 ff ff       	jmp    8010566a <alltraps>

8010635f <vector202>:
.globl vector202
vector202:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $202
80106361:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106366:	e9 ff f2 ff ff       	jmp    8010566a <alltraps>

8010636b <vector203>:
.globl vector203
vector203:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $203
8010636d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106372:	e9 f3 f2 ff ff       	jmp    8010566a <alltraps>

80106377 <vector204>:
.globl vector204
vector204:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $204
80106379:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010637e:	e9 e7 f2 ff ff       	jmp    8010566a <alltraps>

80106383 <vector205>:
.globl vector205
vector205:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $205
80106385:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010638a:	e9 db f2 ff ff       	jmp    8010566a <alltraps>

8010638f <vector206>:
.globl vector206
vector206:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $206
80106391:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106396:	e9 cf f2 ff ff       	jmp    8010566a <alltraps>

8010639b <vector207>:
.globl vector207
vector207:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $207
8010639d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801063a2:	e9 c3 f2 ff ff       	jmp    8010566a <alltraps>

801063a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $208
801063a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801063ae:	e9 b7 f2 ff ff       	jmp    8010566a <alltraps>

801063b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $209
801063b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801063ba:	e9 ab f2 ff ff       	jmp    8010566a <alltraps>

801063bf <vector210>:
.globl vector210
vector210:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $210
801063c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801063c6:	e9 9f f2 ff ff       	jmp    8010566a <alltraps>

801063cb <vector211>:
.globl vector211
vector211:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $211
801063cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801063d2:	e9 93 f2 ff ff       	jmp    8010566a <alltraps>

801063d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $212
801063d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801063de:	e9 87 f2 ff ff       	jmp    8010566a <alltraps>

801063e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $213
801063e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801063ea:	e9 7b f2 ff ff       	jmp    8010566a <alltraps>

801063ef <vector214>:
.globl vector214
vector214:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $214
801063f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801063f6:	e9 6f f2 ff ff       	jmp    8010566a <alltraps>

801063fb <vector215>:
.globl vector215
vector215:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $215
801063fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106402:	e9 63 f2 ff ff       	jmp    8010566a <alltraps>

80106407 <vector216>:
.globl vector216
vector216:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $216
80106409:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010640e:	e9 57 f2 ff ff       	jmp    8010566a <alltraps>

80106413 <vector217>:
.globl vector217
vector217:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $217
80106415:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010641a:	e9 4b f2 ff ff       	jmp    8010566a <alltraps>

8010641f <vector218>:
.globl vector218
vector218:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $218
80106421:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106426:	e9 3f f2 ff ff       	jmp    8010566a <alltraps>

8010642b <vector219>:
.globl vector219
vector219:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $219
8010642d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106432:	e9 33 f2 ff ff       	jmp    8010566a <alltraps>

80106437 <vector220>:
.globl vector220
vector220:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $220
80106439:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010643e:	e9 27 f2 ff ff       	jmp    8010566a <alltraps>

80106443 <vector221>:
.globl vector221
vector221:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $221
80106445:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010644a:	e9 1b f2 ff ff       	jmp    8010566a <alltraps>

8010644f <vector222>:
.globl vector222
vector222:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $222
80106451:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106456:	e9 0f f2 ff ff       	jmp    8010566a <alltraps>

8010645b <vector223>:
.globl vector223
vector223:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $223
8010645d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106462:	e9 03 f2 ff ff       	jmp    8010566a <alltraps>

80106467 <vector224>:
.globl vector224
vector224:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $224
80106469:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010646e:	e9 f7 f1 ff ff       	jmp    8010566a <alltraps>

80106473 <vector225>:
.globl vector225
vector225:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $225
80106475:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010647a:	e9 eb f1 ff ff       	jmp    8010566a <alltraps>

8010647f <vector226>:
.globl vector226
vector226:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $226
80106481:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106486:	e9 df f1 ff ff       	jmp    8010566a <alltraps>

8010648b <vector227>:
.globl vector227
vector227:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $227
8010648d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106492:	e9 d3 f1 ff ff       	jmp    8010566a <alltraps>

80106497 <vector228>:
.globl vector228
vector228:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $228
80106499:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010649e:	e9 c7 f1 ff ff       	jmp    8010566a <alltraps>

801064a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $229
801064a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801064aa:	e9 bb f1 ff ff       	jmp    8010566a <alltraps>

801064af <vector230>:
.globl vector230
vector230:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $230
801064b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801064b6:	e9 af f1 ff ff       	jmp    8010566a <alltraps>

801064bb <vector231>:
.globl vector231
vector231:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $231
801064bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801064c2:	e9 a3 f1 ff ff       	jmp    8010566a <alltraps>

801064c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $232
801064c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801064ce:	e9 97 f1 ff ff       	jmp    8010566a <alltraps>

801064d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $233
801064d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801064da:	e9 8b f1 ff ff       	jmp    8010566a <alltraps>

801064df <vector234>:
.globl vector234
vector234:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $234
801064e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801064e6:	e9 7f f1 ff ff       	jmp    8010566a <alltraps>

801064eb <vector235>:
.globl vector235
vector235:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $235
801064ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801064f2:	e9 73 f1 ff ff       	jmp    8010566a <alltraps>

801064f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $236
801064f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801064fe:	e9 67 f1 ff ff       	jmp    8010566a <alltraps>

80106503 <vector237>:
.globl vector237
vector237:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $237
80106505:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010650a:	e9 5b f1 ff ff       	jmp    8010566a <alltraps>

8010650f <vector238>:
.globl vector238
vector238:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $238
80106511:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106516:	e9 4f f1 ff ff       	jmp    8010566a <alltraps>

8010651b <vector239>:
.globl vector239
vector239:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $239
8010651d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106522:	e9 43 f1 ff ff       	jmp    8010566a <alltraps>

80106527 <vector240>:
.globl vector240
vector240:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $240
80106529:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010652e:	e9 37 f1 ff ff       	jmp    8010566a <alltraps>

80106533 <vector241>:
.globl vector241
vector241:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $241
80106535:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010653a:	e9 2b f1 ff ff       	jmp    8010566a <alltraps>

8010653f <vector242>:
.globl vector242
vector242:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $242
80106541:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106546:	e9 1f f1 ff ff       	jmp    8010566a <alltraps>

8010654b <vector243>:
.globl vector243
vector243:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $243
8010654d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106552:	e9 13 f1 ff ff       	jmp    8010566a <alltraps>

80106557 <vector244>:
.globl vector244
vector244:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $244
80106559:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010655e:	e9 07 f1 ff ff       	jmp    8010566a <alltraps>

80106563 <vector245>:
.globl vector245
vector245:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $245
80106565:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010656a:	e9 fb f0 ff ff       	jmp    8010566a <alltraps>

8010656f <vector246>:
.globl vector246
vector246:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $246
80106571:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106576:	e9 ef f0 ff ff       	jmp    8010566a <alltraps>

8010657b <vector247>:
.globl vector247
vector247:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $247
8010657d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106582:	e9 e3 f0 ff ff       	jmp    8010566a <alltraps>

80106587 <vector248>:
.globl vector248
vector248:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $248
80106589:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010658e:	e9 d7 f0 ff ff       	jmp    8010566a <alltraps>

80106593 <vector249>:
.globl vector249
vector249:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $249
80106595:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010659a:	e9 cb f0 ff ff       	jmp    8010566a <alltraps>

8010659f <vector250>:
.globl vector250
vector250:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $250
801065a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801065a6:	e9 bf f0 ff ff       	jmp    8010566a <alltraps>

801065ab <vector251>:
.globl vector251
vector251:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $251
801065ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801065b2:	e9 b3 f0 ff ff       	jmp    8010566a <alltraps>

801065b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $252
801065b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801065be:	e9 a7 f0 ff ff       	jmp    8010566a <alltraps>

801065c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $253
801065c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801065ca:	e9 9b f0 ff ff       	jmp    8010566a <alltraps>

801065cf <vector254>:
.globl vector254
vector254:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $254
801065d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801065d6:	e9 8f f0 ff ff       	jmp    8010566a <alltraps>

801065db <vector255>:
.globl vector255
vector255:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $255
801065dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801065e2:	e9 83 f0 ff ff       	jmp    8010566a <alltraps>
801065e7:	66 90                	xchg   %ax,%ax
801065e9:	66 90                	xchg   %ax,%ax
801065eb:	66 90                	xchg   %ax,%ax
801065ed:	66 90                	xchg   %ax,%ax
801065ef:	90                   	nop

801065f0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	57                   	push   %edi
801065f4:	56                   	push   %esi
801065f5:	53                   	push   %ebx
801065f6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801065f8:	c1 ea 16             	shr    $0x16,%edx
801065fb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065fe:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106601:	8b 07                	mov    (%edi),%eax
80106603:	a8 01                	test   $0x1,%al
80106605:	74 29                	je     80106630 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106607:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010660c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106612:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106615:	c1 eb 0a             	shr    $0xa,%ebx
80106618:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010661e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106621:	5b                   	pop    %ebx
80106622:	5e                   	pop    %esi
80106623:	5f                   	pop    %edi
80106624:	5d                   	pop    %ebp
80106625:	c3                   	ret    
80106626:	8d 76 00             	lea    0x0(%esi),%esi
80106629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106630:	85 c9                	test   %ecx,%ecx
80106632:	74 2c                	je     80106660 <walkpgdir+0x70>
80106634:	e8 37 be ff ff       	call   80102470 <kalloc>
80106639:	85 c0                	test   %eax,%eax
8010663b:	89 c6                	mov    %eax,%esi
8010663d:	74 21                	je     80106660 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010663f:	83 ec 04             	sub    $0x4,%esp
80106642:	68 00 10 00 00       	push   $0x1000
80106647:	6a 00                	push   $0x0
80106649:	50                   	push   %eax
8010664a:	e8 a1 dd ff ff       	call   801043f0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010664f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106655:	83 c4 10             	add    $0x10,%esp
80106658:	83 c8 07             	or     $0x7,%eax
8010665b:	89 07                	mov    %eax,(%edi)
8010665d:	eb b3                	jmp    80106612 <walkpgdir+0x22>
8010665f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106660:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106663:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106665:	5b                   	pop    %ebx
80106666:	5e                   	pop    %esi
80106667:	5f                   	pop    %edi
80106668:	5d                   	pop    %ebp
80106669:	c3                   	ret    
8010666a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106670 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	57                   	push   %edi
80106674:	56                   	push   %esi
80106675:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106676:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010667c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010667e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106684:	83 ec 1c             	sub    $0x1c,%esp
80106687:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010668a:	39 d3                	cmp    %edx,%ebx
8010668c:	73 66                	jae    801066f4 <deallocuvm.part.0+0x84>
8010668e:	89 d6                	mov    %edx,%esi
80106690:	eb 3d                	jmp    801066cf <deallocuvm.part.0+0x5f>
80106692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106698:	8b 10                	mov    (%eax),%edx
8010669a:	f6 c2 01             	test   $0x1,%dl
8010669d:	74 26                	je     801066c5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010669f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801066a5:	74 58                	je     801066ff <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801066a7:	83 ec 0c             	sub    $0xc,%esp
801066aa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801066b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066b3:	52                   	push   %edx
801066b4:	e8 07 bc ff ff       	call   801022c0 <kfree>
      *pte = 0;
801066b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066bc:	83 c4 10             	add    $0x10,%esp
801066bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801066c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066cb:	39 f3                	cmp    %esi,%ebx
801066cd:	73 25                	jae    801066f4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801066cf:	31 c9                	xor    %ecx,%ecx
801066d1:	89 da                	mov    %ebx,%edx
801066d3:	89 f8                	mov    %edi,%eax
801066d5:	e8 16 ff ff ff       	call   801065f0 <walkpgdir>
    if(!pte)
801066da:	85 c0                	test   %eax,%eax
801066dc:	75 ba                	jne    80106698 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801066de:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801066e4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801066ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066f0:	39 f3                	cmp    %esi,%ebx
801066f2:	72 db                	jb     801066cf <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801066f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801066f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066fa:	5b                   	pop    %ebx
801066fb:	5e                   	pop    %esi
801066fc:	5f                   	pop    %edi
801066fd:	5d                   	pop    %ebp
801066fe:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801066ff:	83 ec 0c             	sub    $0xc,%esp
80106702:	68 e6 72 10 80       	push   $0x801072e6
80106707:	e8 64 9c ff ff       	call   80100370 <panic>
8010670c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106710 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106716:	e8 25 d0 ff ff       	call   80103740 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010671b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106721:	31 c9                	xor    %ecx,%ecx
80106723:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106728:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
8010672f:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106736:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010673b:	31 c9                	xor    %ecx,%ecx
8010673d:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106744:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106749:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106750:	31 c9                	xor    %ecx,%ecx
80106752:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
80106759:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106760:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106765:	31 c9                	xor    %ecx,%ecx
80106767:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010676e:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106775:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010677a:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
80106781:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
80106788:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010678f:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80106796:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
8010679d:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
801067a4:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067ab:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
801067b2:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
801067b9:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
801067c0:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067c7:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
801067ce:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
801067d5:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
801067dc:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
801067e3:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801067ea:	05 f0 27 11 80       	add    $0x801127f0,%eax
801067ef:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801067f3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801067f7:	c1 e8 10             	shr    $0x10,%eax
801067fa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801067fe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106801:	0f 01 10             	lgdtl  (%eax)
}
80106804:	c9                   	leave  
80106805:	c3                   	ret    
80106806:	8d 76 00             	lea    0x0(%esi),%esi
80106809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106810 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	57                   	push   %edi
80106814:	56                   	push   %esi
80106815:	53                   	push   %ebx
80106816:	83 ec 1c             	sub    $0x1c,%esp
80106819:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010681c:	8b 55 10             	mov    0x10(%ebp),%edx
8010681f:	8b 7d 14             	mov    0x14(%ebp),%edi
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106822:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106824:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106828:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010682e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106833:	29 df                	sub    %ebx,%edi
80106835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106838:	8b 45 18             	mov    0x18(%ebp),%eax
8010683b:	83 c8 01             	or     $0x1,%eax
8010683e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106841:	eb 1a                	jmp    8010685d <mappages+0x4d>
80106843:	90                   	nop
80106844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106848:	f6 00 01             	testb  $0x1,(%eax)
8010684b:	75 3d                	jne    8010688a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
8010684d:	0b 75 e0             	or     -0x20(%ebp),%esi
    if(a == last)
80106850:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106853:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106855:	74 29                	je     80106880 <mappages+0x70>
      break;
    a += PGSIZE;
80106857:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010685d:	8b 45 08             	mov    0x8(%ebp),%eax
80106860:	b9 01 00 00 00       	mov    $0x1,%ecx
80106865:	89 da                	mov    %ebx,%edx
80106867:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
8010686a:	e8 81 fd ff ff       	call   801065f0 <walkpgdir>
8010686f:	85 c0                	test   %eax,%eax
80106871:	75 d5                	jne    80106848 <mappages+0x38>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106873:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106876:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010687b:	5b                   	pop    %ebx
8010687c:	5e                   	pop    %esi
8010687d:	5f                   	pop    %edi
8010687e:	5d                   	pop    %ebp
8010687f:	c3                   	ret    
80106880:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106883:	31 c0                	xor    %eax,%eax
}
80106885:	5b                   	pop    %ebx
80106886:	5e                   	pop    %esi
80106887:	5f                   	pop    %edi
80106888:	5d                   	pop    %ebp
80106889:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010688a:	83 ec 0c             	sub    $0xc,%esp
8010688d:	68 98 79 10 80       	push   $0x80107998
80106892:	e8 d9 9a ff ff       	call   80100370 <panic>
80106897:	89 f6                	mov    %esi,%esi
80106899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068a0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068a0:	a1 a4 55 11 80       	mov    0x801155a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801068a5:	55                   	push   %ebp
801068a6:	89 e5                	mov    %esp,%ebp
801068a8:	05 00 00 00 80       	add    $0x80000000,%eax
801068ad:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801068b0:	5d                   	pop    %ebp
801068b1:	c3                   	ret    
801068b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068c0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801068c0:	55                   	push   %ebp
801068c1:	89 e5                	mov    %esp,%ebp
801068c3:	57                   	push   %edi
801068c4:	56                   	push   %esi
801068c5:	53                   	push   %ebx
801068c6:	83 ec 1c             	sub    $0x1c,%esp
801068c9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801068cc:	85 f6                	test   %esi,%esi
801068ce:	0f 84 cd 00 00 00    	je     801069a1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801068d4:	8b 46 0c             	mov    0xc(%esi),%eax
801068d7:	85 c0                	test   %eax,%eax
801068d9:	0f 84 dc 00 00 00    	je     801069bb <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801068df:	8b 7e 08             	mov    0x8(%esi),%edi
801068e2:	85 ff                	test   %edi,%edi
801068e4:	0f 84 c4 00 00 00    	je     801069ae <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
801068ea:	e8 51 d9 ff ff       	call   80104240 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801068ef:	e8 cc cd ff ff       	call   801036c0 <mycpu>
801068f4:	89 c3                	mov    %eax,%ebx
801068f6:	e8 c5 cd ff ff       	call   801036c0 <mycpu>
801068fb:	89 c7                	mov    %eax,%edi
801068fd:	e8 be cd ff ff       	call   801036c0 <mycpu>
80106902:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106905:	83 c7 08             	add    $0x8,%edi
80106908:	e8 b3 cd ff ff       	call   801036c0 <mycpu>
8010690d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106910:	83 c0 08             	add    $0x8,%eax
80106913:	ba 67 00 00 00       	mov    $0x67,%edx
80106918:	c1 e8 18             	shr    $0x18,%eax
8010691b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106922:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106929:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106930:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106937:	83 c1 08             	add    $0x8,%ecx
8010693a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106940:	c1 e9 10             	shr    $0x10,%ecx
80106943:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106949:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010694e:	e8 6d cd ff ff       	call   801036c0 <mycpu>
80106953:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010695a:	e8 61 cd ff ff       	call   801036c0 <mycpu>
8010695f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106964:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106968:	e8 53 cd ff ff       	call   801036c0 <mycpu>
8010696d:	8b 56 0c             	mov    0xc(%esi),%edx
80106970:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106976:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106979:	e8 42 cd ff ff       	call   801036c0 <mycpu>
8010697e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106982:	b8 28 00 00 00       	mov    $0x28,%eax
80106987:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010698a:	8b 46 08             	mov    0x8(%esi),%eax
8010698d:	05 00 00 00 80       	add    $0x80000000,%eax
80106992:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106995:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106998:	5b                   	pop    %ebx
80106999:	5e                   	pop    %esi
8010699a:	5f                   	pop    %edi
8010699b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010699c:	e9 8f d9 ff ff       	jmp    80104330 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801069a1:	83 ec 0c             	sub    $0xc,%esp
801069a4:	68 9e 79 10 80       	push   $0x8010799e
801069a9:	e8 c2 99 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801069ae:	83 ec 0c             	sub    $0xc,%esp
801069b1:	68 c9 79 10 80       	push   $0x801079c9
801069b6:	e8 b5 99 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801069bb:	83 ec 0c             	sub    $0xc,%esp
801069be:	68 b4 79 10 80       	push   $0x801079b4
801069c3:	e8 a8 99 ff ff       	call   80100370 <panic>
801069c8:	90                   	nop
801069c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069d0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	57                   	push   %edi
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
801069d6:	83 ec 1c             	sub    $0x1c,%esp
801069d9:	8b 75 10             	mov    0x10(%ebp),%esi
801069dc:	8b 55 08             	mov    0x8(%ebp),%edx
801069df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801069e2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801069e8:	77 50                	ja     80106a3a <inituvm+0x6a>
801069ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    panic("inituvm: more than a page");
  mem = kalloc();
801069ed:	e8 7e ba ff ff       	call   80102470 <kalloc>
  memset(mem, 0, PGSIZE);
801069f2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801069f5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801069f7:	68 00 10 00 00       	push   $0x1000
801069fc:	6a 00                	push   $0x0
801069fe:	50                   	push   %eax
801069ff:	e8 ec d9 ff ff       	call   801043f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106a07:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a0d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106a14:	50                   	push   %eax
80106a15:	68 00 10 00 00       	push   $0x1000
80106a1a:	6a 00                	push   $0x0
80106a1c:	52                   	push   %edx
80106a1d:	e8 ee fd ff ff       	call   80106810 <mappages>
  memmove(mem, init, sz);
80106a22:	89 75 10             	mov    %esi,0x10(%ebp)
80106a25:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a28:	83 c4 20             	add    $0x20,%esp
80106a2b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a31:	5b                   	pop    %ebx
80106a32:	5e                   	pop    %esi
80106a33:	5f                   	pop    %edi
80106a34:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106a35:	e9 66 da ff ff       	jmp    801044a0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106a3a:	83 ec 0c             	sub    $0xc,%esp
80106a3d:	68 dd 79 10 80       	push   $0x801079dd
80106a42:	e8 29 99 ff ff       	call   80100370 <panic>
80106a47:	89 f6                	mov    %esi,%esi
80106a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a50 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
80106a56:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106a59:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106a60:	0f 85 91 00 00 00    	jne    80106af7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106a66:	8b 75 18             	mov    0x18(%ebp),%esi
80106a69:	31 db                	xor    %ebx,%ebx
80106a6b:	85 f6                	test   %esi,%esi
80106a6d:	75 1a                	jne    80106a89 <loaduvm+0x39>
80106a6f:	eb 6f                	jmp    80106ae0 <loaduvm+0x90>
80106a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a78:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a7e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106a84:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106a87:	76 57                	jbe    80106ae0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106a89:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a8f:	31 c9                	xor    %ecx,%ecx
80106a91:	01 da                	add    %ebx,%edx
80106a93:	e8 58 fb ff ff       	call   801065f0 <walkpgdir>
80106a98:	85 c0                	test   %eax,%eax
80106a9a:	74 4e                	je     80106aea <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106a9c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106a9e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106aa1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106aa6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106aab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ab1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ab4:	01 d9                	add    %ebx,%ecx
80106ab6:	05 00 00 00 80       	add    $0x80000000,%eax
80106abb:	57                   	push   %edi
80106abc:	51                   	push   %ecx
80106abd:	50                   	push   %eax
80106abe:	ff 75 10             	pushl  0x10(%ebp)
80106ac1:	e8 6a ae ff ff       	call   80101930 <readi>
80106ac6:	83 c4 10             	add    $0x10,%esp
80106ac9:	39 c7                	cmp    %eax,%edi
80106acb:	74 ab                	je     80106a78 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106acd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106ad5:	5b                   	pop    %ebx
80106ad6:	5e                   	pop    %esi
80106ad7:	5f                   	pop    %edi
80106ad8:	5d                   	pop    %ebp
80106ad9:	c3                   	ret    
80106ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106ae3:	31 c0                	xor    %eax,%eax
}
80106ae5:	5b                   	pop    %ebx
80106ae6:	5e                   	pop    %esi
80106ae7:	5f                   	pop    %edi
80106ae8:	5d                   	pop    %ebp
80106ae9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106aea:	83 ec 0c             	sub    $0xc,%esp
80106aed:	68 f7 79 10 80       	push   $0x801079f7
80106af2:	e8 79 98 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106af7:	83 ec 0c             	sub    $0xc,%esp
80106afa:	68 98 7a 10 80       	push   $0x80107a98
80106aff:	e8 6c 98 ff ff       	call   80100370 <panic>
80106b04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b10 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	57                   	push   %edi
80106b14:	56                   	push   %esi
80106b15:	53                   	push   %ebx
80106b16:	83 ec 0c             	sub    $0xc,%esp
80106b19:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106b1c:	85 ff                	test   %edi,%edi
80106b1e:	0f 88 ca 00 00 00    	js     80106bee <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106b24:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106b2a:	0f 82 84 00 00 00    	jb     80106bb4 <allocuvm+0xa4>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106b30:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b36:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b3c:	39 df                	cmp    %ebx,%edi
80106b3e:	77 45                	ja     80106b85 <allocuvm+0x75>
80106b40:	e9 bb 00 00 00       	jmp    80106c00 <allocuvm+0xf0>
80106b45:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106b48:	83 ec 04             	sub    $0x4,%esp
80106b4b:	68 00 10 00 00       	push   $0x1000
80106b50:	6a 00                	push   $0x0
80106b52:	50                   	push   %eax
80106b53:	e8 98 d8 ff ff       	call   801043f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106b58:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b5e:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106b65:	50                   	push   %eax
80106b66:	68 00 10 00 00       	push   $0x1000
80106b6b:	53                   	push   %ebx
80106b6c:	ff 75 08             	pushl  0x8(%ebp)
80106b6f:	e8 9c fc ff ff       	call   80106810 <mappages>
80106b74:	83 c4 20             	add    $0x20,%esp
80106b77:	85 c0                	test   %eax,%eax
80106b79:	78 45                	js     80106bc0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106b7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b81:	39 df                	cmp    %ebx,%edi
80106b83:	76 7b                	jbe    80106c00 <allocuvm+0xf0>
    mem = kalloc();
80106b85:	e8 e6 b8 ff ff       	call   80102470 <kalloc>
    if(mem == 0){
80106b8a:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106b8c:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106b8e:	75 b8                	jne    80106b48 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106b90:	83 ec 0c             	sub    $0xc,%esp
80106b93:	68 15 7a 10 80       	push   $0x80107a15
80106b98:	e8 c3 9a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b9d:	83 c4 10             	add    $0x10,%esp
80106ba0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ba3:	76 49                	jbe    80106bee <allocuvm+0xde>
80106ba5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ba8:	8b 45 08             	mov    0x8(%ebp),%eax
80106bab:	89 fa                	mov    %edi,%edx
80106bad:	e8 be fa ff ff       	call   80106670 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106bb2:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106bb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bb7:	5b                   	pop    %ebx
80106bb8:	5e                   	pop    %esi
80106bb9:	5f                   	pop    %edi
80106bba:	5d                   	pop    %ebp
80106bbb:	c3                   	ret    
80106bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106bc0:	83 ec 0c             	sub    $0xc,%esp
80106bc3:	68 2d 7a 10 80       	push   $0x80107a2d
80106bc8:	e8 93 9a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106bcd:	83 c4 10             	add    $0x10,%esp
80106bd0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bd3:	76 0d                	jbe    80106be2 <allocuvm+0xd2>
80106bd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80106bdb:	89 fa                	mov    %edi,%edx
80106bdd:	e8 8e fa ff ff       	call   80106670 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106be2:	83 ec 0c             	sub    $0xc,%esp
80106be5:	56                   	push   %esi
80106be6:	e8 d5 b6 ff ff       	call   801022c0 <kfree>
      return 0;
80106beb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106bee:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106bf1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106bf3:	5b                   	pop    %ebx
80106bf4:	5e                   	pop    %esi
80106bf5:	5f                   	pop    %edi
80106bf6:	5d                   	pop    %ebp
80106bf7:	c3                   	ret    
80106bf8:	90                   	nop
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106c03:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106c05:	5b                   	pop    %ebx
80106c06:	5e                   	pop    %esi
80106c07:	5f                   	pop    %edi
80106c08:	5d                   	pop    %ebp
80106c09:	c3                   	ret    
80106c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c10 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c19:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c1c:	39 d1                	cmp    %edx,%ecx
80106c1e:	73 10                	jae    80106c30 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c20:	5d                   	pop    %ebp
80106c21:	e9 4a fa ff ff       	jmp    80106670 <deallocuvm.part.0>
80106c26:	8d 76 00             	lea    0x0(%esi),%esi
80106c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c30:	89 d0                	mov    %edx,%eax
80106c32:	5d                   	pop    %ebp
80106c33:	c3                   	ret    
80106c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
80106c46:	83 ec 0c             	sub    $0xc,%esp
80106c49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106c4c:	85 f6                	test   %esi,%esi
80106c4e:	74 59                	je     80106ca9 <freevm+0x69>
80106c50:	31 c9                	xor    %ecx,%ecx
80106c52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106c57:	89 f0                	mov    %esi,%eax
80106c59:	e8 12 fa ff ff       	call   80106670 <deallocuvm.part.0>
80106c5e:	89 f3                	mov    %esi,%ebx
80106c60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106c66:	eb 0f                	jmp    80106c77 <freevm+0x37>
80106c68:	90                   	nop
80106c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c70:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c73:	39 fb                	cmp    %edi,%ebx
80106c75:	74 23                	je     80106c9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106c77:	8b 03                	mov    (%ebx),%eax
80106c79:	a8 01                	test   $0x1,%al
80106c7b:	74 f3                	je     80106c70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106c7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c82:	83 ec 0c             	sub    $0xc,%esp
80106c85:	83 c3 04             	add    $0x4,%ebx
80106c88:	05 00 00 00 80       	add    $0x80000000,%eax
80106c8d:	50                   	push   %eax
80106c8e:	e8 2d b6 ff ff       	call   801022c0 <kfree>
80106c93:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c96:	39 fb                	cmp    %edi,%ebx
80106c98:	75 dd                	jne    80106c77 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106c9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106c9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ca0:	5b                   	pop    %ebx
80106ca1:	5e                   	pop    %esi
80106ca2:	5f                   	pop    %edi
80106ca3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106ca4:	e9 17 b6 ff ff       	jmp    801022c0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106ca9:	83 ec 0c             	sub    $0xc,%esp
80106cac:	68 49 7a 10 80       	push   $0x80107a49
80106cb1:	e8 ba 96 ff ff       	call   80100370 <panic>
80106cb6:	8d 76 00             	lea    0x0(%esi),%esi
80106cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cc0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	56                   	push   %esi
80106cc4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106cc5:	e8 a6 b7 ff ff       	call   80102470 <kalloc>
80106cca:	85 c0                	test   %eax,%eax
80106ccc:	74 6a                	je     80106d38 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106cce:	83 ec 04             	sub    $0x4,%esp
80106cd1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106cd3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106cd8:	68 00 10 00 00       	push   $0x1000
80106cdd:	6a 00                	push   $0x0
80106cdf:	50                   	push   %eax
80106ce0:	e8 0b d7 ff ff       	call   801043f0 <memset>
80106ce5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ce8:	8b 43 04             	mov    0x4(%ebx),%eax
80106ceb:	8b 53 08             	mov    0x8(%ebx),%edx
80106cee:	83 ec 0c             	sub    $0xc,%esp
80106cf1:	ff 73 0c             	pushl  0xc(%ebx)
80106cf4:	29 c2                	sub    %eax,%edx
80106cf6:	50                   	push   %eax
80106cf7:	52                   	push   %edx
80106cf8:	ff 33                	pushl  (%ebx)
80106cfa:	56                   	push   %esi
80106cfb:	e8 10 fb ff ff       	call   80106810 <mappages>
80106d00:	83 c4 20             	add    $0x20,%esp
80106d03:	85 c0                	test   %eax,%eax
80106d05:	78 19                	js     80106d20 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d07:	83 c3 10             	add    $0x10,%ebx
80106d0a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d10:	75 d6                	jne    80106ce8 <setupkvm+0x28>
80106d12:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106d14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d17:	5b                   	pop    %ebx
80106d18:	5e                   	pop    %esi
80106d19:	5d                   	pop    %ebp
80106d1a:	c3                   	ret    
80106d1b:	90                   	nop
80106d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106d20:	83 ec 0c             	sub    $0xc,%esp
80106d23:	56                   	push   %esi
80106d24:	e8 17 ff ff ff       	call   80106c40 <freevm>
      return 0;
80106d29:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106d2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106d2f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106d31:	5b                   	pop    %ebx
80106d32:	5e                   	pop    %esi
80106d33:	5d                   	pop    %ebp
80106d34:	c3                   	ret    
80106d35:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106d38:	31 c0                	xor    %eax,%eax
80106d3a:	eb d8                	jmp    80106d14 <setupkvm+0x54>
80106d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d40 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106d46:	e8 75 ff ff ff       	call   80106cc0 <setupkvm>
80106d4b:	a3 a4 55 11 80       	mov    %eax,0x801155a4
80106d50:	05 00 00 00 80       	add    $0x80000000,%eax
80106d55:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106d58:	c9                   	leave  
80106d59:	c3                   	ret    
80106d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106d60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d61:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106d63:	89 e5                	mov    %esp,%ebp
80106d65:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d6e:	e8 7d f8 ff ff       	call   801065f0 <walkpgdir>
  if(pte == 0)
80106d73:	85 c0                	test   %eax,%eax
80106d75:	74 05                	je     80106d7c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106d77:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106d7a:	c9                   	leave  
80106d7b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106d7c:	83 ec 0c             	sub    $0xc,%esp
80106d7f:	68 5a 7a 10 80       	push   $0x80107a5a
80106d84:	e8 e7 95 ff ff       	call   80100370 <panic>
80106d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d90 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	53                   	push   %ebx
80106d96:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106d99:	e8 22 ff ff ff       	call   80106cc0 <setupkvm>
80106d9e:	85 c0                	test   %eax,%eax
80106da0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106da3:	0f 84 55 01 00 00    	je     80106efe <copyuvm+0x16e>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106da9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dac:	85 c9                	test   %ecx,%ecx
80106dae:	0f 84 a4 00 00 00    	je     80106e58 <copyuvm+0xc8>
80106db4:	31 f6                	xor    %esi,%esi
80106db6:	eb 48                	jmp    80106e00 <copyuvm+0x70>
80106db8:	90                   	nop
80106db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106dc0:	83 ec 04             	sub    $0x4,%esp
80106dc3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106dc9:	68 00 10 00 00       	push   $0x1000
80106dce:	57                   	push   %edi
80106dcf:	50                   	push   %eax
80106dd0:	e8 cb d6 ff ff       	call   801044a0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106dd5:	5a                   	pop    %edx
80106dd6:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106ddc:	ff 75 e4             	pushl  -0x1c(%ebp)
80106ddf:	52                   	push   %edx
80106de0:	68 00 10 00 00       	push   $0x1000
80106de5:	56                   	push   %esi
80106de6:	ff 75 e0             	pushl  -0x20(%ebp)
80106de9:	e8 22 fa ff ff       	call   80106810 <mappages>
80106dee:	83 c4 20             	add    $0x20,%esp
80106df1:	85 c0                	test   %eax,%eax
80106df3:	78 46                	js     80106e3b <copyuvm+0xab>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106df5:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106dfb:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106dfe:	76 58                	jbe    80106e58 <copyuvm+0xc8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e00:	8b 45 08             	mov    0x8(%ebp),%eax
80106e03:	31 c9                	xor    %ecx,%ecx
80106e05:	89 f2                	mov    %esi,%edx
80106e07:	e8 e4 f7 ff ff       	call   801065f0 <walkpgdir>
80106e0c:	85 c0                	test   %eax,%eax
80106e0e:	0f 84 fe 00 00 00    	je     80106f12 <copyuvm+0x182>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106e14:	8b 18                	mov    (%eax),%ebx
80106e16:	f6 c3 01             	test   $0x1,%bl
80106e19:	0f 84 e6 00 00 00    	je     80106f05 <copyuvm+0x175>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e1f:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106e21:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106e27:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e2a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106e30:	e8 3b b6 ff ff       	call   80102470 <kalloc>
80106e35:	85 c0                	test   %eax,%eax
80106e37:	89 c3                	mov    %eax,%ebx
80106e39:	75 85                	jne    80106dc0 <copyuvm+0x30>
  }

  return d;

bad:
  freevm(d);
80106e3b:	83 ec 0c             	sub    $0xc,%esp
80106e3e:	ff 75 e0             	pushl  -0x20(%ebp)
80106e41:	e8 fa fd ff ff       	call   80106c40 <freevm>
  return 0;
80106e46:	83 c4 10             	add    $0x10,%esp
80106e49:	31 c0                	xor    %eax,%eax
}
80106e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e4e:	5b                   	pop    %ebx
80106e4f:	5e                   	pop    %esi
80106e50:	5f                   	pop    %edi
80106e51:	5d                   	pop    %ebp
80106e52:	c3                   	ret    
80106e53:	90                   	nop
80106e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }

  //cs153_lab3: for loop used to copy the all the pages allocated to the user stack
  for (i = KERNBASE - (myproc()->userStack_numPages * PGSIZE); i < KERNBASE - 4; i += PGSIZE)
80106e58:	e8 03 c9 ff ff       	call   80103760 <myproc>
80106e5d:	8b 70 04             	mov    0x4(%eax),%esi
80106e60:	f7 de                	neg    %esi
80106e62:	c1 e6 0c             	shl    $0xc,%esi
80106e65:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106e6b:	81 fe fb ff ff 7f    	cmp    $0x7ffffffb,%esi
80106e71:	76 48                	jbe    80106ebb <copyuvm+0x12b>
80106e73:	eb 7e                	jmp    80106ef3 <copyuvm+0x163>
80106e75:	8d 76 00             	lea    0x0(%esi),%esi
    flags = PTE_FLAGS(*pte);

    if (!(mem = kalloc()))
      goto bad;

    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e78:	83 ec 04             	sub    $0x4,%esp
80106e7b:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106e81:	68 00 10 00 00       	push   $0x1000
80106e86:	57                   	push   %edi
80106e87:	50                   	push   %eax
80106e88:	e8 13 d6 ff ff       	call   801044a0 <memmove>

    if (mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e8d:	58                   	pop    %eax
80106e8e:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106e94:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e97:	52                   	push   %edx
80106e98:	68 00 10 00 00       	push   $0x1000
80106e9d:	56                   	push   %esi
80106e9e:	ff 75 e0             	pushl  -0x20(%ebp)
80106ea1:	e8 6a f9 ff ff       	call   80106810 <mappages>
80106ea6:	83 c4 20             	add    $0x20,%esp
80106ea9:	85 c0                	test   %eax,%eax
80106eab:	78 8e                	js     80106e3b <copyuvm+0xab>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }

  //cs153_lab3: for loop used to copy the all the pages allocated to the user stack
  for (i = KERNBASE - (myproc()->userStack_numPages * PGSIZE); i < KERNBASE - 4; i += PGSIZE)
80106ead:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106eb3:	81 fe fb ff ff 7f    	cmp    $0x7ffffffb,%esi
80106eb9:	77 38                	ja     80106ef3 <copyuvm+0x163>
  {
    if (!(pte = walkpgdir(pgdir, (void *) i, 0)))
80106ebb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ebe:	31 c9                	xor    %ecx,%ecx
80106ec0:	89 f2                	mov    %esi,%edx
80106ec2:	e8 29 f7 ff ff       	call   801065f0 <walkpgdir>
80106ec7:	85 c0                	test   %eax,%eax
80106ec9:	74 47                	je     80106f12 <copyuvm+0x182>
      panic("copyuvm: pte should exist");

    if (!(*pte & PTE_P))
80106ecb:	8b 18                	mov    (%eax),%ebx
80106ecd:	f6 c3 01             	test   $0x1,%bl
80106ed0:	74 33                	je     80106f05 <copyuvm+0x175>
      panic("copyuvm: page not present");

    pa = PTE_ADDR(*pte);
80106ed2:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106ed4:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106eda:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
      panic("copyuvm: pte should exist");

    if (!(*pte & PTE_P))
      panic("copyuvm: page not present");

    pa = PTE_ADDR(*pte);
80106edd:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);

    if (!(mem = kalloc()))
80106ee3:	e8 88 b5 ff ff       	call   80102470 <kalloc>
80106ee8:	85 c0                	test   %eax,%eax
80106eea:	89 c3                	mov    %eax,%ebx
80106eec:	75 8a                	jne    80106e78 <copyuvm+0xe8>
80106eee:	e9 48 ff ff ff       	jmp    80106e3b <copyuvm+0xab>
80106ef3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106ef6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ef9:	5b                   	pop    %ebx
80106efa:	5e                   	pop    %esi
80106efb:	5f                   	pop    %edi
80106efc:	5d                   	pop    %ebp
80106efd:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106efe:	31 c0                	xor    %eax,%eax
80106f00:	e9 46 ff ff ff       	jmp    80106e4b <copyuvm+0xbb>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106f05:	83 ec 0c             	sub    $0xc,%esp
80106f08:	68 7e 7a 10 80       	push   $0x80107a7e
80106f0d:	e8 5e 94 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106f12:	83 ec 0c             	sub    $0xc,%esp
80106f15:	68 64 7a 10 80       	push   $0x80107a64
80106f1a:	e8 51 94 ff ff       	call   80100370 <panic>
80106f1f:	90                   	nop

80106f20 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f21:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f23:	89 e5                	mov    %esp,%ebp
80106f25:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f28:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f2e:	e8 bd f6 ff ff       	call   801065f0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f33:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106f35:	89 c2                	mov    %eax,%edx
80106f37:	83 e2 05             	and    $0x5,%edx
80106f3a:	83 fa 05             	cmp    $0x5,%edx
80106f3d:	75 11                	jne    80106f50 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106f44:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f45:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106f4a:	c3                   	ret    
80106f4b:	90                   	nop
80106f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106f50:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f52:	c9                   	leave  
80106f53:	c3                   	ret    
80106f54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f60 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
80106f69:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f72:	85 db                	test   %ebx,%ebx
80106f74:	75 40                	jne    80106fb6 <copyout+0x56>
80106f76:	eb 70                	jmp    80106fe8 <copyout+0x88>
80106f78:	90                   	nop
80106f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f83:	89 f1                	mov    %esi,%ecx
80106f85:	29 d1                	sub    %edx,%ecx
80106f87:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106f8d:	39 d9                	cmp    %ebx,%ecx
80106f8f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f92:	29 f2                	sub    %esi,%edx
80106f94:	83 ec 04             	sub    $0x4,%esp
80106f97:	01 d0                	add    %edx,%eax
80106f99:	51                   	push   %ecx
80106f9a:	57                   	push   %edi
80106f9b:	50                   	push   %eax
80106f9c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f9f:	e8 fc d4 ff ff       	call   801044a0 <memmove>
    len -= n;
    buf += n;
80106fa4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fa7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106faa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106fb0:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fb2:	29 cb                	sub    %ecx,%ebx
80106fb4:	74 32                	je     80106fe8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106fb6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106fb8:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106fbb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106fbe:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106fc4:	56                   	push   %esi
80106fc5:	ff 75 08             	pushl  0x8(%ebp)
80106fc8:	e8 53 ff ff ff       	call   80106f20 <uva2ka>
    if(pa0 == 0)
80106fcd:	83 c4 10             	add    $0x10,%esp
80106fd0:	85 c0                	test   %eax,%eax
80106fd2:	75 ac                	jne    80106f80 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106fd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106fdc:	5b                   	pop    %ebx
80106fdd:	5e                   	pop    %esi
80106fde:	5f                   	pop    %edi
80106fdf:	5d                   	pop    %ebp
80106fe0:	c3                   	ret    
80106fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106feb:	31 c0                	xor    %eax,%eax
}
80106fed:	5b                   	pop    %ebx
80106fee:	5e                   	pop    %esi
80106fef:	5f                   	pop    %edi
80106ff0:	5d                   	pop    %ebp
80106ff1:	c3                   	ret    
80106ff2:	66 90                	xchg   %ax,%ax
80106ff4:	66 90                	xchg   %ax,%ax
80106ff6:	66 90                	xchg   %ax,%ax
80106ff8:	66 90                	xchg   %ax,%ax
80106ffa:	66 90                	xchg   %ax,%ax
80106ffc:	66 90                	xchg   %ax,%ax
80106ffe:	66 90                	xchg   %ax,%ax

80107000 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	83 ec 10             	sub    $0x10,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80107006:	68 bc 7a 10 80       	push   $0x80107abc
8010700b:	68 c0 55 11 80       	push   $0x801155c0
80107010:	e8 6b d1 ff ff       	call   80104180 <initlock>
  acquire(&(shm_table.lock));
80107015:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
8010701c:	e8 5f d2 ff ff       	call   80104280 <acquire>
80107021:	b8 f4 55 11 80       	mov    $0x801155f4,%eax
80107026:	83 c4 10             	add    $0x10,%esp
80107029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80107030:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    shm_table.shm_pages[i].frame =0;
80107036:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
8010703d:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].refcnt =0;
80107040:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
80107047:	3d f4 58 11 80       	cmp    $0x801158f4,%eax
8010704c:	75 e2                	jne    80107030 <shminit+0x30>
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
8010704e:	83 ec 0c             	sub    $0xc,%esp
80107051:	68 c0 55 11 80       	push   $0x801155c0
80107056:	e8 45 d3 ff ff       	call   801043a0 <release>
}
8010705b:	83 c4 10             	add    $0x10,%esp
8010705e:	c9                   	leave  
8010705f:	c3                   	ret    

80107060 <shm_open>:

int shm_open(int id, char **pointer) {
80107060:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80107061:	31 c0                	xor    %eax,%eax
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}

int shm_open(int id, char **pointer) {
80107063:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80107065:	5d                   	pop    %ebp
80107066:	c3                   	ret    
80107067:	89 f6                	mov    %esi,%esi
80107069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107070 <shm_close>:


int shm_close(int id) {
80107070:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80107071:	31 c0                	xor    %eax,%eax

return 0; //added to remove compiler warning -- you should decide what to return
}


int shm_close(int id) {
80107073:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80107075:	5d                   	pop    %ebp
80107076:	c3                   	ret    
