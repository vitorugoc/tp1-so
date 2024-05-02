
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
80100028:	bc 30 6d 11 80       	mov    $0x80116d30,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 30 10 80       	mov    $0x80103030,%eax
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
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 79 10 80       	push   $0x801079e0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 55 4b 00 00       	call   80104bb0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 79 10 80       	push   $0x801079e7
80100097:	50                   	push   %eax
80100098:	e8 e3 49 00 00       	call   80104a80 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 97 4c 00 00       	call   80104d80 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
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
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 b9 4b 00 00       	call   80104d20 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 49 00 00       	call   80104ac0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ee 79 10 80       	push   $0x801079ee
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 9d 49 00 00       	call   80104b60 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 79 10 80       	push   $0x801079ff
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 49 00 00       	call   80104b60 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 0c 49 00 00       	call   80104b20 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 60 4b 00 00       	call   80104d80 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 af 4a 00 00       	jmp    80104d20 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 7a 10 80       	push   $0x80107a06
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 db 4a 00 00       	call   80104d80 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 1e 45 00 00       	call   801047f0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 79 3a 00 00       	call   80103d60 <myproc>
801002e7:	8b 48 28             	mov    0x28(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 25 4a 00 00       	call   80104d20 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 cf 49 00 00       	call   80104d20 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 42 25 00 00       	call   801028e0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 7a 10 80       	push   $0x80107a0d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 57 83 10 80 	movl   $0x80108357,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 03 48 00 00       	call   80104bd0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 7a 10 80       	push   $0x80107a21
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 d1 60 00 00       	call   801064f0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 e6 5f 00 00       	call   801064f0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 da 5f 00 00       	call   801064f0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 ce 5f 00 00       	call   801064f0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 8a 49 00 00       	call   80104ee0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 d5 48 00 00       	call   80104e40 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 25 7a 10 80       	push   $0x80107a25
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 d0 47 00 00       	call   80104d80 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 37 47 00 00       	call   80104d20 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 50 7a 10 80 	movzbl -0x7fef85b0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 93 45 00 00       	call   80104d80 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 38 7a 10 80       	mov    $0x80107a38,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 c0 44 00 00       	call   80104d20 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 3f 7a 10 80       	push   $0x80107a3f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 e8 44 00 00       	call   80104d80 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 4b 43 00 00       	call   80104d20 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 7d 3f 00 00       	jmp    80104990 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 67 3e 00 00       	call   801048b0 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 48 7a 10 80       	push   $0x80107a48
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 3b 41 00 00       	call   80104bb0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 9f 32 00 00       	call   80103d60 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 74 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 9c 22 00 00       	call   80102db0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 47 6b 00 00       	call   80107680 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 f8 68 00 00       	call   801074a0 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 d2 67 00 00       	call   801073b0 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 e0 69 00 00       	call   80107600 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 5a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 39 68 00 00       	call   801074a0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 98 6a 00 00       	call   80107720 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 68 43 00 00       	call   80105040 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 54 43 00 00       	call   80105040 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 f3 6b 00 00       	call   801078f0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 ea 68 00 00       	call   80107600 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 88 6b 00 00       	call   801078f0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 70             	add    $0x70,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 5a 42 00 00       	call   80105000 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 08             	mov    0x8(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 08             	mov    %ecx,0x8(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 1c             	mov    0x1c(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 1c             	mov    0x1c(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 4e 64 00 00       	call   80107220 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 26 68 00 00       	call   80107600 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 c7 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 61 7a 10 80       	push   $0x80107a61
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 6d 7a 10 80       	push   $0x80107a6d
80100e1b:	68 60 ff 10 80       	push   $0x8010ff60
80100e20:	e8 8b 3d 00 00       	call   80104bb0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 60 ff 10 80       	push   $0x8010ff60
80100e41:	e8 3a 3f 00 00       	call   80104d80 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 60 ff 10 80       	push   $0x8010ff60
80100e71:	e8 aa 3e 00 00       	call   80104d20 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 60 ff 10 80       	push   $0x8010ff60
80100e8a:	e8 91 3e 00 00       	call   80104d20 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 60 ff 10 80       	push   $0x8010ff60
80100eaf:	e8 cc 3e 00 00       	call   80104d80 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 60 ff 10 80       	push   $0x8010ff60
80100ecc:	e8 4f 3e 00 00       	call   80104d20 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 74 7a 10 80       	push   $0x80107a74
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 7a 3e 00 00       	call   80104d80 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 df 3d 00 00       	call   80104d20 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 ad 3d 00 00       	jmp    80104d20 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 c3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 19 1e 00 00       	jmp    80102db0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 52 25 00 00       	call   80103500 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 7c 7a 10 80       	push   $0x80107a7c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 0e 26 00 00       	jmp    801036a0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 86 7a 10 80       	push   $0x80107a86
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 a2 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 0d 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 46 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 8f 7a 10 80       	push   $0x80107a8f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 f2 23 00 00       	jmp    801035a0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 95 7a 10 80       	push   $0x80107a95
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 0e 1d 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 9f 7a 10 80       	push   $0x80107a9f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 b2 7a 10 80       	push   $0x80107ab2
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 1e 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 16 3b 00 00       	call   80104e40 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 ee 1b 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 60 09 11 80       	push   $0x80110960
8010136a:	e8 11 3a 00 00       	call   80104d80 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 60 09 11 80       	push   $0x80110960
801013d7:	e8 44 39 00 00       	call   80104d20 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 16 39 00 00       	call   80104d20 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 c8 7a 10 80       	push   $0x80107ac8
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 56 1a 00 00       	call   80102f20 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 d8 7a 10 80       	push   $0x80107ad8
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 9a 39 00 00       	call   80104ee0 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 eb 7a 10 80       	push   $0x80107aeb
80101571:	68 60 09 11 80       	push   $0x80110960
80101576:	e8 35 36 00 00       	call   80104bb0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 f2 7a 10 80       	push   $0x80107af2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 ec 34 00 00       	call   80104a80 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 b4 25 11 80       	push   $0x801125b4
801015bc:	e8 1f 39 00 00       	call   80104ee0 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 cc 25 11 80    	push   0x801125cc
801015cf:	ff 35 c8 25 11 80    	push   0x801125c8
801015d5:	ff 35 c4 25 11 80    	push   0x801125c4
801015db:	ff 35 c0 25 11 80    	push   0x801125c0
801015e1:	ff 35 bc 25 11 80    	push   0x801125bc
801015e7:	ff 35 b8 25 11 80    	push   0x801125b8
801015ed:	ff 35 b4 25 11 80    	push   0x801125b4
801015f3:	68 58 7b 10 80       	push   $0x80107b58
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 ad 37 00 00       	call   80104e40 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 7b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 f8 7a 10 80       	push   $0x80107af8
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 aa 37 00 00       	call   80104ee0 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 e2 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 60 09 11 80       	push   $0x80110960
8010175f:	e8 1c 36 00 00       	call   80104d80 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010176f:	e8 ac 35 00 00       	call   80104d20 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 19 33 00 00       	call   80104ac0 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 c3 36 00 00       	call   80104ee0 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 10 7b 10 80       	push   $0x80107b10
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 0a 7b 10 80       	push   $0x80107b0a
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 e8 32 00 00       	call   80104b60 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 8c 32 00 00       	jmp    80104b20 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 1f 7b 10 80       	push   $0x80107b1f
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 fb 31 00 00       	call   80104ac0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 41 32 00 00       	call   80104b20 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801018e6:	e8 95 34 00 00       	call   80104d80 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 1b 34 00 00       	jmp    80104d20 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 09 11 80       	push   $0x80110960
80101910:	e8 6b 34 00 00       	call   80104d80 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010191f:	e8 fc 33 00 00       	call   80104d20 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 38 31 00 00       	call   80104b60 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 e1 30 00 00       	call   80104b20 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 1f 7b 10 80       	push   $0x80107b1f
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 a4 33 00 00       	call   80104ee0 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 a8 32 00 00       	call   80104ee0 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 e0 12 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 7d 32 00 00       	call   80104f50 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 1e 32 00 00       	call   80104f50 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 39 7b 10 80       	push   $0x80107b39
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 27 7b 10 80       	push   $0x80107b27
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 b1 1f 00 00       	call   80103d60 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 60 09 11 80       	push   $0x80110960
80101dba:	e8 c1 2f 00 00       	call   80104d80 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dca:	e8 51 2f 00 00       	call   80104d20 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 b4 30 00 00       	call   80104ee0 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 cf 2c 00 00       	call   80104b60 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 6d 2c 00 00       	call   80104b20 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 00 30 00 00       	call   80104ee0 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 30 2c 00 00       	call   80104b60 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 d1 2b 00 00       	call   80104b20 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 ee 2b 00 00       	call   80104b60 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 cb 2b 00 00       	call   80104b60 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 74 2b 00 00       	call   80104b20 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 1f 7b 10 80       	push   $0x80107b1f
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 5e 2f 00 00       	call   80104fa0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 48 7b 10 80       	push   $0x80107b48
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 3e 81 10 80       	push   $0x8010813e
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 b4 7b 10 80       	push   $0x80107bb4
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 ab 7b 10 80       	push   $0x80107bab
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 c6 7b 10 80       	push   $0x80107bc6
801021cb:	68 00 26 11 80       	push   $0x80112600
801021d0:	e8 db 29 00 00       	call   80104bb0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 84 27 11 80       	mov    0x80112784,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 00 26 11 80       	push   $0x80112600
8010224e:	e8 2d 2b 00 00       	call   80104d80 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 fe 25 00 00       	call   801048b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 00 26 11 80       	push   $0x80112600
801022cb:	e8 50 2a 00 00       	call   80104d20 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 6d 28 00 00       	call   80104b60 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 00 26 11 80       	push   $0x80112600
80102328:	e8 53 2a 00 00       	call   80104d80 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 00 26 11 80       	push   $0x80112600
80102368:	53                   	push   %ebx
80102369:	e8 82 24 00 00       	call   801047f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 95 29 00 00       	jmp    80104d20 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 f5 7b 10 80       	push   $0x80107bf5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 e0 7b 10 80       	push   $0x80107be0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 ca 7b 10 80       	push   $0x80107bca
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 14 7c 10 80       	push   $0x80107c14
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb 30 6d 11 80    	cmp    $0x80116d30,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 49 29 00 00       	call   80104e40 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 78 26 11 80       	mov    0x80112678,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102510:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 40 26 11 80       	push   $0x80112640
80102528:	e8 53 28 00 00       	call   80104d80 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 d8 27 00 00       	jmp    80104d20 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 46 7c 10 80       	push   $0x80107c46
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 4c 7c 10 80       	push   $0x80107c4c
80102620:	68 40 26 11 80       	push   $0x80112640
80102625:	e8 86 25 00 00       	call   80104bb0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 74 26 11 80       	mov    0x80112674,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 26 11 80       	push   $0x80112640
801026b3:	e8 c8 26 00 00       	call   80104d80 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801026bd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 26 11 80       	push   $0x80112640
801026e1:	e8 3a 26 00 00       	call   80104d20 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 80 7d 10 80 	movzbl -0x7fef8280(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 80 7c 10 80 	movzbl -0x7fef8380(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 60 7c 10 80 	mov    -0x7fef83a0(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 80 7d 10 80 	movzbl -0x7fef8280(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
801027f0:	a1 80 26 11 80       	mov    0x80112680,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 c3 00 00 00    	je     801028c0 <lapicinit+0xd0>
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
80102807:	8b 50 20             	mov    0x20(%eax),%edx
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
80102814:	8b 50 20             	mov    0x20(%eax),%edx
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
80102821:	8b 50 20             	mov    0x20(%eax),%edx
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
80102848:	8b 50 20             	mov    0x20(%eax),%edx
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102854:	75 72                	jne    801028c8 <lapicinit+0xd8>
80102856:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010285d:	00 00 00 
80102860:	8b 50 20             	mov    0x20(%eax),%edx
80102863:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286a:	00 00 00 
8010286d:	8b 50 20             	mov    0x20(%eax),%edx
80102870:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102877:	00 00 00 
8010287a:	8b 50 20             	mov    0x20(%eax),%edx
8010287d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102884:	00 00 00 
80102887:	8b 50 20             	mov    0x20(%eax),%edx
8010288a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102891:	00 00 00 
80102894:	8b 50 20             	mov    0x20(%eax),%edx
80102897:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010289e:	85 08 00 
801028a1:	8b 50 20             	mov    0x20(%eax),%edx
801028a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028a8:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028ae:	80 e6 10             	and    $0x10,%dh
801028b1:	75 f5                	jne    801028a8 <lapicinit+0xb8>
801028b3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028ba:	00 00 00 
801028bd:	8b 40 20             	mov    0x20(%eax),%eax
801028c0:	c3                   	ret    
801028c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028c8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028cf:	00 01 00 
801028d2:	8b 50 20             	mov    0x20(%eax),%edx
801028d5:	e9 7c ff ff ff       	jmp    80102856 <lapicinit+0x66>
801028da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801028e0 <lapicid>:
801028e0:	a1 80 26 11 80       	mov    0x80112680,%eax
801028e5:	85 c0                	test   %eax,%eax
801028e7:	74 07                	je     801028f0 <lapicid+0x10>
801028e9:	8b 40 20             	mov    0x20(%eax),%eax
801028ec:	c1 e8 18             	shr    $0x18,%eax
801028ef:	c3                   	ret    
801028f0:	31 c0                	xor    %eax,%eax
801028f2:	c3                   	ret    
801028f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028fa:	00 
801028fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102900 <lapiceoi>:
80102900:	a1 80 26 11 80       	mov    0x80112680,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	74 0d                	je     80102916 <lapiceoi+0x16>
80102909:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102910:	00 00 00 
80102913:	8b 40 20             	mov    0x20(%eax),%eax
80102916:	c3                   	ret    
80102917:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010291e:	00 
8010291f:	90                   	nop

80102920 <microdelay>:
80102920:	c3                   	ret    
80102921:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102928:	00 
80102929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102930 <lapicstartap>:
80102930:	55                   	push   %ebp
80102931:	b8 0f 00 00 00       	mov    $0xf,%eax
80102936:	ba 70 00 00 00       	mov    $0x70,%edx
8010293b:	89 e5                	mov    %esp,%ebp
8010293d:	53                   	push   %ebx
8010293e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102941:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102944:	ee                   	out    %al,(%dx)
80102945:	b8 0a 00 00 00       	mov    $0xa,%eax
8010294a:	ba 71 00 00 00       	mov    $0x71,%edx
8010294f:	ee                   	out    %al,(%dx)
80102950:	31 c0                	xor    %eax,%eax
80102952:	c1 e3 18             	shl    $0x18,%ebx
80102955:	66 a3 67 04 00 80    	mov    %ax,0x80000467
8010295b:	89 c8                	mov    %ecx,%eax
8010295d:	c1 e9 0c             	shr    $0xc,%ecx
80102960:	89 da                	mov    %ebx,%edx
80102962:	c1 e8 04             	shr    $0x4,%eax
80102965:	80 cd 06             	or     $0x6,%ch
80102968:	66 a3 69 04 00 80    	mov    %ax,0x80000469
8010296e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102973:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
80102979:	8b 58 20             	mov    0x20(%eax),%ebx
8010297c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102983:	c5 00 00 
80102986:	8b 58 20             	mov    0x20(%eax),%ebx
80102989:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102990:	85 00 00 
80102993:	8b 58 20             	mov    0x20(%eax),%ebx
80102996:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
8010299c:	8b 58 20             	mov    0x20(%eax),%ebx
8010299f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
801029a5:	8b 58 20             	mov    0x20(%eax),%ebx
801029a8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
801029ae:	8b 50 20             	mov    0x20(%eax),%edx
801029b1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
801029b7:	8b 40 20             	mov    0x20(%eax),%eax
801029ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029bd:	c9                   	leave  
801029be:	c3                   	ret    
801029bf:	90                   	nop

801029c0 <cmostime>:
801029c0:	55                   	push   %ebp
801029c1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029c6:	ba 70 00 00 00       	mov    $0x70,%edx
801029cb:	89 e5                	mov    %esp,%ebp
801029cd:	57                   	push   %edi
801029ce:	56                   	push   %esi
801029cf:	53                   	push   %ebx
801029d0:	83 ec 4c             	sub    $0x4c,%esp
801029d3:	ee                   	out    %al,(%dx)
801029d4:	ba 71 00 00 00       	mov    $0x71,%edx
801029d9:	ec                   	in     (%dx),%al
801029da:	83 e0 04             	and    $0x4,%eax
801029dd:	bf 70 00 00 00       	mov    $0x70,%edi
801029e2:	88 45 b2             	mov    %al,-0x4e(%ebp)
801029e5:	8d 76 00             	lea    0x0(%esi),%esi
801029e8:	31 c0                	xor    %eax,%eax
801029ea:	89 fa                	mov    %edi,%edx
801029ec:	ee                   	out    %al,(%dx)
801029ed:	b9 71 00 00 00       	mov    $0x71,%ecx
801029f2:	89 ca                	mov    %ecx,%edx
801029f4:	ec                   	in     (%dx),%al
801029f5:	88 45 b7             	mov    %al,-0x49(%ebp)
801029f8:	89 fa                	mov    %edi,%edx
801029fa:	b8 02 00 00 00       	mov    $0x2,%eax
801029ff:	ee                   	out    %al,(%dx)
80102a00:	89 ca                	mov    %ecx,%edx
80102a02:	ec                   	in     (%dx),%al
80102a03:	88 45 b6             	mov    %al,-0x4a(%ebp)
80102a06:	89 fa                	mov    %edi,%edx
80102a08:	b8 04 00 00 00       	mov    $0x4,%eax
80102a0d:	ee                   	out    %al,(%dx)
80102a0e:	89 ca                	mov    %ecx,%edx
80102a10:	ec                   	in     (%dx),%al
80102a11:	89 c6                	mov    %eax,%esi
80102a13:	89 fa                	mov    %edi,%edx
80102a15:	b8 07 00 00 00       	mov    $0x7,%eax
80102a1a:	ee                   	out    %al,(%dx)
80102a1b:	89 ca                	mov    %ecx,%edx
80102a1d:	ec                   	in     (%dx),%al
80102a1e:	88 45 b5             	mov    %al,-0x4b(%ebp)
80102a21:	89 fa                	mov    %edi,%edx
80102a23:	b8 08 00 00 00       	mov    $0x8,%eax
80102a28:	ee                   	out    %al,(%dx)
80102a29:	89 ca                	mov    %ecx,%edx
80102a2b:	ec                   	in     (%dx),%al
80102a2c:	bb 09 00 00 00       	mov    $0x9,%ebx
80102a31:	88 45 b4             	mov    %al,-0x4c(%ebp)
80102a34:	89 fa                	mov    %edi,%edx
80102a36:	89 d8                	mov    %ebx,%eax
80102a38:	ee                   	out    %al,(%dx)
80102a39:	89 ca                	mov    %ecx,%edx
80102a3b:	ec                   	in     (%dx),%al
80102a3c:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a3f:	89 fa                	mov    %edi,%edx
80102a41:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a46:	ee                   	out    %al,(%dx)
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	84 c0                	test   %al,%al
80102a4c:	78 9a                	js     801029e8 <cmostime+0x28>
80102a4e:	0f b6 55 b7          	movzbl -0x49(%ebp),%edx
80102a52:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a56:	66 0f 6e c2          	movd   %edx,%xmm0
80102a5a:	89 f2                	mov    %esi,%edx
80102a5c:	66 0f 6e d8          	movd   %eax,%xmm3
80102a60:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a64:	0f b6 f2             	movzbl %dl,%esi
80102a67:	0f b6 55 b5          	movzbl -0x4b(%ebp),%edx
80102a6b:	66 0f 62 c3          	punpckldq %xmm3,%xmm0
80102a6f:	66 0f 6e ce          	movd   %esi,%xmm1
80102a73:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102a76:	0f b6 45 b3          	movzbl -0x4d(%ebp),%eax
80102a7a:	66 0f 6e d2          	movd   %edx,%xmm2
80102a7e:	89 fa                	mov    %edi,%edx
80102a80:	66 0f 62 ca          	punpckldq %xmm2,%xmm1
80102a84:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102a87:	31 c0                	xor    %eax,%eax
80102a89:	66 0f 6c c1          	punpcklqdq %xmm1,%xmm0
80102a8d:	0f 29 45 b8          	movaps %xmm0,-0x48(%ebp)
80102a91:	ee                   	out    %al,(%dx)
80102a92:	89 ca                	mov    %ecx,%edx
80102a94:	ec                   	in     (%dx),%al
80102a95:	0f b6 c0             	movzbl %al,%eax
80102a98:	89 fa                	mov    %edi,%edx
80102a9a:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a9d:	b8 02 00 00 00       	mov    $0x2,%eax
80102aa2:	ee                   	out    %al,(%dx)
80102aa3:	89 ca                	mov    %ecx,%edx
80102aa5:	ec                   	in     (%dx),%al
80102aa6:	0f b6 c0             	movzbl %al,%eax
80102aa9:	89 fa                	mov    %edi,%edx
80102aab:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aae:	b8 04 00 00 00       	mov    $0x4,%eax
80102ab3:	ee                   	out    %al,(%dx)
80102ab4:	89 ca                	mov    %ecx,%edx
80102ab6:	ec                   	in     (%dx),%al
80102ab7:	0f b6 c0             	movzbl %al,%eax
80102aba:	89 fa                	mov    %edi,%edx
80102abc:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102abf:	b8 07 00 00 00       	mov    $0x7,%eax
80102ac4:	ee                   	out    %al,(%dx)
80102ac5:	89 ca                	mov    %ecx,%edx
80102ac7:	ec                   	in     (%dx),%al
80102ac8:	0f b6 c0             	movzbl %al,%eax
80102acb:	89 fa                	mov    %edi,%edx
80102acd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ad0:	b8 08 00 00 00       	mov    $0x8,%eax
80102ad5:	ee                   	out    %al,(%dx)
80102ad6:	89 ca                	mov    %ecx,%edx
80102ad8:	ec                   	in     (%dx),%al
80102ad9:	0f b6 c0             	movzbl %al,%eax
80102adc:	89 fa                	mov    %edi,%edx
80102ade:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ae1:	89 d8                	mov    %ebx,%eax
80102ae3:	ee                   	out    %al,(%dx)
80102ae4:	89 ca                	mov    %ecx,%edx
80102ae6:	ec                   	in     (%dx),%al
80102ae7:	0f b6 c0             	movzbl %al,%eax
80102aea:	83 ec 04             	sub    $0x4,%esp
80102aed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102af0:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af3:	6a 18                	push   $0x18
80102af5:	50                   	push   %eax
80102af6:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af9:	50                   	push   %eax
80102afa:	e8 91 23 00 00       	call   80104e90 <memcmp>
80102aff:	83 c4 10             	add    $0x10,%esp
80102b02:	85 c0                	test   %eax,%eax
80102b04:	0f 85 de fe ff ff    	jne    801029e8 <cmostime+0x28>
80102b0a:	0f b6 75 b2          	movzbl -0x4e(%ebp),%esi
80102b0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b11:	89 f0                	mov    %esi,%eax
80102b13:	84 c0                	test   %al,%al
80102b15:	75 59                	jne    80102b70 <cmostime+0x1b0>
80102b17:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b1a:	66 0f 6f 4d b8       	movdqa -0x48(%ebp),%xmm1
80102b1f:	89 c2                	mov    %eax,%edx
80102b21:	66 0f 72 d1 04       	psrld  $0x4,%xmm1
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	66 0f 6f c1          	movdqa %xmm1,%xmm0
80102b30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b33:	66 0f 72 f0 02       	pslld  $0x2,%xmm0
80102b38:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b3b:	66 0f fe c1          	paddd  %xmm1,%xmm0
80102b3f:	66 0f 6f 4d b8       	movdqa -0x48(%ebp),%xmm1
80102b44:	66 0f db 0d 80 7e 10 	pand   0x80107e80,%xmm1
80102b4b:	80 
80102b4c:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102b4f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b52:	66 0f 72 f0 01       	pslld  $0x1,%xmm0
80102b57:	66 0f fe c1          	paddd  %xmm1,%xmm0
80102b5b:	89 c2                	mov    %eax,%edx
80102b5d:	83 e0 0f             	and    $0xf,%eax
80102b60:	0f 29 45 b8          	movaps %xmm0,-0x48(%ebp)
80102b64:	c1 ea 04             	shr    $0x4,%edx
80102b67:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6d:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102b70:	66 0f 6f 65 b8       	movdqa -0x48(%ebp),%xmm4
80102b75:	f3 0f 7e 45 c8       	movq   -0x38(%ebp),%xmm0
80102b7a:	0f 11 23             	movups %xmm4,(%ebx)
80102b7d:	66 0f d6 43 10       	movq   %xmm0,0x10(%ebx)
80102b82:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
80102b89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b8c:	5b                   	pop    %ebx
80102b8d:	5e                   	pop    %esi
80102b8e:	5f                   	pop    %edi
80102b8f:	5d                   	pop    %ebp
80102b90:	c3                   	ret    
80102b91:	66 90                	xchg   %ax,%ax
80102b93:	66 90                	xchg   %ax,%ax
80102b95:	66 90                	xchg   %ax,%ax
80102b97:	66 90                	xchg   %ax,%ax
80102b99:	66 90                	xchg   %ax,%ax
80102b9b:	66 90                	xchg   %ax,%ax
80102b9d:	66 90                	xchg   %ax,%ax
80102b9f:	90                   	nop

80102ba0 <install_trans>:
80102ba0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
80102bb2:	31 ff                	xor    %edi,%edi
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102bc0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 e4 26 11 80    	push   0x801126e4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
80102be4:	ff 35 e4 26 11 80    	push   0x801126e4
80102bea:	83 c7 01             	add    $0x1,%edi
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
80102bf2:	83 c4 0c             	add    $0xc,%esp
80102bf5:	89 c3                	mov    %eax,%ebx
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 d7 22 00 00       	call   80104ee0 <memmove>
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret    
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
80102c47:	ff 35 d4 26 11 80    	push   0x801126d4
80102c4d:	ff 35 e4 26 11 80    	push   0x801126e4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
80102c58:	83 c4 10             	add    $0x10,%esp
80102c5b:	89 c3                	mov    %eax,%ebx
80102c5d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102c70:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave  
80102c9a:	c3                   	ret    
80102c9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102ca0 <initlog>:
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
80102ca4:	83 ec 2c             	sub    $0x2c,%esp
80102ca7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102caa:	68 90 7e 10 80       	push   $0x80107e90
80102caf:	68 a0 26 11 80       	push   $0x801126a0
80102cb4:	e8 f7 1e 00 00       	call   80104bb0 <initlock>
80102cb9:	58                   	pop    %eax
80102cba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cbd:	5a                   	pop    %edx
80102cbe:	50                   	push   %eax
80102cbf:	53                   	push   %ebx
80102cc0:	e8 5b e8 ff ff       	call   80101520 <readsb>
80102cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102cc8:	59                   	pop    %ecx
80102cc9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
80102ccf:	5a                   	pop    %edx
80102cd0:	66 0f 6e 4d e8       	movd   -0x18(%ebp),%xmm1
80102cd5:	50                   	push   %eax
80102cd6:	66 0f 6e c0          	movd   %eax,%xmm0
80102cda:	53                   	push   %ebx
80102cdb:	66 0f 62 c1          	punpckldq %xmm1,%xmm0
80102cdf:	66 0f d6 05 d4 26 11 	movq   %xmm0,0x801126d4
80102ce6:	80 
80102ce7:	e8 e4 d3 ff ff       	call   801000d0 <bread>
80102cec:	83 c4 10             	add    $0x10,%esp
80102cef:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102cf2:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
80102cf8:	85 db                	test   %ebx,%ebx
80102cfa:	7e 16                	jle    80102d12 <initlog+0x72>
80102cfc:	31 d2                	xor    %edx,%edx
80102cfe:	66 90                	xchg   %ax,%ax
80102d00:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d04:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d3                	cmp    %edx,%ebx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
80102d20:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102d27:	00 00 00 
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave  
80102d36:	c3                   	ret    
80102d37:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d3e:	00 
80102d3f:	90                   	nop

80102d40 <begin_op>:
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	83 ec 14             	sub    $0x14,%esp
80102d46:	68 a0 26 11 80       	push   $0x801126a0
80102d4b:	e8 30 20 00 00       	call   80104d80 <acquire>
80102d50:	83 c4 10             	add    $0x10,%esp
80102d53:	eb 18                	jmp    80102d6d <begin_op+0x2d>
80102d55:	8d 76 00             	lea    0x0(%esi),%esi
80102d58:	83 ec 08             	sub    $0x8,%esp
80102d5b:	68 a0 26 11 80       	push   $0x801126a0
80102d60:	68 a0 26 11 80       	push   $0x801126a0
80102d65:	e8 86 1a 00 00       	call   801047f0 <sleep>
80102d6a:	83 c4 10             	add    $0x10,%esp
80102d6d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102d72:	85 c0                	test   %eax,%eax
80102d74:	75 e2                	jne    80102d58 <begin_op+0x18>
80102d76:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102d7b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102d81:	83 c0 01             	add    $0x1,%eax
80102d84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d8a:	83 fa 1e             	cmp    $0x1e,%edx
80102d8d:	7f c9                	jg     80102d58 <begin_op+0x18>
80102d8f:	83 ec 0c             	sub    $0xc,%esp
80102d92:	a3 dc 26 11 80       	mov    %eax,0x801126dc
80102d97:	68 a0 26 11 80       	push   $0x801126a0
80102d9c:	e8 7f 1f 00 00       	call   80104d20 <release>
80102da1:	83 c4 10             	add    $0x10,%esp
80102da4:	c9                   	leave  
80102da5:	c3                   	ret    
80102da6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dad:	00 
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <end_op>:
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	57                   	push   %edi
80102db4:	56                   	push   %esi
80102db5:	53                   	push   %ebx
80102db6:	83 ec 18             	sub    $0x18,%esp
80102db9:	68 a0 26 11 80       	push   $0x801126a0
80102dbe:	e8 bd 1f 00 00       	call   80104d80 <acquire>
80102dc3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102dc8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102dce:	83 c4 10             	add    $0x10,%esp
80102dd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd4:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
80102dda:	85 f6                	test   %esi,%esi
80102ddc:	0f 85 22 01 00 00    	jne    80102f04 <end_op+0x154>
80102de2:	85 db                	test   %ebx,%ebx
80102de4:	0f 85 f6 00 00 00    	jne    80102ee0 <end_op+0x130>
80102dea:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102df1:	00 00 00 
80102df4:	83 ec 0c             	sub    $0xc,%esp
80102df7:	68 a0 26 11 80       	push   $0x801126a0
80102dfc:	e8 1f 1f 00 00       	call   80104d20 <release>
80102e01:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e07:	83 c4 10             	add    $0x10,%esp
80102e0a:	85 c9                	test   %ecx,%ecx
80102e0c:	7f 42                	jg     80102e50 <end_op+0xa0>
80102e0e:	83 ec 0c             	sub    $0xc,%esp
80102e11:	68 a0 26 11 80       	push   $0x801126a0
80102e16:	e8 65 1f 00 00       	call   80104d80 <acquire>
80102e1b:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102e22:	00 00 00 
80102e25:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e2c:	e8 7f 1a 00 00       	call   801048b0 <wakeup>
80102e31:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102e38:	e8 e3 1e 00 00       	call   80104d20 <release>
80102e3d:	83 c4 10             	add    $0x10,%esp
80102e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e43:	5b                   	pop    %ebx
80102e44:	5e                   	pop    %esi
80102e45:	5f                   	pop    %edi
80102e46:	5d                   	pop    %ebp
80102e47:	c3                   	ret    
80102e48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e4f:	00 
80102e50:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 e4 26 11 80    	push   0x801126e4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80102e74:	ff 35 e4 26 11 80    	push   0x801126e4
80102e7a:	83 c3 01             	add    $0x1,%ebx
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
80102e82:	83 c4 0c             	add    $0xc,%esp
80102e85:	89 c7                	mov    %eax,%edi
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 47 20 00 00       	call   80104ee0 <memmove>
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
80102ec6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102ecd:	00 00 00 
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 34 ff ff ff       	jmp    80102e0e <end_op+0x5e>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 a0 26 11 80       	push   $0x801126a0
80102ee8:	e8 c3 19 00 00       	call   801048b0 <wakeup>
80102eed:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102ef4:	e8 27 1e 00 00       	call   80104d20 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret    
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 94 7e 10 80       	push   $0x80107e94
80102f0c:	e8 6f d4 ff ff       	call   80100380 <panic>
80102f11:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f18:	00 
80102f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f20 <log_write>:
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 04             	sub    $0x4,%esp
80102f27:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f30:	83 fa 1d             	cmp    $0x1d,%edx
80102f33:	7f 7d                	jg     80102fb2 <log_write+0x92>
80102f35:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102f3a:	83 e8 01             	sub    $0x1,%eax
80102f3d:	39 c2                	cmp    %eax,%edx
80102f3f:	7d 71                	jge    80102fb2 <log_write+0x92>
80102f41:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102f46:	85 c0                	test   %eax,%eax
80102f48:	7e 75                	jle    80102fbf <log_write+0x9f>
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 a0 26 11 80       	push   $0x801126a0
80102f52:	e8 29 1e 00 00       	call   80104d80 <acquire>
80102f57:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102f5a:	83 c4 10             	add    $0x10,%esp
80102f5d:	31 c0                	xor    %eax,%eax
80102f5f:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102f65:	85 d2                	test   %edx,%edx
80102f67:	7f 0e                	jg     80102f77 <log_write+0x57>
80102f69:	eb 15                	jmp    80102f80 <log_write+0x60>
80102f6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x80>
80102f77:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x50>
80102f80:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
80102f87:	39 c2                	cmp    %eax,%edx
80102f89:	74 1c                	je     80102fa7 <log_write+0x87>
80102f8b:	83 0b 04             	orl    $0x4,(%ebx)
80102f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f91:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
80102f98:	c9                   	leave  
80102f99:	e9 82 1d 00 00       	jmp    80104d20 <release>
80102f9e:	66 90                	xchg   %ax,%ax
80102fa0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80102fb0:	eb d9                	jmp    80102f8b <log_write+0x6b>
80102fb2:	83 ec 0c             	sub    $0xc,%esp
80102fb5:	68 a3 7e 10 80       	push   $0x80107ea3
80102fba:	e8 c1 d3 ff ff       	call   80100380 <panic>
80102fbf:	83 ec 0c             	sub    $0xc,%esp
80102fc2:	68 b9 7e 10 80       	push   $0x80107eb9
80102fc7:	e8 b4 d3 ff ff       	call   80100380 <panic>
80102fcc:	66 90                	xchg   %ax,%ax
80102fce:	66 90                	xchg   %ax,%ax

80102fd0 <mpmain>:
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	53                   	push   %ebx
80102fd4:	83 ec 04             	sub    $0x4,%esp
80102fd7:	e8 c4 0b 00 00       	call   80103ba0 <cpuid>
80102fdc:	89 c3                	mov    %eax,%ebx
80102fde:	e8 bd 0b 00 00       	call   80103ba0 <cpuid>
80102fe3:	83 ec 04             	sub    $0x4,%esp
80102fe6:	53                   	push   %ebx
80102fe7:	50                   	push   %eax
80102fe8:	68 d4 7e 10 80       	push   $0x80107ed4
80102fed:	e8 ae d6 ff ff       	call   801006a0 <cprintf>
80102ff2:	e8 c9 30 00 00       	call   801060c0 <idtinit>
80102ff7:	e8 44 0b 00 00       	call   80103b40 <mycpu>
80102ffc:	89 c2                	mov    %eax,%edx
80102ffe:	b8 01 00 00 00       	mov    $0x1,%eax
80103003:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
8010300a:	e8 71 10 00 00       	call   80104080 <scheduler>
8010300f:	90                   	nop

80103010 <mpenter>:
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	83 ec 08             	sub    $0x8,%esp
80103016:	e8 f5 41 00 00       	call   80107210 <switchkvm>
8010301b:	e8 60 41 00 00       	call   80107180 <seginit>
80103020:	e8 cb f7 ff ff       	call   801027f0 <lapicinit>
80103025:	e8 a6 ff ff ff       	call   80102fd0 <mpmain>
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <main>:
80103030:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103034:	83 e4 f0             	and    $0xfffffff0,%esp
80103037:	ff 71 fc             	push   -0x4(%ecx)
8010303a:	55                   	push   %ebp
8010303b:	89 e5                	mov    %esp,%ebp
8010303d:	53                   	push   %ebx
8010303e:	51                   	push   %ecx
8010303f:	83 ec 08             	sub    $0x8,%esp
80103042:	68 00 00 40 80       	push   $0x80400000
80103047:	68 30 6d 11 80       	push   $0x80116d30
8010304c:	e8 bf f5 ff ff       	call   80102610 <kinit1>
80103051:	e8 aa 46 00 00       	call   80107700 <kvmalloc>
80103056:	e8 85 01 00 00       	call   801031e0 <mpinit>
8010305b:	e8 90 f7 ff ff       	call   801027f0 <lapicinit>
80103060:	e8 1b 41 00 00       	call   80107180 <seginit>
80103065:	e8 76 03 00 00       	call   801033e0 <picinit>
8010306a:	e8 61 f3 ff ff       	call   801023d0 <ioapicinit>
8010306f:	e8 ec d9 ff ff       	call   80100a60 <consoleinit>
80103074:	e8 97 33 00 00       	call   80106410 <uartinit>
80103079:	e8 a2 0a 00 00       	call   80103b20 <pinit>
8010307e:	e8 bd 2f 00 00       	call   80106040 <tvinit>
80103083:	e8 b8 cf ff ff       	call   80100040 <binit>
80103088:	e8 83 dd ff ff       	call   80100e10 <fileinit>
8010308d:	e8 2e f1 ff ff       	call   801021c0 <ideinit>
80103092:	83 c4 0c             	add    $0xc,%esp
80103095:	68 8a 00 00 00       	push   $0x8a
8010309a:	68 8c b4 10 80       	push   $0x8010b48c
8010309f:	68 00 70 00 80       	push   $0x80007000
801030a4:	e8 37 1e 00 00       	call   80104ee0 <memmove>
801030a9:	83 c4 10             	add    $0x10,%esp
801030ac:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030b3:	00 00 00 
801030b6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030bb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
801030c0:	76 7e                	jbe    80103140 <main+0x110>
801030c2:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
801030c7:	eb 20                	jmp    801030e9 <main+0xb9>
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030d0:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801030d7:	00 00 00 
801030da:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030e0:	05 a0 27 11 80       	add    $0x801127a0,%eax
801030e5:	39 c3                	cmp    %eax,%ebx
801030e7:	73 57                	jae    80103140 <main+0x110>
801030e9:	e8 52 0a 00 00       	call   80103b40 <mycpu>
801030ee:	39 c3                	cmp    %eax,%ebx
801030f0:	74 de                	je     801030d0 <main+0xa0>
801030f2:	e8 89 f5 ff ff       	call   80102680 <kalloc>
801030f7:	83 ec 08             	sub    $0x8,%esp
801030fa:	c7 05 f8 6f 00 80 10 	movl   $0x80103010,0x80006ff8
80103101:	30 10 80 
80103104:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010310b:	a0 10 00 
8010310e:	05 00 10 00 00       	add    $0x1000,%eax
80103113:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
80103118:	0f b6 03             	movzbl (%ebx),%eax
8010311b:	68 00 70 00 00       	push   $0x7000
80103120:	50                   	push   %eax
80103121:	e8 0a f8 ff ff       	call   80102930 <lapicstartap>
80103126:	83 c4 10             	add    $0x10,%esp
80103129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103130:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103136:	85 c0                	test   %eax,%eax
80103138:	74 f6                	je     80103130 <main+0x100>
8010313a:	eb 94                	jmp    801030d0 <main+0xa0>
8010313c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103140:	83 ec 08             	sub    $0x8,%esp
80103143:	68 00 00 00 8e       	push   $0x8e000000
80103148:	68 00 00 40 80       	push   $0x80400000
8010314d:	e8 5e f4 ff ff       	call   801025b0 <kinit2>
80103152:	e8 39 0c 00 00       	call   80103d90 <userinit>
80103157:	e8 74 fe ff ff       	call   80102fd0 <mpmain>
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	57                   	push   %edi
80103164:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103165:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010316b:	53                   	push   %ebx
  e = addr+len;
8010316c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010316f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103172:	39 de                	cmp    %ebx,%esi
80103174:	72 10                	jb     80103186 <mpsearch1+0x26>
80103176:	eb 50                	jmp    801031c8 <mpsearch1+0x68>
80103178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010317f:	90                   	nop
80103180:	89 fe                	mov    %edi,%esi
80103182:	39 fb                	cmp    %edi,%ebx
80103184:	76 42                	jbe    801031c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103186:	83 ec 04             	sub    $0x4,%esp
80103189:	8d 7e 10             	lea    0x10(%esi),%edi
8010318c:	6a 04                	push   $0x4
8010318e:	68 e8 7e 10 80       	push   $0x80107ee8
80103193:	56                   	push   %esi
80103194:	e8 f7 1c 00 00       	call   80104e90 <memcmp>
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	85 c0                	test   %eax,%eax
8010319e:	75 e0                	jne    80103180 <mpsearch1+0x20>
801031a0:	89 f2                	mov    %esi,%edx
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031a8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031ab:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031ae:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031b0:	39 fa                	cmp    %edi,%edx
801031b2:	75 f4                	jne    801031a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b4:	84 c0                	test   %al,%al
801031b6:	75 c8                	jne    80103180 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031bb:	89 f0                	mov    %esi,%eax
801031bd:	5b                   	pop    %ebx
801031be:	5e                   	pop    %esi
801031bf:	5f                   	pop    %edi
801031c0:	5d                   	pop    %ebp
801031c1:	c3                   	ret    
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031cb:	31 f6                	xor    %esi,%esi
}
801031cd:	5b                   	pop    %ebx
801031ce:	89 f0                	mov    %esi,%eax
801031d0:	5e                   	pop    %esi
801031d1:	5f                   	pop    %edi
801031d2:	5d                   	pop    %ebp
801031d3:	c3                   	ret    
801031d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031df:	90                   	nop

801031e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	57                   	push   %edi
801031e4:	56                   	push   %esi
801031e5:	53                   	push   %ebx
801031e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031f7:	c1 e0 08             	shl    $0x8,%eax
801031fa:	09 d0                	or     %edx,%eax
801031fc:	c1 e0 04             	shl    $0x4,%eax
801031ff:	75 1b                	jne    8010321c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103201:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103208:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010320f:	c1 e0 08             	shl    $0x8,%eax
80103212:	09 d0                	or     %edx,%eax
80103214:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103217:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010321c:	ba 00 04 00 00       	mov    $0x400,%edx
80103221:	e8 3a ff ff ff       	call   80103160 <mpsearch1>
80103226:	89 c3                	mov    %eax,%ebx
80103228:	85 c0                	test   %eax,%eax
8010322a:	0f 84 40 01 00 00    	je     80103370 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103230:	8b 73 04             	mov    0x4(%ebx),%esi
80103233:	85 f6                	test   %esi,%esi
80103235:	0f 84 25 01 00 00    	je     80103360 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010323b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010323e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103244:	6a 04                	push   $0x4
80103246:	68 ed 7e 10 80       	push   $0x80107eed
8010324b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010324c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010324f:	e8 3c 1c 00 00       	call   80104e90 <memcmp>
80103254:	83 c4 10             	add    $0x10,%esp
80103257:	85 c0                	test   %eax,%eax
80103259:	0f 85 01 01 00 00    	jne    80103360 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010325f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103266:	3c 01                	cmp    $0x1,%al
80103268:	74 08                	je     80103272 <mpinit+0x92>
8010326a:	3c 04                	cmp    $0x4,%al
8010326c:	0f 85 ee 00 00 00    	jne    80103360 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103272:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103279:	66 85 d2             	test   %dx,%dx
8010327c:	74 22                	je     801032a0 <mpinit+0xc0>
8010327e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103281:	89 f0                	mov    %esi,%eax
  sum = 0;
80103283:	31 d2                	xor    %edx,%edx
80103285:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103288:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010328f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103292:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103294:	39 c7                	cmp    %eax,%edi
80103296:	75 f0                	jne    80103288 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103298:	84 d2                	test   %dl,%dl
8010329a:	0f 85 c0 00 00 00    	jne    80103360 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032a0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032a6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ab:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032b2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032b8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032bd:	03 55 e4             	add    -0x1c(%ebp),%edx
801032c0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032c7:	90                   	nop
801032c8:	39 d0                	cmp    %edx,%eax
801032ca:	73 15                	jae    801032e1 <mpinit+0x101>
    switch(*p){
801032cc:	0f b6 08             	movzbl (%eax),%ecx
801032cf:	80 f9 02             	cmp    $0x2,%cl
801032d2:	74 4c                	je     80103320 <mpinit+0x140>
801032d4:	77 3a                	ja     80103310 <mpinit+0x130>
801032d6:	84 c9                	test   %cl,%cl
801032d8:	74 56                	je     80103330 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032da:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032dd:	39 d0                	cmp    %edx,%eax
801032df:	72 eb                	jb     801032cc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801032e4:	85 f6                	test   %esi,%esi
801032e6:	0f 84 d9 00 00 00    	je     801033c5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032ec:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801032f0:	74 15                	je     80103307 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032f2:	b8 70 00 00 00       	mov    $0x70,%eax
801032f7:	ba 22 00 00 00       	mov    $0x22,%edx
801032fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032fd:	ba 23 00 00 00       	mov    $0x23,%edx
80103302:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103303:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103306:	ee                   	out    %al,(%dx)
  }
}
80103307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010330a:	5b                   	pop    %ebx
8010330b:	5e                   	pop    %esi
8010330c:	5f                   	pop    %edi
8010330d:	5d                   	pop    %ebp
8010330e:	c3                   	ret    
8010330f:	90                   	nop
    switch(*p){
80103310:	83 e9 03             	sub    $0x3,%ecx
80103313:	80 f9 01             	cmp    $0x1,%cl
80103316:	76 c2                	jbe    801032da <mpinit+0xfa>
80103318:	31 f6                	xor    %esi,%esi
8010331a:	eb ac                	jmp    801032c8 <mpinit+0xe8>
8010331c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103320:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103324:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103327:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010332d:	eb 99                	jmp    801032c8 <mpinit+0xe8>
8010332f:	90                   	nop
      if(ncpu < NCPU) {
80103330:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103336:	83 f9 07             	cmp    $0x7,%ecx
80103339:	7f 19                	jg     80103354 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010333b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103341:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103345:	83 c1 01             	add    $0x1,%ecx
80103348:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010334e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103354:	83 c0 14             	add    $0x14,%eax
      continue;
80103357:	e9 6c ff ff ff       	jmp    801032c8 <mpinit+0xe8>
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103360:	83 ec 0c             	sub    $0xc,%esp
80103363:	68 f2 7e 10 80       	push   $0x80107ef2
80103368:	e8 13 d0 ff ff       	call   80100380 <panic>
8010336d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103370:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103375:	eb 13                	jmp    8010338a <mpinit+0x1aa>
80103377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103380:	89 f3                	mov    %esi,%ebx
80103382:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103388:	74 d6                	je     80103360 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010338a:	83 ec 04             	sub    $0x4,%esp
8010338d:	8d 73 10             	lea    0x10(%ebx),%esi
80103390:	6a 04                	push   $0x4
80103392:	68 e8 7e 10 80       	push   $0x80107ee8
80103397:	53                   	push   %ebx
80103398:	e8 f3 1a 00 00       	call   80104e90 <memcmp>
8010339d:	83 c4 10             	add    $0x10,%esp
801033a0:	85 c0                	test   %eax,%eax
801033a2:	75 dc                	jne    80103380 <mpinit+0x1a0>
801033a4:	89 da                	mov    %ebx,%edx
801033a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ad:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033b0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033b3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033b6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033b8:	39 d6                	cmp    %edx,%esi
801033ba:	75 f4                	jne    801033b0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033bc:	84 c0                	test   %al,%al
801033be:	75 c0                	jne    80103380 <mpinit+0x1a0>
801033c0:	e9 6b fe ff ff       	jmp    80103230 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033c5:	83 ec 0c             	sub    $0xc,%esp
801033c8:	68 0c 7f 10 80       	push   $0x80107f0c
801033cd:	e8 ae cf ff ff       	call   80100380 <panic>
801033d2:	66 90                	xchg   %ax,%ax
801033d4:	66 90                	xchg   %ax,%ax
801033d6:	66 90                	xchg   %ax,%ax
801033d8:	66 90                	xchg   %ax,%ax
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <picinit>:
801033e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e5:	ba 21 00 00 00       	mov    $0x21,%edx
801033ea:	ee                   	out    %al,(%dx)
801033eb:	ba a1 00 00 00       	mov    $0xa1,%edx
801033f0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033f1:	c3                   	ret    
801033f2:	66 90                	xchg   %ax,%ax
801033f4:	66 90                	xchg   %ax,%ax
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	57                   	push   %edi
80103404:	56                   	push   %esi
80103405:	53                   	push   %ebx
80103406:	83 ec 0c             	sub    $0xc,%esp
80103409:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010340c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010340f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103415:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010341b:	e8 10 da ff ff       	call   80100e30 <filealloc>
80103420:	89 03                	mov    %eax,(%ebx)
80103422:	85 c0                	test   %eax,%eax
80103424:	0f 84 a8 00 00 00    	je     801034d2 <pipealloc+0xd2>
8010342a:	e8 01 da ff ff       	call   80100e30 <filealloc>
8010342f:	89 06                	mov    %eax,(%esi)
80103431:	85 c0                	test   %eax,%eax
80103433:	0f 84 87 00 00 00    	je     801034c0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103439:	e8 42 f2 ff ff       	call   80102680 <kalloc>
8010343e:	89 c7                	mov    %eax,%edi
80103440:	85 c0                	test   %eax,%eax
80103442:	0f 84 b0 00 00 00    	je     801034f8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103448:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010344f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103452:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103455:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010345c:	00 00 00 
  p->nwrite = 0;
8010345f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103466:	00 00 00 
  p->nread = 0;
80103469:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103470:	00 00 00 
  initlock(&p->lock, "pipe");
80103473:	68 2b 7f 10 80       	push   $0x80107f2b
80103478:	50                   	push   %eax
80103479:	e8 32 17 00 00       	call   80104bb0 <initlock>
  (*f0)->type = FD_PIPE;
8010347e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103480:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103483:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103489:	8b 03                	mov    (%ebx),%eax
8010348b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010348f:	8b 03                	mov    (%ebx),%eax
80103491:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103495:	8b 03                	mov    (%ebx),%eax
80103497:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010349a:	8b 06                	mov    (%esi),%eax
8010349c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034a2:	8b 06                	mov    (%esi),%eax
801034a4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034a8:	8b 06                	mov    (%esi),%eax
801034aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034ae:	8b 06                	mov    (%esi),%eax
801034b0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034b6:	31 c0                	xor    %eax,%eax
}
801034b8:	5b                   	pop    %ebx
801034b9:	5e                   	pop    %esi
801034ba:	5f                   	pop    %edi
801034bb:	5d                   	pop    %ebp
801034bc:	c3                   	ret    
801034bd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034c0:	8b 03                	mov    (%ebx),%eax
801034c2:	85 c0                	test   %eax,%eax
801034c4:	74 1e                	je     801034e4 <pipealloc+0xe4>
    fileclose(*f0);
801034c6:	83 ec 0c             	sub    $0xc,%esp
801034c9:	50                   	push   %eax
801034ca:	e8 21 da ff ff       	call   80100ef0 <fileclose>
801034cf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	85 c0                	test   %eax,%eax
801034d6:	74 0c                	je     801034e4 <pipealloc+0xe4>
    fileclose(*f1);
801034d8:	83 ec 0c             	sub    $0xc,%esp
801034db:	50                   	push   %eax
801034dc:	e8 0f da ff ff       	call   80100ef0 <fileclose>
801034e1:	83 c4 10             	add    $0x10,%esp
}
801034e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034ec:	5b                   	pop    %ebx
801034ed:	5e                   	pop    %esi
801034ee:	5f                   	pop    %edi
801034ef:	5d                   	pop    %ebp
801034f0:	c3                   	ret    
801034f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034f8:	8b 03                	mov    (%ebx),%eax
801034fa:	85 c0                	test   %eax,%eax
801034fc:	75 c8                	jne    801034c6 <pipealloc+0xc6>
801034fe:	eb d2                	jmp    801034d2 <pipealloc+0xd2>

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	56                   	push   %esi
80103504:	53                   	push   %ebx
80103505:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103508:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350b:	83 ec 0c             	sub    $0xc,%esp
8010350e:	53                   	push   %ebx
8010350f:	e8 6c 18 00 00       	call   80104d80 <acquire>
  if(writable){
80103514:	83 c4 10             	add    $0x10,%esp
80103517:	85 f6                	test   %esi,%esi
80103519:	74 65                	je     80103580 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351b:	83 ec 0c             	sub    $0xc,%esp
8010351e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103524:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352b:	00 00 00 
    wakeup(&p->nread);
8010352e:	50                   	push   %eax
8010352f:	e8 7c 13 00 00       	call   801048b0 <wakeup>
80103534:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103537:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010353d:	85 d2                	test   %edx,%edx
8010353f:	75 0a                	jne    8010354b <pipeclose+0x4b>
80103541:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103547:	85 c0                	test   %eax,%eax
80103549:	74 15                	je     80103560 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010354e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103551:	5b                   	pop    %ebx
80103552:	5e                   	pop    %esi
80103553:	5d                   	pop    %ebp
    release(&p->lock);
80103554:	e9 c7 17 00 00       	jmp    80104d20 <release>
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	53                   	push   %ebx
80103564:	e8 b7 17 00 00       	call   80104d20 <release>
    kfree((char*)p);
80103569:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010356c:	83 c4 10             	add    $0x10,%esp
}
8010356f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103572:	5b                   	pop    %ebx
80103573:	5e                   	pop    %esi
80103574:	5d                   	pop    %ebp
    kfree((char*)p);
80103575:	e9 46 ef ff ff       	jmp    801024c0 <kfree>
8010357a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103589:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103590:	00 00 00 
    wakeup(&p->nwrite);
80103593:	50                   	push   %eax
80103594:	e8 17 13 00 00       	call   801048b0 <wakeup>
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	eb 99                	jmp    80103537 <pipeclose+0x37>
8010359e:	66 90                	xchg   %ax,%ax

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	57                   	push   %edi
801035a4:	56                   	push   %esi
801035a5:	53                   	push   %ebx
801035a6:	83 ec 28             	sub    $0x28,%esp
801035a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ac:	53                   	push   %ebx
801035ad:	e8 ce 17 00 00       	call   80104d80 <acquire>
  for(i = 0; i < n; i++){
801035b2:	8b 45 10             	mov    0x10(%ebp),%eax
801035b5:	83 c4 10             	add    $0x10,%esp
801035b8:	85 c0                	test   %eax,%eax
801035ba:	0f 8e c0 00 00 00    	jle    80103680 <pipewrite+0xe0>
801035c0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035c9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035d2:	03 45 10             	add    0x10(%ebp),%eax
801035d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035d8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035de:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e4:	89 ca                	mov    %ecx,%edx
801035e6:	05 00 02 00 00       	add    $0x200,%eax
801035eb:	39 c1                	cmp    %eax,%ecx
801035ed:	74 3f                	je     8010362e <pipewrite+0x8e>
801035ef:	eb 67                	jmp    80103658 <pipewrite+0xb8>
801035f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801035f8:	e8 63 07 00 00       	call   80103d60 <myproc>
801035fd:	8b 48 28             	mov    0x28(%eax),%ecx
80103600:	85 c9                	test   %ecx,%ecx
80103602:	75 34                	jne    80103638 <pipewrite+0x98>
      wakeup(&p->nread);
80103604:	83 ec 0c             	sub    $0xc,%esp
80103607:	57                   	push   %edi
80103608:	e8 a3 12 00 00       	call   801048b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360d:	58                   	pop    %eax
8010360e:	5a                   	pop    %edx
8010360f:	53                   	push   %ebx
80103610:	56                   	push   %esi
80103611:	e8 da 11 00 00       	call   801047f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103616:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010361c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103622:	83 c4 10             	add    $0x10,%esp
80103625:	05 00 02 00 00       	add    $0x200,%eax
8010362a:	39 c2                	cmp    %eax,%edx
8010362c:	75 2a                	jne    80103658 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010362e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103634:	85 c0                	test   %eax,%eax
80103636:	75 c0                	jne    801035f8 <pipewrite+0x58>
        release(&p->lock);
80103638:	83 ec 0c             	sub    $0xc,%esp
8010363b:	53                   	push   %ebx
8010363c:	e8 df 16 00 00       	call   80104d20 <release>
        return -1;
80103641:	83 c4 10             	add    $0x10,%esp
80103644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103649:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010364c:	5b                   	pop    %ebx
8010364d:	5e                   	pop    %esi
8010364e:	5f                   	pop    %edi
8010364f:	5d                   	pop    %ebp
80103650:	c3                   	ret    
80103651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103658:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010365b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010365e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103664:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010366a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010366d:	83 c6 01             	add    $0x1,%esi
80103670:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103673:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103677:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010367a:	0f 85 58 ff ff ff    	jne    801035d8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103689:	50                   	push   %eax
8010368a:	e8 21 12 00 00       	call   801048b0 <wakeup>
  release(&p->lock);
8010368f:	89 1c 24             	mov    %ebx,(%esp)
80103692:	e8 89 16 00 00       	call   80104d20 <release>
  return n;
80103697:	8b 45 10             	mov    0x10(%ebp),%eax
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	eb aa                	jmp    80103649 <pipewrite+0xa9>
8010369f:	90                   	nop

801036a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	57                   	push   %edi
801036a4:	56                   	push   %esi
801036a5:	53                   	push   %ebx
801036a6:	83 ec 18             	sub    $0x18,%esp
801036a9:	8b 75 08             	mov    0x8(%ebp),%esi
801036ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036af:	56                   	push   %esi
801036b0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036b6:	e8 c5 16 00 00       	call   80104d80 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036bb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036c1:	83 c4 10             	add    $0x10,%esp
801036c4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036ca:	74 2f                	je     801036fb <piperead+0x5b>
801036cc:	eb 37                	jmp    80103705 <piperead+0x65>
801036ce:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801036d0:	e8 8b 06 00 00       	call   80103d60 <myproc>
801036d5:	8b 48 28             	mov    0x28(%eax),%ecx
801036d8:	85 c9                	test   %ecx,%ecx
801036da:	0f 85 80 00 00 00    	jne    80103760 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036e0:	83 ec 08             	sub    $0x8,%esp
801036e3:	56                   	push   %esi
801036e4:	53                   	push   %ebx
801036e5:	e8 06 11 00 00       	call   801047f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036ea:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801036f0:	83 c4 10             	add    $0x10,%esp
801036f3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801036f9:	75 0a                	jne    80103705 <piperead+0x65>
801036fb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103701:	85 c0                	test   %eax,%eax
80103703:	75 cb                	jne    801036d0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103705:	8b 55 10             	mov    0x10(%ebp),%edx
80103708:	31 db                	xor    %ebx,%ebx
8010370a:	85 d2                	test   %edx,%edx
8010370c:	7f 20                	jg     8010372e <piperead+0x8e>
8010370e:	eb 2c                	jmp    8010373c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103710:	8d 48 01             	lea    0x1(%eax),%ecx
80103713:	25 ff 01 00 00       	and    $0x1ff,%eax
80103718:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010371e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103723:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103726:	83 c3 01             	add    $0x1,%ebx
80103729:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010372c:	74 0e                	je     8010373c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010372e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103734:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010373a:	75 d4                	jne    80103710 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010373c:	83 ec 0c             	sub    $0xc,%esp
8010373f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103745:	50                   	push   %eax
80103746:	e8 65 11 00 00       	call   801048b0 <wakeup>
  release(&p->lock);
8010374b:	89 34 24             	mov    %esi,(%esp)
8010374e:	e8 cd 15 00 00       	call   80104d20 <release>
  return i;
80103753:	83 c4 10             	add    $0x10,%esp
}
80103756:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103759:	89 d8                	mov    %ebx,%eax
8010375b:	5b                   	pop    %ebx
8010375c:	5e                   	pop    %esi
8010375d:	5f                   	pop    %edi
8010375e:	5d                   	pop    %ebp
8010375f:	c3                   	ret    
      release(&p->lock);
80103760:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103763:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103768:	56                   	push   %esi
80103769:	e8 b2 15 00 00       	call   80104d20 <release>
      return -1;
8010376e:	83 c4 10             	add    $0x10,%esp
}
80103771:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103774:	89 d8                	mov    %ebx,%eax
80103776:	5b                   	pop    %ebx
80103777:	5e                   	pop    %esi
80103778:	5f                   	pop    %edi
80103779:	5d                   	pop    %ebp
8010377a:	c3                   	ret    
8010377b:	66 90                	xchg   %ax,%ax
8010377d:	66 90                	xchg   %ax,%ax
8010377f:	90                   	nop

80103780 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103784:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
{
80103789:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010378c:	68 80 2d 11 80       	push   $0x80112d80
80103791:	e8 ea 15 00 00       	call   80104d80 <acquire>
80103796:	83 c4 10             	add    $0x10,%esp
80103799:	eb 13                	jmp    801037ae <allocproc+0x2e>
8010379b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010379f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a0:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801037a6:	81 fb b4 54 11 80    	cmp    $0x801154b4,%ebx
801037ac:	74 7a                	je     80103828 <allocproc+0xa8>
    if(p->state == UNUSED)
801037ae:	8b 43 10             	mov    0x10(%ebx),%eax
801037b1:	85 c0                	test   %eax,%eax
801037b3:	75 eb                	jne    801037a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037b5:	a1 14 b0 10 80       	mov    0x8010b014,%eax

  release(&ptable.lock);
801037ba:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037bd:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->pid = nextpid++;
801037c4:	89 43 14             	mov    %eax,0x14(%ebx)
801037c7:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037ca:	68 80 2d 11 80       	push   $0x80112d80
  p->pid = nextpid++;
801037cf:	89 15 14 b0 10 80    	mov    %edx,0x8010b014
  release(&ptable.lock);
801037d5:	e8 46 15 00 00       	call   80104d20 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037da:	e8 a1 ee ff ff       	call   80102680 <kalloc>
801037df:	83 c4 10             	add    $0x10,%esp
801037e2:	89 43 0c             	mov    %eax,0xc(%ebx)
801037e5:	85 c0                	test   %eax,%eax
801037e7:	74 58                	je     80103841 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037e9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037ef:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801037f2:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801037f7:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
801037fa:	c7 40 14 32 60 10 80 	movl   $0x80106032,0x14(%eax)
  p->context = (struct context*)sp;
80103801:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103804:	6a 14                	push   $0x14
80103806:	6a 00                	push   $0x0
80103808:	50                   	push   %eax
80103809:	e8 32 16 00 00       	call   80104e40 <memset>
  p->context->eip = (uint)forkret;
8010380e:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
80103811:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103814:	c7 40 10 60 38 10 80 	movl   $0x80103860,0x10(%eax)
}
8010381b:	89 d8                	mov    %ebx,%eax
8010381d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103820:	c9                   	leave  
80103821:	c3                   	ret    
80103822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103828:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010382b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010382d:	68 80 2d 11 80       	push   $0x80112d80
80103832:	e8 e9 14 00 00       	call   80104d20 <release>
}
80103837:	89 d8                	mov    %ebx,%eax
  return 0;
80103839:	83 c4 10             	add    $0x10,%esp
}
8010383c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010383f:	c9                   	leave  
80103840:	c3                   	ret    
    p->state = UNUSED;
80103841:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
80103848:	31 db                	xor    %ebx,%ebx
}
8010384a:	89 d8                	mov    %ebx,%eax
8010384c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010384f:	c9                   	leave  
80103850:	c3                   	ret    
80103851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010385f:	90                   	nop

80103860 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103866:	68 80 2d 11 80       	push   $0x80112d80
8010386b:	e8 b0 14 00 00       	call   80104d20 <release>

  if (first) {
80103870:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103875:	83 c4 10             	add    $0x10,%esp
80103878:	85 c0                	test   %eax,%eax
8010387a:	75 04                	jne    80103880 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010387c:	c9                   	leave  
8010387d:	c3                   	ret    
8010387e:	66 90                	xchg   %ax,%ax
    first = 0;
80103880:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103887:	00 00 00 
    iinit(ROOTDEV);
8010388a:	83 ec 0c             	sub    $0xc,%esp
8010388d:	6a 01                	push   $0x1
8010388f:	e8 cc dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
80103894:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010389b:	e8 00 f4 ff ff       	call   80102ca0 <initlog>
}
801038a0:	83 c4 10             	add    $0x10,%esp
801038a3:	c9                   	leave  
801038a4:	c3                   	ret    
801038a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038b0 <queues_init>:
    for (int i = 0; i < 4; i++) {
801038b0:	b8 40 2d 11 80       	mov    $0x80112d40,%eax
801038b5:	31 d2                	xor    %edx,%edx
        queues[i].priority = i;
801038b7:	89 10                	mov    %edx,(%eax)
    for (int i = 0; i < 4; i++) {
801038b9:	83 c2 01             	add    $0x1,%edx
801038bc:	83 c0 0c             	add    $0xc,%eax
        queues[i].head = NULL;
801038bf:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
        queues[i].tail = NULL;
801038c6:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
    for (int i = 0; i < 4; i++) {
801038cd:	83 fa 04             	cmp    $0x4,%edx
801038d0:	75 e5                	jne    801038b7 <queues_init+0x7>
}
801038d2:	c3                   	ret    
801038d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801038e0 <enqueue_process>:
enqueue_process(struct proc* p, int priority) {
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	53                   	push   %ebx
801038e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801038e7:	8b 55 08             	mov    0x8(%ebp),%edx
    if (q->tail == NULL) {
801038ea:	8d 0c 40             	lea    (%eax,%eax,2),%ecx
801038ed:	8d 1c 8d 40 2d 11 80 	lea    -0x7feed2c0(,%ecx,4),%ebx
801038f4:	8b 4b 08             	mov    0x8(%ebx),%ecx
801038f7:	85 c9                	test   %ecx,%ecx
801038f9:	74 25                	je     80103920 <enqueue_process+0x40>
        q->tail->next = p;
801038fb:	89 91 80 00 00 00    	mov    %edx,0x80(%ecx)
    p->next = NULL;
80103901:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80103908:	00 00 00 
        q->tail = p;
8010390b:	8d 04 40             	lea    (%eax,%eax,2),%eax
}
8010390e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        q->tail = p;
80103911:	89 14 85 48 2d 11 80 	mov    %edx,-0x7feed2b8(,%eax,4)
}
80103918:	c9                   	leave  
80103919:	c3                   	ret    
8010391a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        q->head = p;
80103920:	89 53 04             	mov    %edx,0x4(%ebx)
        q->tail = p;
80103923:	eb dc                	jmp    80103901 <enqueue_process+0x21>
80103925:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010392c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103930 <dequeue_process>:
dequeue_process(int priority) {
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	8b 45 08             	mov    0x8(%ebp),%eax
    if (q->head == NULL) {
80103936:	8d 04 40             	lea    (%eax,%eax,2),%eax
80103939:	8d 14 85 40 2d 11 80 	lea    -0x7feed2c0(,%eax,4),%edx
80103940:	8b 42 04             	mov    0x4(%edx),%eax
80103943:	85 c0                	test   %eax,%eax
80103945:	74 0d                	je     80103954 <dequeue_process+0x24>
    q->head = q->head->next;
80103947:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
8010394d:	89 4a 04             	mov    %ecx,0x4(%edx)
    if (q->head == NULL) {
80103950:	85 c9                	test   %ecx,%ecx
80103952:	74 0c                	je     80103960 <dequeue_process+0x30>
}
80103954:	5d                   	pop    %ebp
80103955:	c3                   	ret    
80103956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395d:	8d 76 00             	lea    0x0(%esi),%esi
        q->tail = NULL;
80103960:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
}
80103967:	5d                   	pop    %ebp
80103968:	c3                   	ret    
80103969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103970 <get_next_round_robin>:
get_next_round_robin(int priority) {
80103970:	55                   	push   %ebp
    if (current_proc == NULL || current_proc->rtime >= TIME_SLICE) {
80103971:	a1 20 2d 11 80       	mov    0x80112d20,%eax
get_next_round_robin(int priority) {
80103976:	89 e5                	mov    %esp,%ebp
80103978:	8b 55 08             	mov    0x8(%ebp),%edx
    if (current_proc == NULL || current_proc->rtime >= TIME_SLICE) {
8010397b:	85 c0                	test   %eax,%eax
8010397d:	74 09                	je     80103988 <get_next_round_robin+0x18>
8010397f:	83 b8 84 00 00 00 09 	cmpl   $0x9,0x84(%eax)
80103986:	7e 31                	jle    801039b9 <get_next_round_robin+0x49>
    if (q->head == NULL) {
80103988:	8d 04 52             	lea    (%edx,%edx,2),%eax
8010398b:	8d 14 85 40 2d 11 80 	lea    -0x7feed2c0(,%eax,4),%edx
80103992:	8b 42 04             	mov    0x4(%edx),%eax
80103995:	85 c0                	test   %eax,%eax
80103997:	0f 84 b3 10 00 00    	je     80104a50 <get_next_round_robin.cold>
    q->head = q->head->next;
8010399d:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
801039a3:	89 4a 04             	mov    %ecx,0x4(%edx)
    if (q->head == NULL) {
801039a6:	85 c9                	test   %ecx,%ecx
801039a8:	74 16                	je     801039c0 <get_next_round_robin+0x50>
        current_proc = dequeue_process(priority);
801039aa:	a3 20 2d 11 80       	mov    %eax,0x80112d20
        current_proc->rtime = 0;
801039af:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801039b6:	00 00 00 
}
801039b9:	5d                   	pop    %ebp
801039ba:	c3                   	ret    
801039bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop
        q->tail = NULL;
801039c0:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
        current_proc = dequeue_process(priority);
801039c7:	a3 20 2d 11 80       	mov    %eax,0x80112d20
        current_proc->rtime = 0;
801039cc:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801039d3:	00 00 00 
    return current_proc;
801039d6:	eb e1                	jmp    801039b9 <get_next_round_robin+0x49>
801039d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039df:	90                   	nop

801039e0 <get_shortest_job>:
get_shortest_job(int priority) {
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	8b 45 08             	mov    0x8(%ebp),%eax
    for (p = queues[priority].head; p != NULL; p = p->next) {
801039e6:	8d 04 40             	lea    (%eax,%eax,2),%eax
801039e9:	8b 14 85 44 2d 11 80 	mov    -0x7feed2bc(,%eax,4),%edx
801039f0:	89 d0                	mov    %edx,%eax
801039f2:	85 d2                	test   %edx,%edx
801039f4:	75 13                	jne    80103a09 <get_shortest_job+0x29>
801039f6:	eb 1b                	jmp    80103a13 <get_shortest_job+0x33>
801039f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ff:	90                   	nop
        if (shortest_job == NULL || p->ctime < shortest_job->ctime) {
80103a00:	8b 4a 04             	mov    0x4(%edx),%ecx
80103a03:	39 48 04             	cmp    %ecx,0x4(%eax)
80103a06:	0f 42 d0             	cmovb  %eax,%edx
    for (p = queues[priority].head; p != NULL; p = p->next) {
80103a09:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80103a0f:	85 c0                	test   %eax,%eax
80103a11:	75 ed                	jne    80103a00 <get_shortest_job+0x20>
}
80103a13:	89 d0                	mov    %edx,%eax
80103a15:	5d                   	pop    %ebp
80103a16:	c3                   	ret    
80103a17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a1e:	66 90                	xchg   %ax,%ax

80103a20 <get_lottery_winner>:
get_lottery_winner(void) {
80103a20:	55                   	push   %ebp
80103a21:	b9 c4 2d 11 80       	mov    $0x80112dc4,%ecx
80103a26:	89 c8                	mov    %ecx,%eax
80103a28:	89 e5                	mov    %esp,%ebp
80103a2a:	53                   	push   %ebx
    int total_tickets = 0;
80103a2b:	31 db                	xor    %ebx,%ebx
80103a2d:	8d 76 00             	lea    0x0(%esi),%esi
        if (ptable.proc[i].state == RUNNABLE) {
80103a30:	83 38 03             	cmpl   $0x3,(%eax)
80103a33:	75 03                	jne    80103a38 <get_lottery_winner+0x18>
            total_tickets += ptable.proc[i].tickets;
80103a35:	03 58 78             	add    0x78(%eax),%ebx
    for (int i = 0; i < NPROC; i++) {
80103a38:	05 9c 00 00 00       	add    $0x9c,%eax
80103a3d:	3d c4 54 11 80       	cmp    $0x801154c4,%eax
80103a42:	75 ec                	jne    80103a30 <get_lottery_winner+0x10>
    int lottery_number = (index + 1) % total_tickets;
80103a44:	b8 01 00 00 00       	mov    $0x1,%eax
80103a49:	99                   	cltd   
80103a4a:	f7 fb                	idiv   %ebx
    for (int i = 0; i < NPROC; i++) {
80103a4c:	31 c0                	xor    %eax,%eax
    int accumulated_tickets = 0;
80103a4e:	31 db                	xor    %ebx,%ebx
80103a50:	eb 14                	jmp    80103a66 <get_lottery_winner+0x46>
80103a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (int i = 0; i < NPROC; i++) {
80103a58:	83 c0 01             	add    $0x1,%eax
80103a5b:	81 c1 9c 00 00 00    	add    $0x9c,%ecx
80103a61:	83 f8 40             	cmp    $0x40,%eax
80103a64:	74 1c                	je     80103a82 <get_lottery_winner+0x62>
        if (ptable.proc[i].state == RUNNABLE) {
80103a66:	83 39 03             	cmpl   $0x3,(%ecx)
80103a69:	75 ed                	jne    80103a58 <get_lottery_winner+0x38>
            accumulated_tickets += ptable.proc[i].tickets;
80103a6b:	03 59 78             	add    0x78(%ecx),%ebx
            if (accumulated_tickets > lottery_number) {
80103a6e:	39 da                	cmp    %ebx,%edx
80103a70:	7d e6                	jge    80103a58 <get_lottery_winner+0x38>
                return &ptable.proc[i];
80103a72:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
}
80103a78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a7b:	c9                   	leave  
                return &ptable.proc[i];
80103a7c:	05 b4 2d 11 80       	add    $0x80112db4,%eax
}
80103a81:	c3                   	ret    
80103a82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return NULL;
80103a85:	31 c0                	xor    %eax,%eax
}
80103a87:	c9                   	leave  
80103a88:	c3                   	ret    
80103a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a90 <dequeue_especific_process>:
dequeue_especific_process(int priority, struct proc* p) {
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	53                   	push   %ebx
80103a94:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a97:	8b 55 0c             	mov    0xc(%ebp),%edx
    struct proc* curr = q->head;
80103a9a:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
80103a9d:	8b 04 85 44 2d 11 80 	mov    -0x7feed2bc(,%eax,4),%eax
    while (curr != NULL && curr != p) {
80103aa4:	39 d0                	cmp    %edx,%eax
80103aa6:	74 4c                	je     80103af4 <dequeue_especific_process+0x64>
80103aa8:	85 c0                	test   %eax,%eax
80103aaa:	74 32                	je     80103ade <dequeue_especific_process+0x4e>
80103aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        curr = curr->next;
80103ab0:	89 c1                	mov    %eax,%ecx
80103ab2:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
    while (curr != NULL && curr != p) {
80103ab8:	85 c0                	test   %eax,%eax
80103aba:	74 22                	je     80103ade <dequeue_especific_process+0x4e>
80103abc:	39 c2                	cmp    %eax,%edx
80103abe:	75 f0                	jne    80103ab0 <dequeue_especific_process+0x20>
    if (curr == NULL) {
80103ac0:	85 c0                	test   %eax,%eax
80103ac2:	74 1a                	je     80103ade <dequeue_especific_process+0x4e>
        prev->next = curr->next;
80103ac4:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103aca:	89 91 80 00 00 00    	mov    %edx,0x80(%ecx)
        if (prev->next == NULL) {
80103ad0:	85 d2                	test   %edx,%edx
80103ad2:	74 14                	je     80103ae8 <dequeue_especific_process+0x58>
    curr->next = NULL;
80103ad4:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103adb:	00 00 00 
}
80103ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ae1:	c9                   	leave  
80103ae2:	c3                   	ret    
80103ae3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ae7:	90                   	nop
            q->tail = prev;
80103ae8:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
80103aeb:	89 0c 95 48 2d 11 80 	mov    %ecx,-0x7feed2b8(,%edx,4)
80103af2:	eb e0                	jmp    80103ad4 <dequeue_especific_process+0x44>
    if (curr == NULL) {
80103af4:	85 c0                	test   %eax,%eax
80103af6:	74 e6                	je     80103ade <dequeue_especific_process+0x4e>
        q->head = curr->next;
80103af8:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80103afe:	8d 0c 5b             	lea    (%ebx,%ebx,2),%ecx
80103b01:	8d 0c 8d 40 2d 11 80 	lea    -0x7feed2c0(,%ecx,4),%ecx
80103b08:	89 51 04             	mov    %edx,0x4(%ecx)
        if (q->head == NULL) {
80103b0b:	85 d2                	test   %edx,%edx
80103b0d:	75 c5                	jne    80103ad4 <dequeue_especific_process+0x44>
            q->tail = NULL;
80103b0f:	c7 41 08 00 00 00 00 	movl   $0x0,0x8(%ecx)
80103b16:	eb bc                	jmp    80103ad4 <dequeue_especific_process+0x44>
80103b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <pinit>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b26:	68 30 7f 10 80       	push   $0x80107f30
80103b2b:	68 80 2d 11 80       	push   $0x80112d80
80103b30:	e8 7b 10 00 00       	call   80104bb0 <initlock>
}
80103b35:	83 c4 10             	add    $0x10,%esp
80103b38:	c9                   	leave  
80103b39:	c3                   	ret    
80103b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b40 <mycpu>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	56                   	push   %esi
80103b44:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b45:	9c                   	pushf  
80103b46:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b47:	f6 c4 02             	test   $0x2,%ah
80103b4a:	75 46                	jne    80103b92 <mycpu+0x52>
  apicid = lapicid();
80103b4c:	e8 8f ed ff ff       	call   801028e0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b51:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103b57:	85 f6                	test   %esi,%esi
80103b59:	7e 2a                	jle    80103b85 <mycpu+0x45>
80103b5b:	31 d2                	xor    %edx,%edx
80103b5d:	eb 08                	jmp    80103b67 <mycpu+0x27>
80103b5f:	90                   	nop
80103b60:	83 c2 01             	add    $0x1,%edx
80103b63:	39 f2                	cmp    %esi,%edx
80103b65:	74 1e                	je     80103b85 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103b67:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103b6d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103b74:	39 c3                	cmp    %eax,%ebx
80103b76:	75 e8                	jne    80103b60 <mycpu+0x20>
}
80103b78:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b7b:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103b81:	5b                   	pop    %ebx
80103b82:	5e                   	pop    %esi
80103b83:	5d                   	pop    %ebp
80103b84:	c3                   	ret    
  panic("unknown apicid\n");
80103b85:	83 ec 0c             	sub    $0xc,%esp
80103b88:	68 37 7f 10 80       	push   $0x80107f37
80103b8d:	e8 ee c7 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b92:	83 ec 0c             	sub    $0xc,%esp
80103b95:	68 14 80 10 80       	push   $0x80108014
80103b9a:	e8 e1 c7 ff ff       	call   80100380 <panic>
80103b9f:	90                   	nop

80103ba0 <cpuid>:
cpuid() {
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ba6:	e8 95 ff ff ff       	call   80103b40 <mycpu>
}
80103bab:	c9                   	leave  
  return mycpu()-cpus;
80103bac:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103bb1:	c1 f8 04             	sar    $0x4,%eax
80103bb4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103bba:	c3                   	ret    
80103bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bbf:	90                   	nop

80103bc0 <change_prio>:
change_prio(int new_priority) {
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	56                   	push   %esi
80103bc4:	53                   	push   %ebx
80103bc5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bc8:	e8 63 10 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80103bcd:	e8 6e ff ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80103bd2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bd8:	e8 a3 10 00 00       	call   80104c80 <popcli>
    if (p == 0) {
80103bdd:	85 db                	test   %ebx,%ebx
80103bdf:	0f 84 85 00 00 00    	je     80103c6a <change_prio+0xaa>
    if (p->priority != -1) {
80103be5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80103beb:	83 f8 ff             	cmp    $0xffffffff,%eax
80103bee:	74 0d                	je     80103bfd <change_prio+0x3d>
        dequeue_especific_process(p->priority, p);
80103bf0:	83 ec 08             	sub    $0x8,%esp
80103bf3:	53                   	push   %ebx
80103bf4:	50                   	push   %eax
80103bf5:	e8 96 fe ff ff       	call   80103a90 <dequeue_especific_process>
80103bfa:	83 c4 10             	add    $0x10,%esp
    switch (new_priority) {
80103bfd:	83 fe 03             	cmp    $0x3,%esi
80103c00:	0f 84 8a 00 00 00    	je     80103c90 <change_prio+0xd0>
80103c06:	7f 58                	jg     80103c60 <change_prio+0xa0>
80103c08:	83 fe 01             	cmp    $0x1,%esi
80103c0b:	74 7b                	je     80103c88 <change_prio+0xc8>
80103c0d:	83 fe 02             	cmp    $0x2,%esi
80103c10:	75 58                	jne    80103c6a <change_prio+0xaa>
            enqueue_process(p, ROUND_ROBIN);
80103c12:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
    if (q->tail == NULL) {
80103c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c1e:	66 90                	xchg   %ax,%ax
80103c20:	8d 14 40             	lea    (%eax,%eax,2),%edx
80103c23:	8d 0c 95 40 2d 11 80 	lea    -0x7feed2c0(,%edx,4),%ecx
80103c2a:	8b 51 08             	mov    0x8(%ecx),%edx
80103c2d:	85 d2                	test   %edx,%edx
80103c2f:	74 4f                	je     80103c80 <change_prio+0xc0>
        q->tail->next = p;
80103c31:	89 9a 80 00 00 00    	mov    %ebx,0x80(%edx)
        q->tail = p;
80103c37:	8d 04 40             	lea    (%eax,%eax,2),%eax
80103c3a:	89 1c 85 48 2d 11 80 	mov    %ebx,-0x7feed2b8(,%eax,4)
    return 0;
80103c41:	31 c0                	xor    %eax,%eax
    p->next = NULL;
80103c43:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103c4a:	00 00 00 
    p->priority = new_priority;
80103c4d:	89 b3 8c 00 00 00    	mov    %esi,0x8c(%ebx)
}
80103c53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c56:	5b                   	pop    %ebx
80103c57:	5e                   	pop    %esi
80103c58:	5d                   	pop    %ebp
80103c59:	c3                   	ret    
80103c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            enqueue_process(p, LOTTERY);
80103c60:	a1 04 b0 10 80       	mov    0x8010b004,%eax
    switch (new_priority) {
80103c65:	83 fe 04             	cmp    $0x4,%esi
80103c68:	74 b6                	je     80103c20 <change_prio+0x60>
}
80103c6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return -1;
80103c6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103c72:	5b                   	pop    %ebx
80103c73:	5e                   	pop    %esi
80103c74:	5d                   	pop    %ebp
80103c75:	c3                   	ret    
80103c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi
        q->head = p;
80103c80:	89 59 04             	mov    %ebx,0x4(%ecx)
        q->tail = p;
80103c83:	eb b2                	jmp    80103c37 <change_prio+0x77>
80103c85:	8d 76 00             	lea    0x0(%esi),%esi
            enqueue_process(p, FIFO);
80103c88:	a1 24 2d 11 80       	mov    0x80112d24,%eax
    if (q->tail == NULL) {
80103c8d:	eb 91                	jmp    80103c20 <change_prio+0x60>
80103c8f:	90                   	nop
            enqueue_process(p, SJF);
80103c90:	a1 08 b0 10 80       	mov    0x8010b008,%eax
    if (q->tail == NULL) {
80103c95:	eb 89                	jmp    80103c20 <change_prio+0x60>
80103c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c9e:	66 90                	xchg   %ax,%ax

80103ca0 <aging_priority_1>:
aging_priority_1(void) {
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	53                   	push   %ebx
80103ca4:	83 ec 04             	sub    $0x4,%esp
    for (p = q->head; p != NULL; p = p->next) {
80103ca7:	a1 24 2d 11 80       	mov    0x80112d24,%eax
80103cac:	8d 04 40             	lea    (%eax,%eax,2),%eax
80103caf:	8b 1c 85 44 2d 11 80 	mov    -0x7feed2bc(,%eax,4),%ebx
80103cb6:	85 db                	test   %ebx,%ebx
80103cb8:	75 10                	jne    80103cca <aging_priority_1+0x2a>
80103cba:	eb 38                	jmp    80103cf4 <aging_priority_1+0x54>
80103cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cc0:	8b 9b 80 00 00 00    	mov    0x80(%ebx),%ebx
80103cc6:	85 db                	test   %ebx,%ebx
80103cc8:	74 2a                	je     80103cf4 <aging_priority_1+0x54>
        if (ticks - p->ctime > TO2) {
80103cca:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80103ccf:	2b 43 04             	sub    0x4(%ebx),%eax
80103cd2:	3d c8 00 00 00       	cmp    $0xc8,%eax
80103cd7:	76 e7                	jbe    80103cc0 <aging_priority_1+0x20>
          change_prio(ROUND_ROBIN);
80103cd9:	83 ec 0c             	sub    $0xc,%esp
80103cdc:	ff 35 0c b0 10 80    	push   0x8010b00c
80103ce2:	e8 d9 fe ff ff       	call   80103bc0 <change_prio>
    for (p = q->head; p != NULL; p = p->next) {
80103ce7:	8b 9b 80 00 00 00    	mov    0x80(%ebx),%ebx
          change_prio(ROUND_ROBIN);
80103ced:	83 c4 10             	add    $0x10,%esp
    for (p = q->head; p != NULL; p = p->next) {
80103cf0:	85 db                	test   %ebx,%ebx
80103cf2:	75 d6                	jne    80103cca <aging_priority_1+0x2a>
}
80103cf4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cf7:	c9                   	leave  
80103cf8:	c3                   	ret    
80103cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d00 <aging_priority_2>:
aging_priority_2(void) {
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	53                   	push   %ebx
80103d04:	83 ec 04             	sub    $0x4,%esp
    for (p = q->head; p != NULL; p = p->next) {
80103d07:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
80103d0c:	8d 04 40             	lea    (%eax,%eax,2),%eax
80103d0f:	8b 1c 85 44 2d 11 80 	mov    -0x7feed2bc(,%eax,4),%ebx
80103d16:	85 db                	test   %ebx,%ebx
80103d18:	75 10                	jne    80103d2a <aging_priority_2+0x2a>
80103d1a:	eb 36                	jmp    80103d52 <aging_priority_2+0x52>
80103d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d20:	8b 9b 80 00 00 00    	mov    0x80(%ebx),%ebx
80103d26:	85 db                	test   %ebx,%ebx
80103d28:	74 28                	je     80103d52 <aging_priority_2+0x52>
        if (ticks - p->ctime > TO3) {
80103d2a:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80103d2f:	2b 43 04             	sub    0x4(%ebx),%eax
80103d32:	83 f8 64             	cmp    $0x64,%eax
80103d35:	76 e9                	jbe    80103d20 <aging_priority_2+0x20>
          change_prio(SJF);
80103d37:	83 ec 0c             	sub    $0xc,%esp
80103d3a:	ff 35 08 b0 10 80    	push   0x8010b008
80103d40:	e8 7b fe ff ff       	call   80103bc0 <change_prio>
    for (p = q->head; p != NULL; p = p->next) {
80103d45:	8b 9b 80 00 00 00    	mov    0x80(%ebx),%ebx
          change_prio(SJF);
80103d4b:	83 c4 10             	add    $0x10,%esp
    for (p = q->head; p != NULL; p = p->next) {
80103d4e:	85 db                	test   %ebx,%ebx
80103d50:	75 d8                	jne    80103d2a <aging_priority_2+0x2a>
}
80103d52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d55:	c9                   	leave  
80103d56:	c3                   	ret    
80103d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d5e:	66 90                	xchg   %ax,%ax

80103d60 <myproc>:
myproc(void) {
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	53                   	push   %ebx
80103d64:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103d67:	e8 c4 0e 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80103d6c:	e8 cf fd ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80103d71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d77:	e8 04 0f 00 00       	call   80104c80 <popcli>
}
80103d7c:	89 d8                	mov    %ebx,%eax
80103d7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d81:	c9                   	leave  
80103d82:	c3                   	ret    
80103d83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d90 <userinit>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	53                   	push   %ebx
80103d94:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103d97:	e8 e4 f9 ff ff       	call   80103780 <allocproc>
80103d9c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103d9e:	a3 b4 54 11 80       	mov    %eax,0x801154b4
  if((p->pgdir = setupkvm()) == 0)
80103da3:	e8 d8 38 00 00       	call   80107680 <setupkvm>
80103da8:	89 43 08             	mov    %eax,0x8(%ebx)
80103dab:	85 c0                	test   %eax,%eax
80103dad:	0f 84 bd 00 00 00    	je     80103e70 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103db3:	83 ec 04             	sub    $0x4,%esp
80103db6:	68 2c 00 00 00       	push   $0x2c
80103dbb:	68 60 b4 10 80       	push   $0x8010b460
80103dc0:	50                   	push   %eax
80103dc1:	e8 6a 35 00 00       	call   80107330 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103dc6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103dc9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103dcf:	6a 4c                	push   $0x4c
80103dd1:	6a 00                	push   $0x0
80103dd3:	ff 73 1c             	push   0x1c(%ebx)
80103dd6:	e8 65 10 00 00       	call   80104e40 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ddb:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103dde:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103de3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103de6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103deb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103def:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103df2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103df6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103df9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103dfd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103e01:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103e08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103e0c:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103e16:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103e20:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103e23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e2a:	8d 43 70             	lea    0x70(%ebx),%eax
80103e2d:	6a 10                	push   $0x10
80103e2f:	68 60 7f 10 80       	push   $0x80107f60
80103e34:	50                   	push   %eax
80103e35:	e8 c6 11 00 00       	call   80105000 <safestrcpy>
  p->cwd = namei("/");
80103e3a:	c7 04 24 69 7f 10 80 	movl   $0x80107f69,(%esp)
80103e41:	e8 5a e2 ff ff       	call   801020a0 <namei>
80103e46:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
80103e49:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103e50:	e8 2b 0f 00 00       	call   80104d80 <acquire>
  p->state = RUNNABLE;
80103e55:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
80103e5c:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103e63:	e8 b8 0e 00 00       	call   80104d20 <release>
}
80103e68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e6b:	83 c4 10             	add    $0x10,%esp
80103e6e:	c9                   	leave  
80103e6f:	c3                   	ret    
    panic("userinit: out of memory?");
80103e70:	83 ec 0c             	sub    $0xc,%esp
80103e73:	68 47 7f 10 80       	push   $0x80107f47
80103e78:	e8 03 c5 ff ff       	call   80100380 <panic>
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi

80103e80 <growproc>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	56                   	push   %esi
80103e84:	53                   	push   %ebx
80103e85:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103e88:	e8 a3 0d 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80103e8d:	e8 ae fc ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80103e92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e98:	e8 e3 0d 00 00       	call   80104c80 <popcli>
  sz = curproc->sz;
80103e9d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103e9f:	85 f6                	test   %esi,%esi
80103ea1:	7f 1d                	jg     80103ec0 <growproc+0x40>
  } else if(n < 0){
80103ea3:	75 3b                	jne    80103ee0 <growproc+0x60>
  switchuvm(curproc);
80103ea5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ea8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103eaa:	53                   	push   %ebx
80103eab:	e8 70 33 00 00       	call   80107220 <switchuvm>
  return 0;
80103eb0:	83 c4 10             	add    $0x10,%esp
80103eb3:	31 c0                	xor    %eax,%eax
}
80103eb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103eb8:	5b                   	pop    %ebx
80103eb9:	5e                   	pop    %esi
80103eba:	5d                   	pop    %ebp
80103ebb:	c3                   	ret    
80103ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ec0:	83 ec 04             	sub    $0x4,%esp
80103ec3:	01 c6                	add    %eax,%esi
80103ec5:	56                   	push   %esi
80103ec6:	50                   	push   %eax
80103ec7:	ff 73 08             	push   0x8(%ebx)
80103eca:	e8 d1 35 00 00       	call   801074a0 <allocuvm>
80103ecf:	83 c4 10             	add    $0x10,%esp
80103ed2:	85 c0                	test   %eax,%eax
80103ed4:	75 cf                	jne    80103ea5 <growproc+0x25>
      return -1;
80103ed6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103edb:	eb d8                	jmp    80103eb5 <growproc+0x35>
80103edd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ee0:	83 ec 04             	sub    $0x4,%esp
80103ee3:	01 c6                	add    %eax,%esi
80103ee5:	56                   	push   %esi
80103ee6:	50                   	push   %eax
80103ee7:	ff 73 08             	push   0x8(%ebx)
80103eea:	e8 e1 36 00 00       	call   801075d0 <deallocuvm>
80103eef:	83 c4 10             	add    $0x10,%esp
80103ef2:	85 c0                	test   %eax,%eax
80103ef4:	75 af                	jne    80103ea5 <growproc+0x25>
80103ef6:	eb de                	jmp    80103ed6 <growproc+0x56>
80103ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eff:	90                   	nop

80103f00 <fork>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	57                   	push   %edi
80103f04:	56                   	push   %esi
80103f05:	53                   	push   %ebx
80103f06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103f09:	e8 22 0d 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80103f0e:	e8 2d fc ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80103f13:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103f19:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  popcli();
80103f1c:	e8 5f 0d 00 00       	call   80104c80 <popcli>
  if((np = allocproc()) == 0){
80103f21:	e8 5a f8 ff ff       	call   80103780 <allocproc>
80103f26:	85 c0                	test   %eax,%eax
80103f28:	0f 84 1f 01 00 00    	je     8010404d <fork+0x14d>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103f2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f31:	83 ec 08             	sub    $0x8,%esp
80103f34:	89 c3                	mov    %eax,%ebx
80103f36:	ff 32                	push   (%edx)
80103f38:	ff 72 08             	push   0x8(%edx)
80103f3b:	e8 30 38 00 00       	call   80107770 <copyuvm>
80103f40:	83 c4 10             	add    $0x10,%esp
80103f43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f46:	85 c0                	test   %eax,%eax
80103f48:	89 43 08             	mov    %eax,0x8(%ebx)
80103f4b:	0f 84 03 01 00 00    	je     80104054 <fork+0x154>
  np->sz = curproc->sz;
80103f51:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80103f53:	8b 7b 1c             	mov    0x1c(%ebx),%edi
  np->parent = curproc;
80103f56:	89 53 18             	mov    %edx,0x18(%ebx)
  *np->tf = *curproc->tf;
80103f59:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103f5e:	89 03                	mov    %eax,(%ebx)
  *np->tf = *curproc->tf;
80103f60:	8b 72 1c             	mov    0x1c(%edx),%esi
80103f63:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103f65:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103f67:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103f6a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103f78:	8b 44 b2 2c          	mov    0x2c(%edx,%esi,4),%eax
80103f7c:	85 c0                	test   %eax,%eax
80103f7e:	74 16                	je     80103f96 <fork+0x96>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f80:	83 ec 0c             	sub    $0xc,%esp
80103f83:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103f86:	50                   	push   %eax
80103f87:	e8 14 cf ff ff       	call   80100ea0 <filedup>
80103f8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103f8f:	83 c4 10             	add    $0x10,%esp
80103f92:	89 44 b3 2c          	mov    %eax,0x2c(%ebx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103f96:	83 c6 01             	add    $0x1,%esi
80103f99:	83 fe 10             	cmp    $0x10,%esi
80103f9c:	75 da                	jne    80103f78 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103f9e:	83 ec 0c             	sub    $0xc,%esp
80103fa1:	ff 72 6c             	push   0x6c(%edx)
80103fa4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103fa7:	e8 a4 d7 ff ff       	call   80101750 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103fac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103faf:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103fb2:	89 43 6c             	mov    %eax,0x6c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103fb5:	8d 43 70             	lea    0x70(%ebx),%eax
80103fb8:	83 c2 70             	add    $0x70,%edx
80103fbb:	6a 10                	push   $0x10
80103fbd:	52                   	push   %edx
80103fbe:	50                   	push   %eax
80103fbf:	e8 3c 10 00 00       	call   80105000 <safestrcpy>
  pid = np->pid;
80103fc4:	8b 73 14             	mov    0x14(%ebx),%esi
  acquire(&ptable.lock);
80103fc7:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103fce:	e8 ad 0d 00 00       	call   80104d80 <acquire>
  np->ctime = ticks;
80103fd3:	a1 c0 54 11 80       	mov    0x801154c0,%eax
  np->state = RUNNABLE;
80103fd8:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
    if (q->tail == NULL) {
80103fdf:	83 c4 10             	add    $0x10,%esp
  np->tickets = 5;
80103fe2:	c7 83 88 00 00 00 05 	movl   $0x5,0x88(%ebx)
80103fe9:	00 00 00 
  np->ctime = ticks;
80103fec:	89 43 04             	mov    %eax,0x4(%ebx)
  enqueue_process(np, ROUND_ROBIN);
80103fef:	a1 0c b0 10 80       	mov    0x8010b00c,%eax
  np->priority = 2;
80103ff4:	c7 83 8c 00 00 00 02 	movl   $0x2,0x8c(%ebx)
80103ffb:	00 00 00 
    if (q->tail == NULL) {
80103ffe:	8d 14 40             	lea    (%eax,%eax,2),%edx
80104001:	8d 0c 95 40 2d 11 80 	lea    -0x7feed2c0(,%edx,4),%ecx
80104008:	8b 51 08             	mov    0x8(%ecx),%edx
8010400b:	85 d2                	test   %edx,%edx
8010400d:	74 39                	je     80104048 <fork+0x148>
        q->tail->next = p;
8010400f:	89 9a 80 00 00 00    	mov    %ebx,0x80(%edx)
    p->next = NULL;
80104015:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
8010401c:	00 00 00 
  release(&ptable.lock);
8010401f:	83 ec 0c             	sub    $0xc,%esp
        q->tail = p;
80104022:	8d 04 40             	lea    (%eax,%eax,2),%eax
  release(&ptable.lock);
80104025:	68 80 2d 11 80       	push   $0x80112d80
        q->tail = p;
8010402a:	89 1c 85 48 2d 11 80 	mov    %ebx,-0x7feed2b8(,%eax,4)
  release(&ptable.lock);
80104031:	e8 ea 0c 00 00       	call   80104d20 <release>
  return pid;
80104036:	83 c4 10             	add    $0x10,%esp
}
80104039:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010403c:	89 f0                	mov    %esi,%eax
8010403e:	5b                   	pop    %ebx
8010403f:	5e                   	pop    %esi
80104040:	5f                   	pop    %edi
80104041:	5d                   	pop    %ebp
80104042:	c3                   	ret    
80104043:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104047:	90                   	nop
        q->head = p;
80104048:	89 59 04             	mov    %ebx,0x4(%ecx)
        q->tail = p;
8010404b:	eb c8                	jmp    80104015 <fork+0x115>
    return -1;
8010404d:	be ff ff ff ff       	mov    $0xffffffff,%esi
80104052:	eb e5                	jmp    80104039 <fork+0x139>
    kfree(np->kstack);
80104054:	83 ec 0c             	sub    $0xc,%esp
80104057:	ff 73 0c             	push   0xc(%ebx)
    return -1;
8010405a:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
8010405f:	e8 5c e4 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80104064:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010406b:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010406e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return -1;
80104075:	eb c2                	jmp    80104039 <fork+0x139>
80104077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010407e:	66 90                	xchg   %ax,%ax

80104080 <scheduler>:
scheduler(void) {
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
80104086:	83 ec 1c             	sub    $0x1c,%esp
    struct cpu *c = mycpu();
80104089:	e8 b2 fa ff ff       	call   80103b40 <mycpu>
    c->proc = 0;
8010408e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104095:	00 00 00 
    struct cpu *c = mycpu();
80104098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        swtch(&(c->scheduler), p->context);
8010409b:	83 c0 04             	add    $0x4,%eax
8010409e:	89 45 e0             	mov    %eax,-0x20(%ebp)
801040a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        for (priority = NQUEUES; priority > 0; priority--) {
801040a8:	8b 15 10 b0 10 80    	mov    0x8010b010,%edx
        if (priority == ALL_EMPTY) {
801040ae:	8b 0d 28 2d 11 80    	mov    0x80112d28,%ecx
    for (p = queues[priority].head; p != NULL; p = p->next) {
801040b4:	8b 3d 5c 2d 11 80    	mov    0x80112d5c,%edi
    if (q->head == NULL) {
801040ba:	8b 35 44 2d 11 80    	mov    0x80112d44,%esi
        for (priority = NQUEUES; priority > 0; priority--) {
801040c0:	89 d3                	mov    %edx,%ebx
801040c2:	85 d2                	test   %edx,%edx
801040c4:	7f 13                	jg     801040d9 <scheduler+0x59>
801040c6:	eb 1f                	jmp    801040e7 <scheduler+0x67>
801040c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040cf:	90                   	nop
801040d0:	83 eb 01             	sub    $0x1,%ebx
801040d3:	0f 84 c7 00 00 00    	je     801041a0 <scheduler+0x120>
            if (queues[priority].head != NULL)
801040d9:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
801040dc:	8b 04 85 44 2d 11 80 	mov    -0x7feed2bc(,%eax,4),%eax
801040e3:	85 c0                	test   %eax,%eax
801040e5:	74 e9                	je     801040d0 <scheduler+0x50>
        if (priority == ALL_EMPTY) {
801040e7:	39 d9                	cmp    %ebx,%ecx
801040e9:	74 d5                	je     801040c0 <scheduler+0x40>
        switch (priority) {
801040eb:	83 fb 02             	cmp    $0x2,%ebx
801040ee:	0f 84 44 01 00 00    	je     80104238 <scheduler+0x1b8>
801040f4:	0f 8e de 00 00 00    	jle    801041d8 <scheduler+0x158>
801040fa:	83 fb 03             	cmp    $0x3,%ebx
801040fd:	75 c1                	jne    801040c0 <scheduler+0x40>
801040ff:	89 55 d8             	mov    %edx,-0x28(%ebp)
80104102:	89 4d dc             	mov    %ecx,-0x24(%ebp)
                p = get_lottery_winner();
80104105:	e8 16 f9 ff ff       	call   80103a20 <get_lottery_winner>
        if (p == NULL) {
8010410a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
8010410d:	8b 55 d8             	mov    -0x28(%ebp),%edx
80104110:	85 c0                	test   %eax,%eax
80104112:	74 ac                	je     801040c0 <scheduler+0x40>
80104114:	89 c6                	mov    %eax,%esi
80104116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411d:	8d 76 00             	lea    0x0(%esi),%esi
        c->proc = p;
80104120:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        switchuvm(p);
80104123:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80104126:	89 b0 ac 00 00 00    	mov    %esi,0xac(%eax)
        switchuvm(p);
8010412c:	56                   	push   %esi
8010412d:	e8 ee 30 00 00       	call   80107220 <switchuvm>
        p->state = RUNNING;
80104132:	c7 46 10 04 00 00 00 	movl   $0x4,0x10(%esi)
        swtch(&(c->scheduler), p->context);
80104139:	58                   	pop    %eax
8010413a:	5a                   	pop    %edx
8010413b:	ff 76 20             	push   0x20(%esi)
8010413e:	ff 75 e0             	push   -0x20(%ebp)
80104141:	e8 15 0f 00 00       	call   8010505b <swtch>
        switchkvm();
80104146:	e8 c5 30 00 00       	call   80107210 <switchkvm>
        if(priority == ROUND_ROBIN && p->rtime >= TIME_SLICE){
8010414b:	83 c4 10             	add    $0x10,%esp
8010414e:	39 1d 0c b0 10 80    	cmp    %ebx,0x8010b00c
80104154:	0f 84 06 01 00 00    	je     80104260 <scheduler+0x1e0>
        if (p->state == RUNNABLE) {
8010415a:	83 7e 10 03          	cmpl   $0x3,0x10(%esi)
8010415e:	0f 85 44 ff ff ff    	jne    801040a8 <scheduler+0x28>
    if (q->tail == NULL) {
80104164:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
80104167:	8d 14 85 40 2d 11 80 	lea    -0x7feed2c0(,%eax,4),%edx
8010416e:	8b 42 08             	mov    0x8(%edx),%eax
80104171:	85 c0                	test   %eax,%eax
80104173:	0f 84 29 01 00 00    	je     801042a2 <scheduler+0x222>
        q->tail->next = p;
80104179:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
    p->next = NULL;
8010417f:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
80104186:	00 00 00 
        q->tail = p;
80104189:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
8010418c:	89 34 85 48 2d 11 80 	mov    %esi,-0x7feed2b8(,%eax,4)
}
80104193:	e9 10 ff ff ff       	jmp    801040a8 <scheduler+0x28>
80104198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419f:	90                   	nop
        if (priority == ALL_EMPTY) {
801041a0:	85 c9                	test   %ecx,%ecx
801041a2:	0f 84 18 ff ff ff    	je     801040c0 <scheduler+0x40>
    if (q->head == NULL) {
801041a8:	85 f6                	test   %esi,%esi
801041aa:	0f 84 10 ff ff ff    	je     801040c0 <scheduler+0x40>
    q->head = q->head->next;
801041b0:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
801041b6:	31 db                	xor    %ebx,%ebx
801041b8:	a3 44 2d 11 80       	mov    %eax,0x80112d44
    if (q->head == NULL) {
801041bd:	85 c0                	test   %eax,%eax
801041bf:	0f 85 5b ff ff ff    	jne    80104120 <scheduler+0xa0>
        q->tail = NULL;
801041c5:	c7 05 48 2d 11 80 00 	movl   $0x0,0x80112d48
801041cc:	00 00 00 
801041cf:	e9 4c ff ff ff       	jmp    80104120 <scheduler+0xa0>
801041d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        switch (priority) {
801041d8:	85 db                	test   %ebx,%ebx
801041da:	74 cc                	je     801041a8 <scheduler+0x128>
801041dc:	83 fb 01             	cmp    $0x1,%ebx
801041df:	0f 85 db fe ff ff    	jne    801040c0 <scheduler+0x40>
    if (current_proc == NULL || current_proc->rtime >= TIME_SLICE) {
801041e5:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
801041eb:	85 f6                	test   %esi,%esi
801041ed:	74 0d                	je     801041fc <scheduler+0x17c>
801041ef:	83 be 84 00 00 00 09 	cmpl   $0x9,0x84(%esi)
801041f6:	0f 8e 24 ff ff ff    	jle    80104120 <scheduler+0xa0>
    if (q->head == NULL) {
801041fc:	8b 35 50 2d 11 80    	mov    0x80112d50,%esi
80104202:	85 f6                	test   %esi,%esi
80104204:	0f 84 5c 08 00 00    	je     80104a66 <scheduler.cold>
    q->head = q->head->next;
8010420a:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80104210:	a3 50 2d 11 80       	mov    %eax,0x80112d50
    if (q->head == NULL) {
80104215:	85 c0                	test   %eax,%eax
80104217:	0f 84 8d 00 00 00    	je     801042aa <scheduler+0x22a>
        current_proc = dequeue_process(priority);
8010421d:	89 35 20 2d 11 80    	mov    %esi,0x80112d20
        current_proc->rtime = 0;
80104223:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
8010422a:	00 00 00 
8010422d:	e9 ee fe ff ff       	jmp    80104120 <scheduler+0xa0>
80104232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for (p = queues[priority].head; p != NULL; p = p->next) {
80104238:	85 ff                	test   %edi,%edi
8010423a:	0f 84 80 fe ff ff    	je     801040c0 <scheduler+0x40>
80104240:	89 fe                	mov    %edi,%esi
80104242:	eb 0d                	jmp    80104251 <scheduler+0x1d1>
80104244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (shortest_job == NULL || p->ctime < shortest_job->ctime) {
80104248:	8b 46 04             	mov    0x4(%esi),%eax
8010424b:	39 47 04             	cmp    %eax,0x4(%edi)
8010424e:	0f 42 f7             	cmovb  %edi,%esi
    for (p = queues[priority].head; p != NULL; p = p->next) {
80104251:	8b bf 80 00 00 00    	mov    0x80(%edi),%edi
80104257:	85 ff                	test   %edi,%edi
80104259:	75 ed                	jne    80104248 <scheduler+0x1c8>
8010425b:	e9 c0 fe ff ff       	jmp    80104120 <scheduler+0xa0>
        if(priority == ROUND_ROBIN && p->rtime >= TIME_SLICE){
80104260:	83 be 84 00 00 00 09 	cmpl   $0x9,0x84(%esi)
80104267:	0f 8e ed fe ff ff    	jle    8010415a <scheduler+0xda>
    if (q->tail == NULL) {
8010426d:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
          enqueue_process(p, (priority--));
80104270:	8d 4b ff             	lea    -0x1(%ebx),%ecx
    if (q->tail == NULL) {
80104273:	8d 14 85 40 2d 11 80 	lea    -0x7feed2c0(,%eax,4),%edx
8010427a:	8b 42 08             	mov    0x8(%edx),%eax
8010427d:	85 c0                	test   %eax,%eax
8010427f:	74 38                	je     801042b9 <scheduler+0x239>
        q->tail->next = p;
80104281:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
    p->next = NULL;
80104287:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
8010428e:	00 00 00 
        q->tail = p;
80104291:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
          enqueue_process(p, (priority--));
80104294:	89 cb                	mov    %ecx,%ebx
        q->tail = p;
80104296:	89 34 85 48 2d 11 80 	mov    %esi,-0x7feed2b8(,%eax,4)
}
8010429d:	e9 b8 fe ff ff       	jmp    8010415a <scheduler+0xda>
        q->head = p;
801042a2:	89 72 04             	mov    %esi,0x4(%edx)
        q->tail = p;
801042a5:	e9 d5 fe ff ff       	jmp    8010417f <scheduler+0xff>
        q->tail = NULL;
801042aa:	c7 05 54 2d 11 80 00 	movl   $0x0,0x80112d54
801042b1:	00 00 00 
801042b4:	e9 64 ff ff ff       	jmp    8010421d <scheduler+0x19d>
        q->head = p;
801042b9:	89 72 04             	mov    %esi,0x4(%edx)
        q->tail = p;
801042bc:	eb c9                	jmp    80104287 <scheduler+0x207>
801042be:	66 90                	xchg   %ax,%ax

801042c0 <sched>:
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	56                   	push   %esi
801042c4:	53                   	push   %ebx
  pushcli();
801042c5:	e8 66 09 00 00       	call   80104c30 <pushcli>
  c = mycpu();
801042ca:	e8 71 f8 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
801042cf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042d5:	e8 a6 09 00 00       	call   80104c80 <popcli>
  if(!holding(&ptable.lock))
801042da:	83 ec 0c             	sub    $0xc,%esp
801042dd:	68 80 2d 11 80       	push   $0x80112d80
801042e2:	e8 f9 09 00 00       	call   80104ce0 <holding>
801042e7:	83 c4 10             	add    $0x10,%esp
801042ea:	85 c0                	test   %eax,%eax
801042ec:	74 4f                	je     8010433d <sched+0x7d>
  if(mycpu()->ncli != 1)
801042ee:	e8 4d f8 ff ff       	call   80103b40 <mycpu>
801042f3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801042fa:	75 68                	jne    80104364 <sched+0xa4>
  if(p->state == RUNNING)
801042fc:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80104300:	74 55                	je     80104357 <sched+0x97>
80104302:	9c                   	pushf  
80104303:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104304:	f6 c4 02             	test   $0x2,%ah
80104307:	75 41                	jne    8010434a <sched+0x8a>
  intena = mycpu()->intena;
80104309:	e8 32 f8 ff ff       	call   80103b40 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010430e:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80104311:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104317:	e8 24 f8 ff ff       	call   80103b40 <mycpu>
8010431c:	83 ec 08             	sub    $0x8,%esp
8010431f:	ff 70 04             	push   0x4(%eax)
80104322:	53                   	push   %ebx
80104323:	e8 33 0d 00 00       	call   8010505b <swtch>
  mycpu()->intena = intena;
80104328:	e8 13 f8 ff ff       	call   80103b40 <mycpu>
}
8010432d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104330:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104336:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104339:	5b                   	pop    %ebx
8010433a:	5e                   	pop    %esi
8010433b:	5d                   	pop    %ebp
8010433c:	c3                   	ret    
    panic("sched ptable.lock");
8010433d:	83 ec 0c             	sub    $0xc,%esp
80104340:	68 6b 7f 10 80       	push   $0x80107f6b
80104345:	e8 36 c0 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010434a:	83 ec 0c             	sub    $0xc,%esp
8010434d:	68 97 7f 10 80       	push   $0x80107f97
80104352:	e8 29 c0 ff ff       	call   80100380 <panic>
    panic("sched running");
80104357:	83 ec 0c             	sub    $0xc,%esp
8010435a:	68 89 7f 10 80       	push   $0x80107f89
8010435f:	e8 1c c0 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104364:	83 ec 0c             	sub    $0xc,%esp
80104367:	68 7d 7f 10 80       	push   $0x80107f7d
8010436c:	e8 0f c0 ff ff       	call   80100380 <panic>
80104371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437f:	90                   	nop

80104380 <exit>:
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	57                   	push   %edi
80104384:	56                   	push   %esi
80104385:	53                   	push   %ebx
80104386:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104389:	e8 d2 f9 ff ff       	call   80103d60 <myproc>
  if(curproc == initproc)
8010438e:	39 05 b4 54 11 80    	cmp    %eax,0x801154b4
80104394:	0f 84 07 01 00 00    	je     801044a1 <exit+0x121>
8010439a:	89 c3                	mov    %eax,%ebx
8010439c:	8d 70 2c             	lea    0x2c(%eax),%esi
8010439f:	8d 78 6c             	lea    0x6c(%eax),%edi
801043a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801043a8:	8b 06                	mov    (%esi),%eax
801043aa:	85 c0                	test   %eax,%eax
801043ac:	74 12                	je     801043c0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801043ae:	83 ec 0c             	sub    $0xc,%esp
801043b1:	50                   	push   %eax
801043b2:	e8 39 cb ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
801043b7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801043bd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801043c0:	83 c6 04             	add    $0x4,%esi
801043c3:	39 f7                	cmp    %esi,%edi
801043c5:	75 e1                	jne    801043a8 <exit+0x28>
  begin_op();
801043c7:	e8 74 e9 ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
801043cc:	83 ec 0c             	sub    $0xc,%esp
801043cf:	ff 73 6c             	push   0x6c(%ebx)
801043d2:	e8 d9 d4 ff ff       	call   801018b0 <iput>
  end_op();
801043d7:	e8 d4 e9 ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
801043dc:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
801043e3:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
801043ea:	e8 91 09 00 00       	call   80104d80 <acquire>
  wakeup1(curproc->parent);
801043ef:	8b 53 18             	mov    0x18(%ebx),%edx
801043f2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043f5:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
801043fa:	eb 10                	jmp    8010440c <exit+0x8c>
801043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104400:	05 9c 00 00 00       	add    $0x9c,%eax
80104405:	3d b4 54 11 80       	cmp    $0x801154b4,%eax
8010440a:	74 1e                	je     8010442a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
8010440c:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80104410:	75 ee                	jne    80104400 <exit+0x80>
80104412:	3b 50 24             	cmp    0x24(%eax),%edx
80104415:	75 e9                	jne    80104400 <exit+0x80>
      p->state = RUNNABLE;
80104417:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010441e:	05 9c 00 00 00       	add    $0x9c,%eax
80104423:	3d b4 54 11 80       	cmp    $0x801154b4,%eax
80104428:	75 e2                	jne    8010440c <exit+0x8c>
      p->parent = initproc;
8010442a:	8b 0d b4 54 11 80    	mov    0x801154b4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104430:	ba b4 2d 11 80       	mov    $0x80112db4,%edx
80104435:	eb 17                	jmp    8010444e <exit+0xce>
80104437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010443e:	66 90                	xchg   %ax,%ax
80104440:	81 c2 9c 00 00 00    	add    $0x9c,%edx
80104446:	81 fa b4 54 11 80    	cmp    $0x801154b4,%edx
8010444c:	74 3a                	je     80104488 <exit+0x108>
    if(p->parent == curproc){
8010444e:	39 5a 18             	cmp    %ebx,0x18(%edx)
80104451:	75 ed                	jne    80104440 <exit+0xc0>
      if(p->state == ZOMBIE)
80104453:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
      p->parent = initproc;
80104457:	89 4a 18             	mov    %ecx,0x18(%edx)
      if(p->state == ZOMBIE)
8010445a:	75 e4                	jne    80104440 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010445c:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
80104461:	eb 11                	jmp    80104474 <exit+0xf4>
80104463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104467:	90                   	nop
80104468:	05 9c 00 00 00       	add    $0x9c,%eax
8010446d:	3d b4 54 11 80       	cmp    $0x801154b4,%eax
80104472:	74 cc                	je     80104440 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104474:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80104478:	75 ee                	jne    80104468 <exit+0xe8>
8010447a:	3b 48 24             	cmp    0x24(%eax),%ecx
8010447d:	75 e9                	jne    80104468 <exit+0xe8>
      p->state = RUNNABLE;
8010447f:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
80104486:	eb e0                	jmp    80104468 <exit+0xe8>
  curproc->state = ZOMBIE;
80104488:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
8010448f:	e8 2c fe ff ff       	call   801042c0 <sched>
  panic("zombie exit");
80104494:	83 ec 0c             	sub    $0xc,%esp
80104497:	68 b8 7f 10 80       	push   $0x80107fb8
8010449c:	e8 df be ff ff       	call   80100380 <panic>
    panic("init exiting");
801044a1:	83 ec 0c             	sub    $0xc,%esp
801044a4:	68 ab 7f 10 80       	push   $0x80107fab
801044a9:	e8 d2 be ff ff       	call   80100380 <panic>
801044ae:	66 90                	xchg   %ax,%ax

801044b0 <wait>:
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
  pushcli();
801044b5:	e8 76 07 00 00       	call   80104c30 <pushcli>
  c = mycpu();
801044ba:	e8 81 f6 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
801044bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044c5:	e8 b6 07 00 00       	call   80104c80 <popcli>
  acquire(&ptable.lock);
801044ca:	83 ec 0c             	sub    $0xc,%esp
801044cd:	68 80 2d 11 80       	push   $0x80112d80
801044d2:	e8 a9 08 00 00       	call   80104d80 <acquire>
801044d7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801044da:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044dc:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
801044e1:	eb 13                	jmp    801044f6 <wait+0x46>
801044e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e7:	90                   	nop
801044e8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801044ee:	81 fb b4 54 11 80    	cmp    $0x801154b4,%ebx
801044f4:	74 1e                	je     80104514 <wait+0x64>
      if(p->parent != curproc)
801044f6:	39 73 18             	cmp    %esi,0x18(%ebx)
801044f9:	75 ed                	jne    801044e8 <wait+0x38>
      if(p->state == ZOMBIE){
801044fb:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
801044ff:	74 5f                	je     80104560 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104501:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
      havekids = 1;
80104507:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010450c:	81 fb b4 54 11 80    	cmp    $0x801154b4,%ebx
80104512:	75 e2                	jne    801044f6 <wait+0x46>
    if(!havekids || curproc->killed){
80104514:	85 c0                	test   %eax,%eax
80104516:	0f 84 9a 00 00 00    	je     801045b6 <wait+0x106>
8010451c:	8b 46 28             	mov    0x28(%esi),%eax
8010451f:	85 c0                	test   %eax,%eax
80104521:	0f 85 8f 00 00 00    	jne    801045b6 <wait+0x106>
  pushcli();
80104527:	e8 04 07 00 00       	call   80104c30 <pushcli>
  c = mycpu();
8010452c:	e8 0f f6 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80104531:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104537:	e8 44 07 00 00       	call   80104c80 <popcli>
  if(p == 0)
8010453c:	85 db                	test   %ebx,%ebx
8010453e:	0f 84 89 00 00 00    	je     801045cd <wait+0x11d>
  p->chan = chan;
80104544:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
80104547:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
8010454e:	e8 6d fd ff ff       	call   801042c0 <sched>
  p->chan = 0;
80104553:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010455a:	e9 7b ff ff ff       	jmp    801044da <wait+0x2a>
8010455f:	90                   	nop
        kfree(p->kstack);
80104560:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104563:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80104566:	ff 73 0c             	push   0xc(%ebx)
80104569:	e8 52 df ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010456e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
80104575:	5a                   	pop    %edx
80104576:	ff 73 08             	push   0x8(%ebx)
80104579:	e8 82 30 00 00       	call   80107600 <freevm>
        p->pid = 0;
8010457e:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80104585:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
8010458c:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80104590:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104597:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
8010459e:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
801045a5:	e8 76 07 00 00       	call   80104d20 <release>
        return pid;
801045aa:	83 c4 10             	add    $0x10,%esp
}
801045ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045b0:	89 f0                	mov    %esi,%eax
801045b2:	5b                   	pop    %ebx
801045b3:	5e                   	pop    %esi
801045b4:	5d                   	pop    %ebp
801045b5:	c3                   	ret    
      release(&ptable.lock);
801045b6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801045b9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801045be:	68 80 2d 11 80       	push   $0x80112d80
801045c3:	e8 58 07 00 00       	call   80104d20 <release>
      return -1;
801045c8:	83 c4 10             	add    $0x10,%esp
801045cb:	eb e0                	jmp    801045ad <wait+0xfd>
    panic("sleep");
801045cd:	83 ec 0c             	sub    $0xc,%esp
801045d0:	68 c4 7f 10 80       	push   $0x80107fc4
801045d5:	e8 a6 bd ff ff       	call   80100380 <panic>
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045e0 <wait2>:
int wait2(int *retime, int *rutime, int *stime) {
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	57                   	push   %edi
801045e4:	56                   	push   %esi
801045e5:	53                   	push   %ebx
801045e6:	83 ec 28             	sub    $0x28,%esp
  acquire(&ptable.lock);
801045e9:	68 80 2d 11 80       	push   $0x80112d80
801045ee:	e8 8d 07 00 00       	call   80104d80 <acquire>
801045f3:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801045f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045fd:	bf b4 2d 11 80       	mov    $0x80112db4,%edi
80104602:	eb 12                	jmp    80104616 <wait2+0x36>
80104604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104608:	81 c7 9c 00 00 00    	add    $0x9c,%edi
8010460e:	81 ff b4 54 11 80    	cmp    $0x801154b4,%edi
80104614:	74 3b                	je     80104651 <wait2+0x71>
      if(p->parent != myproc())
80104616:	8b 77 18             	mov    0x18(%edi),%esi
  pushcli();
80104619:	e8 12 06 00 00       	call   80104c30 <pushcli>
  c = mycpu();
8010461e:	e8 1d f5 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80104623:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104629:	e8 52 06 00 00       	call   80104c80 <popcli>
      if(p->parent != myproc())
8010462e:	39 de                	cmp    %ebx,%esi
80104630:	75 d6                	jne    80104608 <wait2+0x28>
      if(p->state == ZOMBIE){
80104632:	83 7f 10 05          	cmpl   $0x5,0x10(%edi)
80104636:	0f 84 94 00 00 00    	je     801046d0 <wait2+0xf0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010463c:	81 c7 9c 00 00 00    	add    $0x9c,%edi
      havekids = 1;
80104642:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104649:	81 ff b4 54 11 80    	cmp    $0x801154b4,%edi
8010464f:	75 c5                	jne    80104616 <wait2+0x36>
    if(!havekids || myproc()->killed){
80104651:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104654:	85 d2                	test   %edx,%edx
80104656:	0f 84 1b 01 00 00    	je     80104777 <wait2+0x197>
  pushcli();
8010465c:	e8 cf 05 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80104661:	e8 da f4 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80104666:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010466c:	e8 0f 06 00 00       	call   80104c80 <popcli>
    if(!havekids || myproc()->killed){
80104671:	8b 43 28             	mov    0x28(%ebx),%eax
80104674:	85 c0                	test   %eax,%eax
80104676:	0f 85 fb 00 00 00    	jne    80104777 <wait2+0x197>
  pushcli();
8010467c:	e8 af 05 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80104681:	e8 ba f4 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80104686:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010468c:	e8 ef 05 00 00       	call   80104c80 <popcli>
  pushcli();
80104691:	e8 9a 05 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80104696:	e8 a5 f4 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
8010469b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046a1:	e8 da 05 00 00       	call   80104c80 <popcli>
  if(p == 0)
801046a6:	85 db                	test   %ebx,%ebx
801046a8:	0f 84 e0 00 00 00    	je     8010478e <wait2+0x1ae>
  p->chan = chan;
801046ae:	89 73 24             	mov    %esi,0x24(%ebx)
  p->state = SLEEPING;
801046b1:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
801046b8:	e8 03 fc ff ff       	call   801042c0 <sched>
  p->chan = 0;
801046bd:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
801046c4:	e9 2d ff ff ff       	jmp    801045f6 <wait2+0x16>
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        *retime = p->retime;
801046d0:	8b 8f 94 00 00 00    	mov    0x94(%edi),%ecx
801046d6:	8b 45 08             	mov    0x8(%ebp),%eax
        kfree(p->kstack);
801046d9:	83 ec 0c             	sub    $0xc,%esp
        *retime = p->retime;
801046dc:	89 08                	mov    %ecx,(%eax)
        *rutime = p->rutime;
801046de:	8b 45 0c             	mov    0xc(%ebp),%eax
801046e1:	8b 8f 98 00 00 00    	mov    0x98(%edi),%ecx
801046e7:	89 08                	mov    %ecx,(%eax)
        *stime = p->stime;
801046e9:	8b 45 10             	mov    0x10(%ebp),%eax
801046ec:	8b 8f 90 00 00 00    	mov    0x90(%edi),%ecx
801046f2:	89 08                	mov    %ecx,(%eax)
        pid = p->pid;
801046f4:	8b 5f 14             	mov    0x14(%edi),%ebx
        kfree(p->kstack);
801046f7:	ff 77 0c             	push   0xc(%edi)
801046fa:	e8 c1 dd ff ff       	call   801024c0 <kfree>
        freevm(p->pgdir);
801046ff:	59                   	pop    %ecx
80104700:	ff 77 08             	push   0x8(%edi)
        p->kstack = 0;
80104703:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
        freevm(p->pgdir);
8010470a:	e8 f1 2e 00 00       	call   80107600 <freevm>
        release(&ptable.lock);
8010470f:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
        p->state = UNUSED;
80104716:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
        p->pid = 0;
8010471d:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
        p->parent = 0;
80104724:	c7 47 18 00 00 00 00 	movl   $0x0,0x18(%edi)
        p->name[0] = 0;
8010472b:	c6 47 70 00          	movb   $0x0,0x70(%edi)
        p->killed = 0;
8010472f:	c7 47 28 00 00 00 00 	movl   $0x0,0x28(%edi)
        p->ctime = 0;
80104736:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
        p->retime = 0;
8010473d:	c7 87 94 00 00 00 00 	movl   $0x0,0x94(%edi)
80104744:	00 00 00 
        p->rutime = 0;
80104747:	c7 87 98 00 00 00 00 	movl   $0x0,0x98(%edi)
8010474e:	00 00 00 
        p->stime = 0;
80104751:	c7 87 90 00 00 00 00 	movl   $0x0,0x90(%edi)
80104758:	00 00 00 
        p->priority = 0;
8010475b:	c7 87 8c 00 00 00 00 	movl   $0x0,0x8c(%edi)
80104762:	00 00 00 
        release(&ptable.lock);
80104765:	e8 b6 05 00 00       	call   80104d20 <release>
        return pid;
8010476a:	83 c4 10             	add    $0x10,%esp
}
8010476d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104770:	89 d8                	mov    %ebx,%eax
80104772:	5b                   	pop    %ebx
80104773:	5e                   	pop    %esi
80104774:	5f                   	pop    %edi
80104775:	5d                   	pop    %ebp
80104776:	c3                   	ret    
      release(&ptable.lock);
80104777:	83 ec 0c             	sub    $0xc,%esp
      return -1;
8010477a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&ptable.lock);
8010477f:	68 80 2d 11 80       	push   $0x80112d80
80104784:	e8 97 05 00 00       	call   80104d20 <release>
      return -1;
80104789:	83 c4 10             	add    $0x10,%esp
8010478c:	eb df                	jmp    8010476d <wait2+0x18d>
    panic("sleep");
8010478e:	83 ec 0c             	sub    $0xc,%esp
80104791:	68 c4 7f 10 80       	push   $0x80107fc4
80104796:	e8 e5 bb ff ff       	call   80100380 <panic>
8010479b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010479f:	90                   	nop

801047a0 <yield>:
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801047a7:	68 80 2d 11 80       	push   $0x80112d80
801047ac:	e8 cf 05 00 00       	call   80104d80 <acquire>
  pushcli();
801047b1:	e8 7a 04 00 00       	call   80104c30 <pushcli>
  c = mycpu();
801047b6:	e8 85 f3 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
801047bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047c1:	e8 ba 04 00 00       	call   80104c80 <popcli>
  myproc()->state = RUNNABLE;
801047c6:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  sched();
801047cd:	e8 ee fa ff ff       	call   801042c0 <sched>
  release(&ptable.lock);
801047d2:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
801047d9:	e8 42 05 00 00       	call   80104d20 <release>
}
801047de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047e1:	83 c4 10             	add    $0x10,%esp
801047e4:	c9                   	leave  
801047e5:	c3                   	ret    
801047e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ed:	8d 76 00             	lea    0x0(%esi),%esi

801047f0 <sleep>:
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	57                   	push   %edi
801047f4:	56                   	push   %esi
801047f5:	53                   	push   %ebx
801047f6:	83 ec 0c             	sub    $0xc,%esp
801047f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801047fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801047ff:	e8 2c 04 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80104804:	e8 37 f3 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80104809:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010480f:	e8 6c 04 00 00       	call   80104c80 <popcli>
  if(p == 0)
80104814:	85 db                	test   %ebx,%ebx
80104816:	0f 84 87 00 00 00    	je     801048a3 <sleep+0xb3>
  if(lk == 0)
8010481c:	85 f6                	test   %esi,%esi
8010481e:	74 76                	je     80104896 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104820:	81 fe 80 2d 11 80    	cmp    $0x80112d80,%esi
80104826:	74 50                	je     80104878 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	68 80 2d 11 80       	push   $0x80112d80
80104830:	e8 4b 05 00 00       	call   80104d80 <acquire>
    release(lk);
80104835:	89 34 24             	mov    %esi,(%esp)
80104838:	e8 e3 04 00 00       	call   80104d20 <release>
  p->chan = chan;
8010483d:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80104840:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104847:	e8 74 fa ff ff       	call   801042c0 <sched>
  p->chan = 0;
8010484c:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80104853:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
8010485a:	e8 c1 04 00 00       	call   80104d20 <release>
    acquire(lk);
8010485f:	89 75 08             	mov    %esi,0x8(%ebp)
80104862:	83 c4 10             	add    $0x10,%esp
}
80104865:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104868:	5b                   	pop    %ebx
80104869:	5e                   	pop    %esi
8010486a:	5f                   	pop    %edi
8010486b:	5d                   	pop    %ebp
    acquire(lk);
8010486c:	e9 0f 05 00 00       	jmp    80104d80 <acquire>
80104871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104878:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
8010487b:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80104882:	e8 39 fa ff ff       	call   801042c0 <sched>
  p->chan = 0;
80104887:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
8010488e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104891:	5b                   	pop    %ebx
80104892:	5e                   	pop    %esi
80104893:	5f                   	pop    %edi
80104894:	5d                   	pop    %ebp
80104895:	c3                   	ret    
    panic("sleep without lk");
80104896:	83 ec 0c             	sub    $0xc,%esp
80104899:	68 ca 7f 10 80       	push   $0x80107fca
8010489e:	e8 dd ba ff ff       	call   80100380 <panic>
    panic("sleep");
801048a3:	83 ec 0c             	sub    $0xc,%esp
801048a6:	68 c4 7f 10 80       	push   $0x80107fc4
801048ab:	e8 d0 ba ff ff       	call   80100380 <panic>

801048b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	53                   	push   %ebx
801048b4:	83 ec 10             	sub    $0x10,%esp
801048b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801048ba:	68 80 2d 11 80       	push   $0x80112d80
801048bf:	e8 bc 04 00 00       	call   80104d80 <acquire>
801048c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048c7:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
801048cc:	eb 0e                	jmp    801048dc <wakeup+0x2c>
801048ce:	66 90                	xchg   %ax,%ax
801048d0:	05 9c 00 00 00       	add    $0x9c,%eax
801048d5:	3d b4 54 11 80       	cmp    $0x801154b4,%eax
801048da:	74 1e                	je     801048fa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801048dc:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801048e0:	75 ee                	jne    801048d0 <wakeup+0x20>
801048e2:	3b 58 24             	cmp    0x24(%eax),%ebx
801048e5:	75 e9                	jne    801048d0 <wakeup+0x20>
      p->state = RUNNABLE;
801048e7:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048ee:	05 9c 00 00 00       	add    $0x9c,%eax
801048f3:	3d b4 54 11 80       	cmp    $0x801154b4,%eax
801048f8:	75 e2                	jne    801048dc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801048fa:	c7 45 08 80 2d 11 80 	movl   $0x80112d80,0x8(%ebp)
}
80104901:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104904:	c9                   	leave  
  release(&ptable.lock);
80104905:	e9 16 04 00 00       	jmp    80104d20 <release>
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104910 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
80104914:	83 ec 10             	sub    $0x10,%esp
80104917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010491a:	68 80 2d 11 80       	push   $0x80112d80
8010491f:	e8 5c 04 00 00       	call   80104d80 <acquire>
80104924:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104927:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
8010492c:	eb 0e                	jmp    8010493c <kill+0x2c>
8010492e:	66 90                	xchg   %ax,%ax
80104930:	05 9c 00 00 00       	add    $0x9c,%eax
80104935:	3d b4 54 11 80       	cmp    $0x801154b4,%eax
8010493a:	74 34                	je     80104970 <kill+0x60>
    if(p->pid == pid){
8010493c:	39 58 14             	cmp    %ebx,0x14(%eax)
8010493f:	75 ef                	jne    80104930 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104941:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
80104945:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
8010494c:	75 07                	jne    80104955 <kill+0x45>
        p->state = RUNNABLE;
8010494e:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
      release(&ptable.lock);
80104955:	83 ec 0c             	sub    $0xc,%esp
80104958:	68 80 2d 11 80       	push   $0x80112d80
8010495d:	e8 be 03 00 00       	call   80104d20 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104962:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104965:	83 c4 10             	add    $0x10,%esp
80104968:	31 c0                	xor    %eax,%eax
}
8010496a:	c9                   	leave  
8010496b:	c3                   	ret    
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104970:	83 ec 0c             	sub    $0xc,%esp
80104973:	68 80 2d 11 80       	push   $0x80112d80
80104978:	e8 a3 03 00 00       	call   80104d20 <release>
}
8010497d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104980:	83 c4 10             	add    $0x10,%esp
80104983:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104988:	c9                   	leave  
80104989:	c3                   	ret    
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104990 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104998:	53                   	push   %ebx
80104999:	bb 24 2e 11 80       	mov    $0x80112e24,%ebx
8010499e:	83 ec 3c             	sub    $0x3c,%esp
801049a1:	eb 27                	jmp    801049ca <procdump+0x3a>
801049a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049a7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801049a8:	83 ec 0c             	sub    $0xc,%esp
801049ab:	68 57 83 10 80       	push   $0x80108357
801049b0:	e8 eb bc ff ff       	call   801006a0 <cprintf>
801049b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b8:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
801049be:	81 fb 24 55 11 80    	cmp    $0x80115524,%ebx
801049c4:	0f 84 7e 00 00 00    	je     80104a48 <procdump+0xb8>
    if(p->state == UNUSED)
801049ca:	8b 43 a0             	mov    -0x60(%ebx),%eax
801049cd:	85 c0                	test   %eax,%eax
801049cf:	74 e7                	je     801049b8 <procdump+0x28>
      state = "???";
801049d1:	ba db 7f 10 80       	mov    $0x80107fdb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801049d6:	83 f8 05             	cmp    $0x5,%eax
801049d9:	77 11                	ja     801049ec <procdump+0x5c>
801049db:	8b 14 85 3c 80 10 80 	mov    -0x7fef7fc4(,%eax,4),%edx
      state = "???";
801049e2:	b8 db 7f 10 80       	mov    $0x80107fdb,%eax
801049e7:	85 d2                	test   %edx,%edx
801049e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801049ec:	53                   	push   %ebx
801049ed:	52                   	push   %edx
801049ee:	ff 73 a4             	push   -0x5c(%ebx)
801049f1:	68 df 7f 10 80       	push   $0x80107fdf
801049f6:	e8 a5 bc ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801049fb:	83 c4 10             	add    $0x10,%esp
801049fe:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104a02:	75 a4                	jne    801049a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104a04:	83 ec 08             	sub    $0x8,%esp
80104a07:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a0a:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104a0d:	50                   	push   %eax
80104a0e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104a11:	8b 40 0c             	mov    0xc(%eax),%eax
80104a14:	83 c0 08             	add    $0x8,%eax
80104a17:	50                   	push   %eax
80104a18:	e8 b3 01 00 00       	call   80104bd0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a1d:	83 c4 10             	add    $0x10,%esp
80104a20:	8b 17                	mov    (%edi),%edx
80104a22:	85 d2                	test   %edx,%edx
80104a24:	74 82                	je     801049a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104a26:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104a29:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104a2c:	52                   	push   %edx
80104a2d:	68 21 7a 10 80       	push   $0x80107a21
80104a32:	e8 69 bc ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a37:	83 c4 10             	add    $0x10,%esp
80104a3a:	39 fe                	cmp    %edi,%esi
80104a3c:	75 e2                	jne    80104a20 <procdump+0x90>
80104a3e:	e9 65 ff ff ff       	jmp    801049a8 <procdump+0x18>
80104a43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a47:	90                   	nop
  }
}
80104a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a4b:	5b                   	pop    %ebx
80104a4c:	5e                   	pop    %esi
80104a4d:	5f                   	pop    %edi
80104a4e:	5d                   	pop    %ebp
80104a4f:	c3                   	ret    

80104a50 <get_next_round_robin.cold>:
        current_proc = dequeue_process(priority);
80104a50:	c7 05 20 2d 11 80 00 	movl   $0x0,0x80112d20
80104a57:	00 00 00 
        current_proc->rtime = 0;
80104a5a:	c7 05 84 00 00 00 00 	movl   $0x0,0x84
80104a61:	00 00 00 
80104a64:	0f 0b                	ud2    

80104a66 <scheduler.cold>:
        current_proc = dequeue_process(priority);
80104a66:	c7 05 20 2d 11 80 00 	movl   $0x0,0x80112d20
80104a6d:	00 00 00 
        current_proc->rtime = 0;
80104a70:	c7 05 84 00 00 00 00 	movl   $0x0,0x84
80104a77:	00 00 00 
80104a7a:	0f 0b                	ud2    
80104a7c:	66 90                	xchg   %ax,%ax
80104a7e:	66 90                	xchg   %ax,%ax

80104a80 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
80104a84:	83 ec 0c             	sub    $0xc,%esp
80104a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a8a:	68 54 80 10 80       	push   $0x80108054
80104a8f:	8d 43 04             	lea    0x4(%ebx),%eax
80104a92:	50                   	push   %eax
80104a93:	e8 18 01 00 00       	call   80104bb0 <initlock>
  lk->name = name;
80104a98:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104a9b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104aa1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104aa4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104aab:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104aae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab1:	c9                   	leave  
80104ab2:	c3                   	ret    
80104ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ac0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	53                   	push   %ebx
80104ac5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ac8:	8d 73 04             	lea    0x4(%ebx),%esi
80104acb:	83 ec 0c             	sub    $0xc,%esp
80104ace:	56                   	push   %esi
80104acf:	e8 ac 02 00 00       	call   80104d80 <acquire>
  while (lk->locked) {
80104ad4:	8b 13                	mov    (%ebx),%edx
80104ad6:	83 c4 10             	add    $0x10,%esp
80104ad9:	85 d2                	test   %edx,%edx
80104adb:	74 16                	je     80104af3 <acquiresleep+0x33>
80104add:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104ae0:	83 ec 08             	sub    $0x8,%esp
80104ae3:	56                   	push   %esi
80104ae4:	53                   	push   %ebx
80104ae5:	e8 06 fd ff ff       	call   801047f0 <sleep>
  while (lk->locked) {
80104aea:	8b 03                	mov    (%ebx),%eax
80104aec:	83 c4 10             	add    $0x10,%esp
80104aef:	85 c0                	test   %eax,%eax
80104af1:	75 ed                	jne    80104ae0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104af3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104af9:	e8 62 f2 ff ff       	call   80103d60 <myproc>
80104afe:	8b 40 14             	mov    0x14(%eax),%eax
80104b01:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b04:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b07:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b0a:	5b                   	pop    %ebx
80104b0b:	5e                   	pop    %esi
80104b0c:	5d                   	pop    %ebp
  release(&lk->lk);
80104b0d:	e9 0e 02 00 00       	jmp    80104d20 <release>
80104b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b20 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b28:	8d 73 04             	lea    0x4(%ebx),%esi
80104b2b:	83 ec 0c             	sub    $0xc,%esp
80104b2e:	56                   	push   %esi
80104b2f:	e8 4c 02 00 00       	call   80104d80 <acquire>
  lk->locked = 0;
80104b34:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b3a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b41:	89 1c 24             	mov    %ebx,(%esp)
80104b44:	e8 67 fd ff ff       	call   801048b0 <wakeup>
  release(&lk->lk);
80104b49:	89 75 08             	mov    %esi,0x8(%ebp)
80104b4c:	83 c4 10             	add    $0x10,%esp
}
80104b4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b52:	5b                   	pop    %ebx
80104b53:	5e                   	pop    %esi
80104b54:	5d                   	pop    %ebp
  release(&lk->lk);
80104b55:	e9 c6 01 00 00       	jmp    80104d20 <release>
80104b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b60 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	57                   	push   %edi
80104b64:	31 ff                	xor    %edi,%edi
80104b66:	56                   	push   %esi
80104b67:	53                   	push   %ebx
80104b68:	83 ec 18             	sub    $0x18,%esp
80104b6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104b6e:	8d 73 04             	lea    0x4(%ebx),%esi
80104b71:	56                   	push   %esi
80104b72:	e8 09 02 00 00       	call   80104d80 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104b77:	8b 03                	mov    (%ebx),%eax
80104b79:	83 c4 10             	add    $0x10,%esp
80104b7c:	85 c0                	test   %eax,%eax
80104b7e:	75 18                	jne    80104b98 <holdingsleep+0x38>
  release(&lk->lk);
80104b80:	83 ec 0c             	sub    $0xc,%esp
80104b83:	56                   	push   %esi
80104b84:	e8 97 01 00 00       	call   80104d20 <release>
  return r;
}
80104b89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b8c:	89 f8                	mov    %edi,%eax
80104b8e:	5b                   	pop    %ebx
80104b8f:	5e                   	pop    %esi
80104b90:	5f                   	pop    %edi
80104b91:	5d                   	pop    %ebp
80104b92:	c3                   	ret    
80104b93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b97:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104b98:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104b9b:	e8 c0 f1 ff ff       	call   80103d60 <myproc>
80104ba0:	39 58 14             	cmp    %ebx,0x14(%eax)
80104ba3:	0f 94 c0             	sete   %al
80104ba6:	0f b6 c0             	movzbl %al,%eax
80104ba9:	89 c7                	mov    %eax,%edi
80104bab:	eb d3                	jmp    80104b80 <holdingsleep+0x20>
80104bad:	66 90                	xchg   %ax,%ax
80104baf:	90                   	nop

80104bb0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104bb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104bb9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104bbf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104bc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104bc9:	5d                   	pop    %ebp
80104bca:	c3                   	ret    
80104bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bcf:	90                   	nop

80104bd0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104bd0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104bd1:	31 d2                	xor    %edx,%edx
{
80104bd3:	89 e5                	mov    %esp,%ebp
80104bd5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104bd6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104bdc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104bdf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104be0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104be6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104bec:	77 1a                	ja     80104c08 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104bee:	8b 58 04             	mov    0x4(%eax),%ebx
80104bf1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104bf4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104bf7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104bf9:	83 fa 0a             	cmp    $0xa,%edx
80104bfc:	75 e2                	jne    80104be0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104bfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c01:	c9                   	leave  
80104c02:	c3                   	ret    
80104c03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c07:	90                   	nop
  for(; i < 10; i++)
80104c08:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c0b:	8d 51 28             	lea    0x28(%ecx),%edx
80104c0e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104c10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c16:	83 c0 04             	add    $0x4,%eax
80104c19:	39 d0                	cmp    %edx,%eax
80104c1b:	75 f3                	jne    80104c10 <getcallerpcs+0x40>
}
80104c1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c20:	c9                   	leave  
80104c21:	c3                   	ret    
80104c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c30 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
80104c37:	9c                   	pushf  
80104c38:	5b                   	pop    %ebx
  asm volatile("cli");
80104c39:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c3a:	e8 01 ef ff ff       	call   80103b40 <mycpu>
80104c3f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c45:	85 c0                	test   %eax,%eax
80104c47:	74 17                	je     80104c60 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104c49:	e8 f2 ee ff ff       	call   80103b40 <mycpu>
80104c4e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c58:	c9                   	leave  
80104c59:	c3                   	ret    
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104c60:	e8 db ee ff ff       	call   80103b40 <mycpu>
80104c65:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104c6b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104c71:	eb d6                	jmp    80104c49 <pushcli+0x19>
80104c73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c80 <popcli>:

void
popcli(void)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c86:	9c                   	pushf  
80104c87:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c88:	f6 c4 02             	test   $0x2,%ah
80104c8b:	75 35                	jne    80104cc2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c8d:	e8 ae ee ff ff       	call   80103b40 <mycpu>
80104c92:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c99:	78 34                	js     80104ccf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c9b:	e8 a0 ee ff ff       	call   80103b40 <mycpu>
80104ca0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104ca6:	85 d2                	test   %edx,%edx
80104ca8:	74 06                	je     80104cb0 <popcli+0x30>
    sti();
}
80104caa:	c9                   	leave  
80104cab:	c3                   	ret    
80104cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104cb0:	e8 8b ee ff ff       	call   80103b40 <mycpu>
80104cb5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104cbb:	85 c0                	test   %eax,%eax
80104cbd:	74 eb                	je     80104caa <popcli+0x2a>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104cbf:	fb                   	sti    
}
80104cc0:	c9                   	leave  
80104cc1:	c3                   	ret    
    panic("popcli - interruptible");
80104cc2:	83 ec 0c             	sub    $0xc,%esp
80104cc5:	68 5f 80 10 80       	push   $0x8010805f
80104cca:	e8 b1 b6 ff ff       	call   80100380 <panic>
    panic("popcli");
80104ccf:	83 ec 0c             	sub    $0xc,%esp
80104cd2:	68 76 80 10 80       	push   $0x80108076
80104cd7:	e8 a4 b6 ff ff       	call   80100380 <panic>
80104cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ce0 <holding>:
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
80104ce5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ce8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104cea:	e8 41 ff ff ff       	call   80104c30 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104cef:	8b 06                	mov    (%esi),%eax
80104cf1:	85 c0                	test   %eax,%eax
80104cf3:	75 0b                	jne    80104d00 <holding+0x20>
  popcli();
80104cf5:	e8 86 ff ff ff       	call   80104c80 <popcli>
}
80104cfa:	89 d8                	mov    %ebx,%eax
80104cfc:	5b                   	pop    %ebx
80104cfd:	5e                   	pop    %esi
80104cfe:	5d                   	pop    %ebp
80104cff:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104d00:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d03:	e8 38 ee ff ff       	call   80103b40 <mycpu>
80104d08:	39 c3                	cmp    %eax,%ebx
80104d0a:	0f 94 c3             	sete   %bl
  popcli();
80104d0d:	e8 6e ff ff ff       	call   80104c80 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104d12:	0f b6 db             	movzbl %bl,%ebx
}
80104d15:	89 d8                	mov    %ebx,%eax
80104d17:	5b                   	pop    %ebx
80104d18:	5e                   	pop    %esi
80104d19:	5d                   	pop    %ebp
80104d1a:	c3                   	ret    
80104d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d1f:	90                   	nop

80104d20 <release>:
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	53                   	push   %ebx
80104d25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d28:	e8 03 ff ff ff       	call   80104c30 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d2d:	8b 03                	mov    (%ebx),%eax
80104d2f:	85 c0                	test   %eax,%eax
80104d31:	75 15                	jne    80104d48 <release+0x28>
  popcli();
80104d33:	e8 48 ff ff ff       	call   80104c80 <popcli>
    panic("release");
80104d38:	83 ec 0c             	sub    $0xc,%esp
80104d3b:	68 7d 80 10 80       	push   $0x8010807d
80104d40:	e8 3b b6 ff ff       	call   80100380 <panic>
80104d45:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104d48:	8b 73 08             	mov    0x8(%ebx),%esi
80104d4b:	e8 f0 ed ff ff       	call   80103b40 <mycpu>
80104d50:	39 c6                	cmp    %eax,%esi
80104d52:	75 df                	jne    80104d33 <release+0x13>
  popcli();
80104d54:	e8 27 ff ff ff       	call   80104c80 <popcli>
  lk->pcs[0] = 0;
80104d59:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d60:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104d67:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d6c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104d72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d75:	5b                   	pop    %ebx
80104d76:	5e                   	pop    %esi
80104d77:	5d                   	pop    %ebp
  popcli();
80104d78:	e9 03 ff ff ff       	jmp    80104c80 <popcli>
80104d7d:	8d 76 00             	lea    0x0(%esi),%esi

80104d80 <acquire>:
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	53                   	push   %ebx
80104d84:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104d87:	e8 a4 fe ff ff       	call   80104c30 <pushcli>
  if(holding(lk))
80104d8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d8f:	e8 9c fe ff ff       	call   80104c30 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d94:	8b 03                	mov    (%ebx),%eax
80104d96:	85 c0                	test   %eax,%eax
80104d98:	75 7e                	jne    80104e18 <acquire+0x98>
  popcli();
80104d9a:	e8 e1 fe ff ff       	call   80104c80 <popcli>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104d9f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104da8:	8b 55 08             	mov    0x8(%ebp),%edx
80104dab:	89 c8                	mov    %ecx,%eax
80104dad:	f0 87 02             	lock xchg %eax,(%edx)
80104db0:	85 c0                	test   %eax,%eax
80104db2:	75 f4                	jne    80104da8 <acquire+0x28>
  __sync_synchronize();
80104db4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104db9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dbc:	e8 7f ed ff ff       	call   80103b40 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104dc1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104dc4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104dc6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104dc9:	31 c0                	xor    %eax,%eax
80104dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dcf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104dd0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104dd6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ddc:	77 1a                	ja     80104df8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104dde:	8b 5a 04             	mov    0x4(%edx),%ebx
80104de1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104de5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104de8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104dea:	83 f8 0a             	cmp    $0xa,%eax
80104ded:	75 e1                	jne    80104dd0 <acquire+0x50>
}
80104def:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104df2:	c9                   	leave  
80104df3:	c3                   	ret    
80104df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104df8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104dfc:	8d 51 34             	lea    0x34(%ecx),%edx
80104dff:	90                   	nop
    pcs[i] = 0;
80104e00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e06:	83 c0 04             	add    $0x4,%eax
80104e09:	39 c2                	cmp    %eax,%edx
80104e0b:	75 f3                	jne    80104e00 <acquire+0x80>
}
80104e0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e10:	c9                   	leave  
80104e11:	c3                   	ret    
80104e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e18:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104e1b:	e8 20 ed ff ff       	call   80103b40 <mycpu>
80104e20:	39 c3                	cmp    %eax,%ebx
80104e22:	0f 85 72 ff ff ff    	jne    80104d9a <acquire+0x1a>
  popcli();
80104e28:	e8 53 fe ff ff       	call   80104c80 <popcli>
    panic("acquire");
80104e2d:	83 ec 0c             	sub    $0xc,%esp
80104e30:	68 85 80 10 80       	push   $0x80108085
80104e35:	e8 46 b5 ff ff       	call   80100380 <panic>
80104e3a:	66 90                	xchg   %ax,%ax
80104e3c:	66 90                	xchg   %ax,%ax
80104e3e:	66 90                	xchg   %ax,%ax

80104e40 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	8b 55 08             	mov    0x8(%ebp),%edx
80104e47:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e4a:	53                   	push   %ebx
80104e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104e4e:	89 d7                	mov    %edx,%edi
80104e50:	09 cf                	or     %ecx,%edi
80104e52:	83 e7 03             	and    $0x3,%edi
80104e55:	75 29                	jne    80104e80 <memset+0x40>
    c &= 0xFF;
80104e57:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104e5a:	c1 e0 18             	shl    $0x18,%eax
80104e5d:	89 fb                	mov    %edi,%ebx
80104e5f:	c1 e9 02             	shr    $0x2,%ecx
80104e62:	c1 e3 10             	shl    $0x10,%ebx
80104e65:	09 d8                	or     %ebx,%eax
80104e67:	09 f8                	or     %edi,%eax
80104e69:	c1 e7 08             	shl    $0x8,%edi
80104e6c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104e6e:	89 d7                	mov    %edx,%edi
80104e70:	fc                   	cld    
80104e71:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104e73:	5b                   	pop    %ebx
80104e74:	89 d0                	mov    %edx,%eax
80104e76:	5f                   	pop    %edi
80104e77:	5d                   	pop    %ebp
80104e78:	c3                   	ret    
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104e80:	89 d7                	mov    %edx,%edi
80104e82:	fc                   	cld    
80104e83:	f3 aa                	rep stos %al,%es:(%edi)
80104e85:	5b                   	pop    %ebx
80104e86:	89 d0                	mov    %edx,%eax
80104e88:	5f                   	pop    %edi
80104e89:	5d                   	pop    %ebp
80104e8a:	c3                   	ret    
80104e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e8f:	90                   	nop

80104e90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	8b 75 10             	mov    0x10(%ebp),%esi
80104e97:	8b 55 08             	mov    0x8(%ebp),%edx
80104e9a:	53                   	push   %ebx
80104e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e9e:	85 f6                	test   %esi,%esi
80104ea0:	74 2e                	je     80104ed0 <memcmp+0x40>
80104ea2:	01 c6                	add    %eax,%esi
80104ea4:	eb 14                	jmp    80104eba <memcmp+0x2a>
80104ea6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ead:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104eb0:	83 c0 01             	add    $0x1,%eax
80104eb3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104eb6:	39 f0                	cmp    %esi,%eax
80104eb8:	74 16                	je     80104ed0 <memcmp+0x40>
    if(*s1 != *s2)
80104eba:	0f b6 0a             	movzbl (%edx),%ecx
80104ebd:	0f b6 18             	movzbl (%eax),%ebx
80104ec0:	38 d9                	cmp    %bl,%cl
80104ec2:	74 ec                	je     80104eb0 <memcmp+0x20>
      return *s1 - *s2;
80104ec4:	0f b6 c1             	movzbl %cl,%eax
80104ec7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104ec9:	5b                   	pop    %ebx
80104eca:	5e                   	pop    %esi
80104ecb:	5d                   	pop    %ebp
80104ecc:	c3                   	ret    
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
80104ed0:	5b                   	pop    %ebx
  return 0;
80104ed1:	31 c0                	xor    %eax,%eax
}
80104ed3:	5e                   	pop    %esi
80104ed4:	5d                   	pop    %ebp
80104ed5:	c3                   	ret    
80104ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104edd:	8d 76 00             	lea    0x0(%esi),%esi

80104ee0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	57                   	push   %edi
80104ee4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ee7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104eea:	56                   	push   %esi
80104eeb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104eee:	39 d6                	cmp    %edx,%esi
80104ef0:	73 26                	jae    80104f18 <memmove+0x38>
80104ef2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104ef5:	39 fa                	cmp    %edi,%edx
80104ef7:	73 1f                	jae    80104f18 <memmove+0x38>
80104ef9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104efc:	85 c9                	test   %ecx,%ecx
80104efe:	74 0c                	je     80104f0c <memmove+0x2c>
      *--d = *--s;
80104f00:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f04:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104f07:	83 e8 01             	sub    $0x1,%eax
80104f0a:	73 f4                	jae    80104f00 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f0c:	5e                   	pop    %esi
80104f0d:	89 d0                	mov    %edx,%eax
80104f0f:	5f                   	pop    %edi
80104f10:	5d                   	pop    %ebp
80104f11:	c3                   	ret    
80104f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104f18:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104f1b:	89 d7                	mov    %edx,%edi
80104f1d:	85 c9                	test   %ecx,%ecx
80104f1f:	74 eb                	je     80104f0c <memmove+0x2c>
80104f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104f28:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104f29:	39 c6                	cmp    %eax,%esi
80104f2b:	75 fb                	jne    80104f28 <memmove+0x48>
}
80104f2d:	5e                   	pop    %esi
80104f2e:	89 d0                	mov    %edx,%eax
80104f30:	5f                   	pop    %edi
80104f31:	5d                   	pop    %ebp
80104f32:	c3                   	ret    
80104f33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104f40:	eb 9e                	jmp    80104ee0 <memmove>
80104f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f50 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	8b 75 10             	mov    0x10(%ebp),%esi
80104f57:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f5a:	53                   	push   %ebx
80104f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104f5e:	85 f6                	test   %esi,%esi
80104f60:	74 2e                	je     80104f90 <strncmp+0x40>
80104f62:	01 d6                	add    %edx,%esi
80104f64:	eb 18                	jmp    80104f7e <strncmp+0x2e>
80104f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
80104f70:	38 d8                	cmp    %bl,%al
80104f72:	75 14                	jne    80104f88 <strncmp+0x38>
    n--, p++, q++;
80104f74:	83 c2 01             	add    $0x1,%edx
80104f77:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104f7a:	39 f2                	cmp    %esi,%edx
80104f7c:	74 12                	je     80104f90 <strncmp+0x40>
80104f7e:	0f b6 01             	movzbl (%ecx),%eax
80104f81:	0f b6 1a             	movzbl (%edx),%ebx
80104f84:	84 c0                	test   %al,%al
80104f86:	75 e8                	jne    80104f70 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104f88:	29 d8                	sub    %ebx,%eax
}
80104f8a:	5b                   	pop    %ebx
80104f8b:	5e                   	pop    %esi
80104f8c:	5d                   	pop    %ebp
80104f8d:	c3                   	ret    
80104f8e:	66 90                	xchg   %ax,%ax
80104f90:	5b                   	pop    %ebx
    return 0;
80104f91:	31 c0                	xor    %eax,%eax
}
80104f93:	5e                   	pop    %esi
80104f94:	5d                   	pop    %ebp
80104f95:	c3                   	ret    
80104f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi

80104fa0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	57                   	push   %edi
80104fa4:	56                   	push   %esi
80104fa5:	8b 75 08             	mov    0x8(%ebp),%esi
80104fa8:	53                   	push   %ebx
80104fa9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104fac:	89 f0                	mov    %esi,%eax
80104fae:	eb 15                	jmp    80104fc5 <strncpy+0x25>
80104fb0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104fb4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104fb7:	83 c0 01             	add    $0x1,%eax
80104fba:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104fbe:	88 50 ff             	mov    %dl,-0x1(%eax)
80104fc1:	84 d2                	test   %dl,%dl
80104fc3:	74 09                	je     80104fce <strncpy+0x2e>
80104fc5:	89 cb                	mov    %ecx,%ebx
80104fc7:	83 e9 01             	sub    $0x1,%ecx
80104fca:	85 db                	test   %ebx,%ebx
80104fcc:	7f e2                	jg     80104fb0 <strncpy+0x10>
    ;
  while(n-- > 0)
80104fce:	89 c2                	mov    %eax,%edx
80104fd0:	85 c9                	test   %ecx,%ecx
80104fd2:	7e 17                	jle    80104feb <strncpy+0x4b>
80104fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104fd8:	83 c2 01             	add    $0x1,%edx
80104fdb:	89 c1                	mov    %eax,%ecx
80104fdd:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104fe1:	29 d1                	sub    %edx,%ecx
80104fe3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104fe7:	85 c9                	test   %ecx,%ecx
80104fe9:	7f ed                	jg     80104fd8 <strncpy+0x38>
  return os;
}
80104feb:	5b                   	pop    %ebx
80104fec:	89 f0                	mov    %esi,%eax
80104fee:	5e                   	pop    %esi
80104fef:	5f                   	pop    %edi
80104ff0:	5d                   	pop    %ebp
80104ff1:	c3                   	ret    
80104ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105000 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	8b 55 10             	mov    0x10(%ebp),%edx
80105007:	8b 75 08             	mov    0x8(%ebp),%esi
8010500a:	53                   	push   %ebx
8010500b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010500e:	85 d2                	test   %edx,%edx
80105010:	7e 25                	jle    80105037 <safestrcpy+0x37>
80105012:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105016:	89 f2                	mov    %esi,%edx
80105018:	eb 16                	jmp    80105030 <safestrcpy+0x30>
8010501a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105020:	0f b6 08             	movzbl (%eax),%ecx
80105023:	83 c0 01             	add    $0x1,%eax
80105026:	83 c2 01             	add    $0x1,%edx
80105029:	88 4a ff             	mov    %cl,-0x1(%edx)
8010502c:	84 c9                	test   %cl,%cl
8010502e:	74 04                	je     80105034 <safestrcpy+0x34>
80105030:	39 d8                	cmp    %ebx,%eax
80105032:	75 ec                	jne    80105020 <safestrcpy+0x20>
    ;
  *s = 0;
80105034:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105037:	89 f0                	mov    %esi,%eax
80105039:	5b                   	pop    %ebx
8010503a:	5e                   	pop    %esi
8010503b:	5d                   	pop    %ebp
8010503c:	c3                   	ret    
8010503d:	8d 76 00             	lea    0x0(%esi),%esi

80105040 <strlen>:

int
strlen(const char *s)
{
80105040:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105041:	31 c0                	xor    %eax,%eax
{
80105043:	89 e5                	mov    %esp,%ebp
80105045:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105048:	80 3a 00             	cmpb   $0x0,(%edx)
8010504b:	74 0c                	je     80105059 <strlen+0x19>
8010504d:	8d 76 00             	lea    0x0(%esi),%esi
80105050:	83 c0 01             	add    $0x1,%eax
80105053:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105057:	75 f7                	jne    80105050 <strlen+0x10>
    ;
  return n;
}
80105059:	5d                   	pop    %ebp
8010505a:	c3                   	ret    

8010505b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010505b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010505f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105063:	55                   	push   %ebp
  pushl %ebx
80105064:	53                   	push   %ebx
  pushl %esi
80105065:	56                   	push   %esi
  pushl %edi
80105066:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105067:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105069:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010506b:	5f                   	pop    %edi
  popl %esi
8010506c:	5e                   	pop    %esi
  popl %ebx
8010506d:	5b                   	pop    %ebx
  popl %ebp
8010506e:	5d                   	pop    %ebp
  ret
8010506f:	c3                   	ret    

80105070 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	53                   	push   %ebx
80105074:	83 ec 04             	sub    $0x4,%esp
80105077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010507a:	e8 e1 ec ff ff       	call   80103d60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010507f:	8b 00                	mov    (%eax),%eax
80105081:	39 d8                	cmp    %ebx,%eax
80105083:	76 1b                	jbe    801050a0 <fetchint+0x30>
80105085:	8d 53 04             	lea    0x4(%ebx),%edx
80105088:	39 d0                	cmp    %edx,%eax
8010508a:	72 14                	jb     801050a0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010508c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010508f:	8b 13                	mov    (%ebx),%edx
80105091:	89 10                	mov    %edx,(%eax)
  return 0;
80105093:	31 c0                	xor    %eax,%eax
}
80105095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105098:	c9                   	leave  
80105099:	c3                   	ret    
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a5:	eb ee                	jmp    80105095 <fetchint+0x25>
801050a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ae:	66 90                	xchg   %ax,%ax

801050b0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	53                   	push   %ebx
801050b4:	83 ec 04             	sub    $0x4,%esp
801050b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801050ba:	e8 a1 ec ff ff       	call   80103d60 <myproc>

  if(addr >= curproc->sz)
801050bf:	39 18                	cmp    %ebx,(%eax)
801050c1:	76 2d                	jbe    801050f0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801050c3:	8b 55 0c             	mov    0xc(%ebp),%edx
801050c6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801050c8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801050ca:	39 d3                	cmp    %edx,%ebx
801050cc:	73 22                	jae    801050f0 <fetchstr+0x40>
801050ce:	89 d8                	mov    %ebx,%eax
801050d0:	eb 0d                	jmp    801050df <fetchstr+0x2f>
801050d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050d8:	83 c0 01             	add    $0x1,%eax
801050db:	39 c2                	cmp    %eax,%edx
801050dd:	76 11                	jbe    801050f0 <fetchstr+0x40>
    if(*s == 0)
801050df:	80 38 00             	cmpb   $0x0,(%eax)
801050e2:	75 f4                	jne    801050d8 <fetchstr+0x28>
      return s - *pp;
801050e4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801050e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050e9:	c9                   	leave  
801050ea:	c3                   	ret    
801050eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050ef:	90                   	nop
801050f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801050f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050f8:	c9                   	leave  
801050f9:	c3                   	ret    
801050fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105100 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105105:	e8 56 ec ff ff       	call   80103d60 <myproc>
8010510a:	8b 55 08             	mov    0x8(%ebp),%edx
8010510d:	8b 40 1c             	mov    0x1c(%eax),%eax
80105110:	8b 40 44             	mov    0x44(%eax),%eax
80105113:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105116:	e8 45 ec ff ff       	call   80103d60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010511b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010511e:	8b 00                	mov    (%eax),%eax
80105120:	39 c6                	cmp    %eax,%esi
80105122:	73 1c                	jae    80105140 <argint+0x40>
80105124:	8d 53 08             	lea    0x8(%ebx),%edx
80105127:	39 d0                	cmp    %edx,%eax
80105129:	72 15                	jb     80105140 <argint+0x40>
  *ip = *(int*)(addr);
8010512b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010512e:	8b 53 04             	mov    0x4(%ebx),%edx
80105131:	89 10                	mov    %edx,(%eax)
  return 0;
80105133:	31 c0                	xor    %eax,%eax
}
80105135:	5b                   	pop    %ebx
80105136:	5e                   	pop    %esi
80105137:	5d                   	pop    %ebp
80105138:	c3                   	ret    
80105139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105145:	eb ee                	jmp    80105135 <argint+0x35>
80105147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514e:	66 90                	xchg   %ax,%ax

80105150 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	57                   	push   %edi
80105154:	56                   	push   %esi
80105155:	53                   	push   %ebx
80105156:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105159:	e8 02 ec ff ff       	call   80103d60 <myproc>
8010515e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105160:	e8 fb eb ff ff       	call   80103d60 <myproc>
80105165:	8b 55 08             	mov    0x8(%ebp),%edx
80105168:	8b 40 1c             	mov    0x1c(%eax),%eax
8010516b:	8b 40 44             	mov    0x44(%eax),%eax
8010516e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105171:	e8 ea eb ff ff       	call   80103d60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105176:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105179:	8b 00                	mov    (%eax),%eax
8010517b:	39 c7                	cmp    %eax,%edi
8010517d:	73 31                	jae    801051b0 <argptr+0x60>
8010517f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105182:	39 c8                	cmp    %ecx,%eax
80105184:	72 2a                	jb     801051b0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105186:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105189:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010518c:	85 d2                	test   %edx,%edx
8010518e:	78 20                	js     801051b0 <argptr+0x60>
80105190:	8b 16                	mov    (%esi),%edx
80105192:	39 c2                	cmp    %eax,%edx
80105194:	76 1a                	jbe    801051b0 <argptr+0x60>
80105196:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105199:	01 c3                	add    %eax,%ebx
8010519b:	39 da                	cmp    %ebx,%edx
8010519d:	72 11                	jb     801051b0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
8010519f:	8b 55 0c             	mov    0xc(%ebp),%edx
801051a2:	89 02                	mov    %eax,(%edx)
  return 0;
801051a4:	31 c0                	xor    %eax,%eax
}
801051a6:	83 c4 0c             	add    $0xc,%esp
801051a9:	5b                   	pop    %ebx
801051aa:	5e                   	pop    %esi
801051ab:	5f                   	pop    %edi
801051ac:	5d                   	pop    %ebp
801051ad:	c3                   	ret    
801051ae:	66 90                	xchg   %ax,%ax
    return -1;
801051b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b5:	eb ef                	jmp    801051a6 <argptr+0x56>
801051b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051be:	66 90                	xchg   %ax,%ax

801051c0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	56                   	push   %esi
801051c4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051c5:	e8 96 eb ff ff       	call   80103d60 <myproc>
801051ca:	8b 55 08             	mov    0x8(%ebp),%edx
801051cd:	8b 40 1c             	mov    0x1c(%eax),%eax
801051d0:	8b 40 44             	mov    0x44(%eax),%eax
801051d3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051d6:	e8 85 eb ff ff       	call   80103d60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051db:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051de:	8b 00                	mov    (%eax),%eax
801051e0:	39 c6                	cmp    %eax,%esi
801051e2:	73 44                	jae    80105228 <argstr+0x68>
801051e4:	8d 53 08             	lea    0x8(%ebx),%edx
801051e7:	39 d0                	cmp    %edx,%eax
801051e9:	72 3d                	jb     80105228 <argstr+0x68>
  *ip = *(int*)(addr);
801051eb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801051ee:	e8 6d eb ff ff       	call   80103d60 <myproc>
  if(addr >= curproc->sz)
801051f3:	3b 18                	cmp    (%eax),%ebx
801051f5:	73 31                	jae    80105228 <argstr+0x68>
  *pp = (char*)addr;
801051f7:	8b 55 0c             	mov    0xc(%ebp),%edx
801051fa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801051fc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801051fe:	39 d3                	cmp    %edx,%ebx
80105200:	73 26                	jae    80105228 <argstr+0x68>
80105202:	89 d8                	mov    %ebx,%eax
80105204:	eb 11                	jmp    80105217 <argstr+0x57>
80105206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
80105210:	83 c0 01             	add    $0x1,%eax
80105213:	39 c2                	cmp    %eax,%edx
80105215:	76 11                	jbe    80105228 <argstr+0x68>
    if(*s == 0)
80105217:	80 38 00             	cmpb   $0x0,(%eax)
8010521a:	75 f4                	jne    80105210 <argstr+0x50>
      return s - *pp;
8010521c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010521e:	5b                   	pop    %ebx
8010521f:	5e                   	pop    %esi
80105220:	5d                   	pop    %ebp
80105221:	c3                   	ret    
80105222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105228:	5b                   	pop    %ebx
    return -1;
80105229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010522e:	5e                   	pop    %esi
8010522f:	5d                   	pop    %ebp
80105230:	c3                   	ret    
80105231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010523f:	90                   	nop

80105240 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	53                   	push   %ebx
80105244:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105247:	e8 14 eb ff ff       	call   80103d60 <myproc>
8010524c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010524e:	8b 40 1c             	mov    0x1c(%eax),%eax
80105251:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105254:	8d 50 ff             	lea    -0x1(%eax),%edx
80105257:	83 fa 14             	cmp    $0x14,%edx
8010525a:	77 24                	ja     80105280 <syscall+0x40>
8010525c:	8b 14 85 c0 80 10 80 	mov    -0x7fef7f40(,%eax,4),%edx
80105263:	85 d2                	test   %edx,%edx
80105265:	74 19                	je     80105280 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105267:	ff d2                	call   *%edx
80105269:	89 c2                	mov    %eax,%edx
8010526b:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010526e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105271:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105274:	c9                   	leave  
80105275:	c3                   	ret    
80105276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010527d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105280:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105281:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105284:	50                   	push   %eax
80105285:	ff 73 14             	push   0x14(%ebx)
80105288:	68 8d 80 10 80       	push   $0x8010808d
8010528d:	e8 0e b4 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80105292:	8b 43 1c             	mov    0x1c(%ebx),%eax
80105295:	83 c4 10             	add    $0x10,%esp
80105298:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010529f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052a2:	c9                   	leave  
801052a3:	c3                   	ret    
801052a4:	66 90                	xchg   %ax,%ax
801052a6:	66 90                	xchg   %ax,%ax
801052a8:	66 90                	xchg   %ax,%ax
801052aa:	66 90                	xchg   %ax,%ax
801052ac:	66 90                	xchg   %ax,%ax
801052ae:	66 90                	xchg   %ax,%ax

801052b0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	57                   	push   %edi
801052b4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801052b5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801052b8:	53                   	push   %ebx
801052b9:	83 ec 34             	sub    $0x34,%esp
801052bc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801052bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801052c2:	57                   	push   %edi
801052c3:	50                   	push   %eax
{
801052c4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801052c7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801052ca:	e8 f1 cd ff ff       	call   801020c0 <nameiparent>
801052cf:	83 c4 10             	add    $0x10,%esp
801052d2:	85 c0                	test   %eax,%eax
801052d4:	0f 84 46 01 00 00    	je     80105420 <create+0x170>
    return 0;
  ilock(dp);
801052da:	83 ec 0c             	sub    $0xc,%esp
801052dd:	89 c3                	mov    %eax,%ebx
801052df:	50                   	push   %eax
801052e0:	e8 9b c4 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801052e5:	83 c4 0c             	add    $0xc,%esp
801052e8:	6a 00                	push   $0x0
801052ea:	57                   	push   %edi
801052eb:	53                   	push   %ebx
801052ec:	e8 ef c9 ff ff       	call   80101ce0 <dirlookup>
801052f1:	83 c4 10             	add    $0x10,%esp
801052f4:	89 c6                	mov    %eax,%esi
801052f6:	85 c0                	test   %eax,%eax
801052f8:	74 56                	je     80105350 <create+0xa0>
    iunlockput(dp);
801052fa:	83 ec 0c             	sub    $0xc,%esp
801052fd:	53                   	push   %ebx
801052fe:	e8 0d c7 ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80105303:	89 34 24             	mov    %esi,(%esp)
80105306:	e8 75 c4 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010530b:	83 c4 10             	add    $0x10,%esp
8010530e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105313:	75 1b                	jne    80105330 <create+0x80>
80105315:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010531a:	75 14                	jne    80105330 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010531c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010531f:	89 f0                	mov    %esi,%eax
80105321:	5b                   	pop    %ebx
80105322:	5e                   	pop    %esi
80105323:	5f                   	pop    %edi
80105324:	5d                   	pop    %ebp
80105325:	c3                   	ret    
80105326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105330:	83 ec 0c             	sub    $0xc,%esp
80105333:	56                   	push   %esi
    return 0;
80105334:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105336:	e8 d5 c6 ff ff       	call   80101a10 <iunlockput>
    return 0;
8010533b:	83 c4 10             	add    $0x10,%esp
}
8010533e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105341:	89 f0                	mov    %esi,%eax
80105343:	5b                   	pop    %ebx
80105344:	5e                   	pop    %esi
80105345:	5f                   	pop    %edi
80105346:	5d                   	pop    %ebp
80105347:	c3                   	ret    
80105348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010534f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105350:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105354:	83 ec 08             	sub    $0x8,%esp
80105357:	50                   	push   %eax
80105358:	ff 33                	push   (%ebx)
8010535a:	e8 b1 c2 ff ff       	call   80101610 <ialloc>
8010535f:	83 c4 10             	add    $0x10,%esp
80105362:	89 c6                	mov    %eax,%esi
80105364:	85 c0                	test   %eax,%eax
80105366:	0f 84 cd 00 00 00    	je     80105439 <create+0x189>
  ilock(ip);
8010536c:	83 ec 0c             	sub    $0xc,%esp
8010536f:	50                   	push   %eax
80105370:	e8 0b c4 ff ff       	call   80101780 <ilock>
  ip->major = major;
80105375:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105379:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010537d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105381:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105385:	b8 01 00 00 00       	mov    $0x1,%eax
8010538a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010538e:	89 34 24             	mov    %esi,(%esp)
80105391:	e8 3a c3 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105396:	83 c4 10             	add    $0x10,%esp
80105399:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010539e:	74 30                	je     801053d0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801053a0:	83 ec 04             	sub    $0x4,%esp
801053a3:	ff 76 04             	push   0x4(%esi)
801053a6:	57                   	push   %edi
801053a7:	53                   	push   %ebx
801053a8:	e8 33 cc ff ff       	call   80101fe0 <dirlink>
801053ad:	83 c4 10             	add    $0x10,%esp
801053b0:	85 c0                	test   %eax,%eax
801053b2:	78 78                	js     8010542c <create+0x17c>
  iunlockput(dp);
801053b4:	83 ec 0c             	sub    $0xc,%esp
801053b7:	53                   	push   %ebx
801053b8:	e8 53 c6 ff ff       	call   80101a10 <iunlockput>
  return ip;
801053bd:	83 c4 10             	add    $0x10,%esp
}
801053c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053c3:	89 f0                	mov    %esi,%eax
801053c5:	5b                   	pop    %ebx
801053c6:	5e                   	pop    %esi
801053c7:	5f                   	pop    %edi
801053c8:	5d                   	pop    %ebp
801053c9:	c3                   	ret    
801053ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801053d0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801053d3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801053d8:	53                   	push   %ebx
801053d9:	e8 f2 c2 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801053de:	83 c4 0c             	add    $0xc,%esp
801053e1:	ff 76 04             	push   0x4(%esi)
801053e4:	68 34 81 10 80       	push   $0x80108134
801053e9:	56                   	push   %esi
801053ea:	e8 f1 cb ff ff       	call   80101fe0 <dirlink>
801053ef:	83 c4 10             	add    $0x10,%esp
801053f2:	85 c0                	test   %eax,%eax
801053f4:	78 18                	js     8010540e <create+0x15e>
801053f6:	83 ec 04             	sub    $0x4,%esp
801053f9:	ff 73 04             	push   0x4(%ebx)
801053fc:	68 33 81 10 80       	push   $0x80108133
80105401:	56                   	push   %esi
80105402:	e8 d9 cb ff ff       	call   80101fe0 <dirlink>
80105407:	83 c4 10             	add    $0x10,%esp
8010540a:	85 c0                	test   %eax,%eax
8010540c:	79 92                	jns    801053a0 <create+0xf0>
      panic("create dots");
8010540e:	83 ec 0c             	sub    $0xc,%esp
80105411:	68 27 81 10 80       	push   $0x80108127
80105416:	e8 65 af ff ff       	call   80100380 <panic>
8010541b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010541f:	90                   	nop
}
80105420:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105423:	31 f6                	xor    %esi,%esi
}
80105425:	5b                   	pop    %ebx
80105426:	89 f0                	mov    %esi,%eax
80105428:	5e                   	pop    %esi
80105429:	5f                   	pop    %edi
8010542a:	5d                   	pop    %ebp
8010542b:	c3                   	ret    
    panic("create: dirlink");
8010542c:	83 ec 0c             	sub    $0xc,%esp
8010542f:	68 36 81 10 80       	push   $0x80108136
80105434:	e8 47 af ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105439:	83 ec 0c             	sub    $0xc,%esp
8010543c:	68 18 81 10 80       	push   $0x80108118
80105441:	e8 3a af ff ff       	call   80100380 <panic>
80105446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010544d:	8d 76 00             	lea    0x0(%esi),%esi

80105450 <sys_dup>:
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	56                   	push   %esi
80105454:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105455:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105458:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010545b:	50                   	push   %eax
8010545c:	6a 00                	push   $0x0
8010545e:	e8 9d fc ff ff       	call   80105100 <argint>
80105463:	83 c4 10             	add    $0x10,%esp
80105466:	85 c0                	test   %eax,%eax
80105468:	78 36                	js     801054a0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010546a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010546e:	77 30                	ja     801054a0 <sys_dup+0x50>
80105470:	e8 eb e8 ff ff       	call   80103d60 <myproc>
80105475:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105478:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010547c:	85 f6                	test   %esi,%esi
8010547e:	74 20                	je     801054a0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105480:	e8 db e8 ff ff       	call   80103d60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105485:	31 db                	xor    %ebx,%ebx
80105487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105490:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105494:	85 d2                	test   %edx,%edx
80105496:	74 18                	je     801054b0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105498:	83 c3 01             	add    $0x1,%ebx
8010549b:	83 fb 10             	cmp    $0x10,%ebx
8010549e:	75 f0                	jne    80105490 <sys_dup+0x40>
}
801054a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801054a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801054a8:	89 d8                	mov    %ebx,%eax
801054aa:	5b                   	pop    %ebx
801054ab:	5e                   	pop    %esi
801054ac:	5d                   	pop    %ebp
801054ad:	c3                   	ret    
801054ae:	66 90                	xchg   %ax,%ax
  filedup(f);
801054b0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054b3:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
801054b7:	56                   	push   %esi
801054b8:	e8 e3 b9 ff ff       	call   80100ea0 <filedup>
  return fd;
801054bd:	83 c4 10             	add    $0x10,%esp
}
801054c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054c3:	89 d8                	mov    %ebx,%eax
801054c5:	5b                   	pop    %ebx
801054c6:	5e                   	pop    %esi
801054c7:	5d                   	pop    %ebp
801054c8:	c3                   	ret    
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054d0 <sys_read>:
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	56                   	push   %esi
801054d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054d5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801054d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054db:	53                   	push   %ebx
801054dc:	6a 00                	push   $0x0
801054de:	e8 1d fc ff ff       	call   80105100 <argint>
801054e3:	83 c4 10             	add    $0x10,%esp
801054e6:	85 c0                	test   %eax,%eax
801054e8:	78 5e                	js     80105548 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054ee:	77 58                	ja     80105548 <sys_read+0x78>
801054f0:	e8 6b e8 ff ff       	call   80103d60 <myproc>
801054f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054f8:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
801054fc:	85 f6                	test   %esi,%esi
801054fe:	74 48                	je     80105548 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105500:	83 ec 08             	sub    $0x8,%esp
80105503:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105506:	50                   	push   %eax
80105507:	6a 02                	push   $0x2
80105509:	e8 f2 fb ff ff       	call   80105100 <argint>
8010550e:	83 c4 10             	add    $0x10,%esp
80105511:	85 c0                	test   %eax,%eax
80105513:	78 33                	js     80105548 <sys_read+0x78>
80105515:	83 ec 04             	sub    $0x4,%esp
80105518:	ff 75 f0             	push   -0x10(%ebp)
8010551b:	53                   	push   %ebx
8010551c:	6a 01                	push   $0x1
8010551e:	e8 2d fc ff ff       	call   80105150 <argptr>
80105523:	83 c4 10             	add    $0x10,%esp
80105526:	85 c0                	test   %eax,%eax
80105528:	78 1e                	js     80105548 <sys_read+0x78>
  return fileread(f, p, n);
8010552a:	83 ec 04             	sub    $0x4,%esp
8010552d:	ff 75 f0             	push   -0x10(%ebp)
80105530:	ff 75 f4             	push   -0xc(%ebp)
80105533:	56                   	push   %esi
80105534:	e8 e7 ba ff ff       	call   80101020 <fileread>
80105539:	83 c4 10             	add    $0x10,%esp
}
8010553c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010553f:	5b                   	pop    %ebx
80105540:	5e                   	pop    %esi
80105541:	5d                   	pop    %ebp
80105542:	c3                   	ret    
80105543:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105547:	90                   	nop
    return -1;
80105548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554d:	eb ed                	jmp    8010553c <sys_read+0x6c>
8010554f:	90                   	nop

80105550 <sys_write>:
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	56                   	push   %esi
80105554:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105555:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105558:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010555b:	53                   	push   %ebx
8010555c:	6a 00                	push   $0x0
8010555e:	e8 9d fb ff ff       	call   80105100 <argint>
80105563:	83 c4 10             	add    $0x10,%esp
80105566:	85 c0                	test   %eax,%eax
80105568:	78 5e                	js     801055c8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010556a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010556e:	77 58                	ja     801055c8 <sys_write+0x78>
80105570:	e8 eb e7 ff ff       	call   80103d60 <myproc>
80105575:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105578:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010557c:	85 f6                	test   %esi,%esi
8010557e:	74 48                	je     801055c8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105580:	83 ec 08             	sub    $0x8,%esp
80105583:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105586:	50                   	push   %eax
80105587:	6a 02                	push   $0x2
80105589:	e8 72 fb ff ff       	call   80105100 <argint>
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	85 c0                	test   %eax,%eax
80105593:	78 33                	js     801055c8 <sys_write+0x78>
80105595:	83 ec 04             	sub    $0x4,%esp
80105598:	ff 75 f0             	push   -0x10(%ebp)
8010559b:	53                   	push   %ebx
8010559c:	6a 01                	push   $0x1
8010559e:	e8 ad fb ff ff       	call   80105150 <argptr>
801055a3:	83 c4 10             	add    $0x10,%esp
801055a6:	85 c0                	test   %eax,%eax
801055a8:	78 1e                	js     801055c8 <sys_write+0x78>
  return filewrite(f, p, n);
801055aa:	83 ec 04             	sub    $0x4,%esp
801055ad:	ff 75 f0             	push   -0x10(%ebp)
801055b0:	ff 75 f4             	push   -0xc(%ebp)
801055b3:	56                   	push   %esi
801055b4:	e8 f7 ba ff ff       	call   801010b0 <filewrite>
801055b9:	83 c4 10             	add    $0x10,%esp
}
801055bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055bf:	5b                   	pop    %ebx
801055c0:	5e                   	pop    %esi
801055c1:	5d                   	pop    %ebp
801055c2:	c3                   	ret    
801055c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055c7:	90                   	nop
    return -1;
801055c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055cd:	eb ed                	jmp    801055bc <sys_write+0x6c>
801055cf:	90                   	nop

801055d0 <sys_close>:
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	56                   	push   %esi
801055d4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801055d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801055d8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055db:	50                   	push   %eax
801055dc:	6a 00                	push   $0x0
801055de:	e8 1d fb ff ff       	call   80105100 <argint>
801055e3:	83 c4 10             	add    $0x10,%esp
801055e6:	85 c0                	test   %eax,%eax
801055e8:	78 3e                	js     80105628 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055ea:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055ee:	77 38                	ja     80105628 <sys_close+0x58>
801055f0:	e8 6b e7 ff ff       	call   80103d60 <myproc>
801055f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055f8:	8d 5a 08             	lea    0x8(%edx),%ebx
801055fb:	8b 74 98 0c          	mov    0xc(%eax,%ebx,4),%esi
801055ff:	85 f6                	test   %esi,%esi
80105601:	74 25                	je     80105628 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105603:	e8 58 e7 ff ff       	call   80103d60 <myproc>
  fileclose(f);
80105608:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010560b:	c7 44 98 0c 00 00 00 	movl   $0x0,0xc(%eax,%ebx,4)
80105612:	00 
  fileclose(f);
80105613:	56                   	push   %esi
80105614:	e8 d7 b8 ff ff       	call   80100ef0 <fileclose>
  return 0;
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	31 c0                	xor    %eax,%eax
}
8010561e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105621:	5b                   	pop    %ebx
80105622:	5e                   	pop    %esi
80105623:	5d                   	pop    %ebp
80105624:	c3                   	ret    
80105625:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562d:	eb ef                	jmp    8010561e <sys_close+0x4e>
8010562f:	90                   	nop

80105630 <sys_fstat>:
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	56                   	push   %esi
80105634:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105635:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105638:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010563b:	53                   	push   %ebx
8010563c:	6a 00                	push   $0x0
8010563e:	e8 bd fa ff ff       	call   80105100 <argint>
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 c0                	test   %eax,%eax
80105648:	78 46                	js     80105690 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010564a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010564e:	77 40                	ja     80105690 <sys_fstat+0x60>
80105650:	e8 0b e7 ff ff       	call   80103d60 <myproc>
80105655:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105658:	8b 74 90 2c          	mov    0x2c(%eax,%edx,4),%esi
8010565c:	85 f6                	test   %esi,%esi
8010565e:	74 30                	je     80105690 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105660:	83 ec 04             	sub    $0x4,%esp
80105663:	6a 14                	push   $0x14
80105665:	53                   	push   %ebx
80105666:	6a 01                	push   $0x1
80105668:	e8 e3 fa ff ff       	call   80105150 <argptr>
8010566d:	83 c4 10             	add    $0x10,%esp
80105670:	85 c0                	test   %eax,%eax
80105672:	78 1c                	js     80105690 <sys_fstat+0x60>
  return filestat(f, st);
80105674:	83 ec 08             	sub    $0x8,%esp
80105677:	ff 75 f4             	push   -0xc(%ebp)
8010567a:	56                   	push   %esi
8010567b:	e8 50 b9 ff ff       	call   80100fd0 <filestat>
80105680:	83 c4 10             	add    $0x10,%esp
}
80105683:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105686:	5b                   	pop    %ebx
80105687:	5e                   	pop    %esi
80105688:	5d                   	pop    %ebp
80105689:	c3                   	ret    
8010568a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105695:	eb ec                	jmp    80105683 <sys_fstat+0x53>
80105697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569e:	66 90                	xchg   %ax,%ax

801056a0 <sys_link>:
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056a8:	53                   	push   %ebx
801056a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056ac:	50                   	push   %eax
801056ad:	6a 00                	push   $0x0
801056af:	e8 0c fb ff ff       	call   801051c0 <argstr>
801056b4:	83 c4 10             	add    $0x10,%esp
801056b7:	85 c0                	test   %eax,%eax
801056b9:	0f 88 fb 00 00 00    	js     801057ba <sys_link+0x11a>
801056bf:	83 ec 08             	sub    $0x8,%esp
801056c2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056c5:	50                   	push   %eax
801056c6:	6a 01                	push   $0x1
801056c8:	e8 f3 fa ff ff       	call   801051c0 <argstr>
801056cd:	83 c4 10             	add    $0x10,%esp
801056d0:	85 c0                	test   %eax,%eax
801056d2:	0f 88 e2 00 00 00    	js     801057ba <sys_link+0x11a>
  begin_op();
801056d8:	e8 63 d6 ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
801056dd:	83 ec 0c             	sub    $0xc,%esp
801056e0:	ff 75 d4             	push   -0x2c(%ebp)
801056e3:	e8 b8 c9 ff ff       	call   801020a0 <namei>
801056e8:	83 c4 10             	add    $0x10,%esp
801056eb:	89 c3                	mov    %eax,%ebx
801056ed:	85 c0                	test   %eax,%eax
801056ef:	0f 84 e4 00 00 00    	je     801057d9 <sys_link+0x139>
  ilock(ip);
801056f5:	83 ec 0c             	sub    $0xc,%esp
801056f8:	50                   	push   %eax
801056f9:	e8 82 c0 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
801056fe:	83 c4 10             	add    $0x10,%esp
80105701:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105706:	0f 84 b5 00 00 00    	je     801057c1 <sys_link+0x121>
  iupdate(ip);
8010570c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010570f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105714:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105717:	53                   	push   %ebx
80105718:	e8 b3 bf ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010571d:	89 1c 24             	mov    %ebx,(%esp)
80105720:	e8 3b c1 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105725:	58                   	pop    %eax
80105726:	5a                   	pop    %edx
80105727:	57                   	push   %edi
80105728:	ff 75 d0             	push   -0x30(%ebp)
8010572b:	e8 90 c9 ff ff       	call   801020c0 <nameiparent>
80105730:	83 c4 10             	add    $0x10,%esp
80105733:	89 c6                	mov    %eax,%esi
80105735:	85 c0                	test   %eax,%eax
80105737:	74 5b                	je     80105794 <sys_link+0xf4>
  ilock(dp);
80105739:	83 ec 0c             	sub    $0xc,%esp
8010573c:	50                   	push   %eax
8010573d:	e8 3e c0 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105742:	8b 03                	mov    (%ebx),%eax
80105744:	83 c4 10             	add    $0x10,%esp
80105747:	39 06                	cmp    %eax,(%esi)
80105749:	75 3d                	jne    80105788 <sys_link+0xe8>
8010574b:	83 ec 04             	sub    $0x4,%esp
8010574e:	ff 73 04             	push   0x4(%ebx)
80105751:	57                   	push   %edi
80105752:	56                   	push   %esi
80105753:	e8 88 c8 ff ff       	call   80101fe0 <dirlink>
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	85 c0                	test   %eax,%eax
8010575d:	78 29                	js     80105788 <sys_link+0xe8>
  iunlockput(dp);
8010575f:	83 ec 0c             	sub    $0xc,%esp
80105762:	56                   	push   %esi
80105763:	e8 a8 c2 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105768:	89 1c 24             	mov    %ebx,(%esp)
8010576b:	e8 40 c1 ff ff       	call   801018b0 <iput>
  end_op();
80105770:	e8 3b d6 ff ff       	call   80102db0 <end_op>
  return 0;
80105775:	83 c4 10             	add    $0x10,%esp
80105778:	31 c0                	xor    %eax,%eax
}
8010577a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010577d:	5b                   	pop    %ebx
8010577e:	5e                   	pop    %esi
8010577f:	5f                   	pop    %edi
80105780:	5d                   	pop    %ebp
80105781:	c3                   	ret    
80105782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105788:	83 ec 0c             	sub    $0xc,%esp
8010578b:	56                   	push   %esi
8010578c:	e8 7f c2 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105791:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105794:	83 ec 0c             	sub    $0xc,%esp
80105797:	53                   	push   %ebx
80105798:	e8 e3 bf ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010579d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057a2:	89 1c 24             	mov    %ebx,(%esp)
801057a5:	e8 26 bf ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801057aa:	89 1c 24             	mov    %ebx,(%esp)
801057ad:	e8 5e c2 ff ff       	call   80101a10 <iunlockput>
  end_op();
801057b2:	e8 f9 d5 ff ff       	call   80102db0 <end_op>
  return -1;
801057b7:	83 c4 10             	add    $0x10,%esp
801057ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057bf:	eb b9                	jmp    8010577a <sys_link+0xda>
    iunlockput(ip);
801057c1:	83 ec 0c             	sub    $0xc,%esp
801057c4:	53                   	push   %ebx
801057c5:	e8 46 c2 ff ff       	call   80101a10 <iunlockput>
    end_op();
801057ca:	e8 e1 d5 ff ff       	call   80102db0 <end_op>
    return -1;
801057cf:	83 c4 10             	add    $0x10,%esp
801057d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d7:	eb a1                	jmp    8010577a <sys_link+0xda>
    end_op();
801057d9:	e8 d2 d5 ff ff       	call   80102db0 <end_op>
    return -1;
801057de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e3:	eb 95                	jmp    8010577a <sys_link+0xda>
801057e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_unlink>:
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801057f5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801057f8:	53                   	push   %ebx
801057f9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801057fc:	50                   	push   %eax
801057fd:	6a 00                	push   $0x0
801057ff:	e8 bc f9 ff ff       	call   801051c0 <argstr>
80105804:	83 c4 10             	add    $0x10,%esp
80105807:	85 c0                	test   %eax,%eax
80105809:	0f 88 7a 01 00 00    	js     80105989 <sys_unlink+0x199>
  begin_op();
8010580f:	e8 2c d5 ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105814:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105817:	83 ec 08             	sub    $0x8,%esp
8010581a:	53                   	push   %ebx
8010581b:	ff 75 c0             	push   -0x40(%ebp)
8010581e:	e8 9d c8 ff ff       	call   801020c0 <nameiparent>
80105823:	83 c4 10             	add    $0x10,%esp
80105826:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105829:	85 c0                	test   %eax,%eax
8010582b:	0f 84 62 01 00 00    	je     80105993 <sys_unlink+0x1a3>
  ilock(dp);
80105831:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105834:	83 ec 0c             	sub    $0xc,%esp
80105837:	57                   	push   %edi
80105838:	e8 43 bf ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010583d:	58                   	pop    %eax
8010583e:	5a                   	pop    %edx
8010583f:	68 34 81 10 80       	push   $0x80108134
80105844:	53                   	push   %ebx
80105845:	e8 76 c4 ff ff       	call   80101cc0 <namecmp>
8010584a:	83 c4 10             	add    $0x10,%esp
8010584d:	85 c0                	test   %eax,%eax
8010584f:	0f 84 fb 00 00 00    	je     80105950 <sys_unlink+0x160>
80105855:	83 ec 08             	sub    $0x8,%esp
80105858:	68 33 81 10 80       	push   $0x80108133
8010585d:	53                   	push   %ebx
8010585e:	e8 5d c4 ff ff       	call   80101cc0 <namecmp>
80105863:	83 c4 10             	add    $0x10,%esp
80105866:	85 c0                	test   %eax,%eax
80105868:	0f 84 e2 00 00 00    	je     80105950 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010586e:	83 ec 04             	sub    $0x4,%esp
80105871:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105874:	50                   	push   %eax
80105875:	53                   	push   %ebx
80105876:	57                   	push   %edi
80105877:	e8 64 c4 ff ff       	call   80101ce0 <dirlookup>
8010587c:	83 c4 10             	add    $0x10,%esp
8010587f:	89 c3                	mov    %eax,%ebx
80105881:	85 c0                	test   %eax,%eax
80105883:	0f 84 c7 00 00 00    	je     80105950 <sys_unlink+0x160>
  ilock(ip);
80105889:	83 ec 0c             	sub    $0xc,%esp
8010588c:	50                   	push   %eax
8010588d:	e8 ee be ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010589a:	0f 8e 1c 01 00 00    	jle    801059bc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801058a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058a5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801058a8:	74 66                	je     80105910 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801058aa:	83 ec 04             	sub    $0x4,%esp
801058ad:	6a 10                	push   $0x10
801058af:	6a 00                	push   $0x0
801058b1:	57                   	push   %edi
801058b2:	e8 89 f5 ff ff       	call   80104e40 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058b7:	6a 10                	push   $0x10
801058b9:	ff 75 c4             	push   -0x3c(%ebp)
801058bc:	57                   	push   %edi
801058bd:	ff 75 b4             	push   -0x4c(%ebp)
801058c0:	e8 cb c2 ff ff       	call   80101b90 <writei>
801058c5:	83 c4 20             	add    $0x20,%esp
801058c8:	83 f8 10             	cmp    $0x10,%eax
801058cb:	0f 85 de 00 00 00    	jne    801059af <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801058d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058d6:	0f 84 94 00 00 00    	je     80105970 <sys_unlink+0x180>
  iunlockput(dp);
801058dc:	83 ec 0c             	sub    $0xc,%esp
801058df:	ff 75 b4             	push   -0x4c(%ebp)
801058e2:	e8 29 c1 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801058e7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058ec:	89 1c 24             	mov    %ebx,(%esp)
801058ef:	e8 dc bd ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801058f4:	89 1c 24             	mov    %ebx,(%esp)
801058f7:	e8 14 c1 ff ff       	call   80101a10 <iunlockput>
  end_op();
801058fc:	e8 af d4 ff ff       	call   80102db0 <end_op>
  return 0;
80105901:	83 c4 10             	add    $0x10,%esp
80105904:	31 c0                	xor    %eax,%eax
}
80105906:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105909:	5b                   	pop    %ebx
8010590a:	5e                   	pop    %esi
8010590b:	5f                   	pop    %edi
8010590c:	5d                   	pop    %ebp
8010590d:	c3                   	ret    
8010590e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105910:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105914:	76 94                	jbe    801058aa <sys_unlink+0xba>
80105916:	be 20 00 00 00       	mov    $0x20,%esi
8010591b:	eb 0b                	jmp    80105928 <sys_unlink+0x138>
8010591d:	8d 76 00             	lea    0x0(%esi),%esi
80105920:	83 c6 10             	add    $0x10,%esi
80105923:	3b 73 58             	cmp    0x58(%ebx),%esi
80105926:	73 82                	jae    801058aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105928:	6a 10                	push   $0x10
8010592a:	56                   	push   %esi
8010592b:	57                   	push   %edi
8010592c:	53                   	push   %ebx
8010592d:	e8 5e c1 ff ff       	call   80101a90 <readi>
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	83 f8 10             	cmp    $0x10,%eax
80105938:	75 68                	jne    801059a2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010593a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010593f:	74 df                	je     80105920 <sys_unlink+0x130>
    iunlockput(ip);
80105941:	83 ec 0c             	sub    $0xc,%esp
80105944:	53                   	push   %ebx
80105945:	e8 c6 c0 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010594a:	83 c4 10             	add    $0x10,%esp
8010594d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105950:	83 ec 0c             	sub    $0xc,%esp
80105953:	ff 75 b4             	push   -0x4c(%ebp)
80105956:	e8 b5 c0 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010595b:	e8 50 d4 ff ff       	call   80102db0 <end_op>
  return -1;
80105960:	83 c4 10             	add    $0x10,%esp
80105963:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105968:	eb 9c                	jmp    80105906 <sys_unlink+0x116>
8010596a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105970:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105973:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105976:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010597b:	50                   	push   %eax
8010597c:	e8 4f bd ff ff       	call   801016d0 <iupdate>
80105981:	83 c4 10             	add    $0x10,%esp
80105984:	e9 53 ff ff ff       	jmp    801058dc <sys_unlink+0xec>
    return -1;
80105989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010598e:	e9 73 ff ff ff       	jmp    80105906 <sys_unlink+0x116>
    end_op();
80105993:	e8 18 d4 ff ff       	call   80102db0 <end_op>
    return -1;
80105998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010599d:	e9 64 ff ff ff       	jmp    80105906 <sys_unlink+0x116>
      panic("isdirempty: readi");
801059a2:	83 ec 0c             	sub    $0xc,%esp
801059a5:	68 58 81 10 80       	push   $0x80108158
801059aa:	e8 d1 a9 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801059af:	83 ec 0c             	sub    $0xc,%esp
801059b2:	68 6a 81 10 80       	push   $0x8010816a
801059b7:	e8 c4 a9 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801059bc:	83 ec 0c             	sub    $0xc,%esp
801059bf:	68 46 81 10 80       	push   $0x80108146
801059c4:	e8 b7 a9 ff ff       	call   80100380 <panic>
801059c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_open>:

int
sys_open(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	57                   	push   %edi
801059d4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801059d8:	53                   	push   %ebx
801059d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059dc:	50                   	push   %eax
801059dd:	6a 00                	push   $0x0
801059df:	e8 dc f7 ff ff       	call   801051c0 <argstr>
801059e4:	83 c4 10             	add    $0x10,%esp
801059e7:	85 c0                	test   %eax,%eax
801059e9:	0f 88 8e 00 00 00    	js     80105a7d <sys_open+0xad>
801059ef:	83 ec 08             	sub    $0x8,%esp
801059f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059f5:	50                   	push   %eax
801059f6:	6a 01                	push   $0x1
801059f8:	e8 03 f7 ff ff       	call   80105100 <argint>
801059fd:	83 c4 10             	add    $0x10,%esp
80105a00:	85 c0                	test   %eax,%eax
80105a02:	78 79                	js     80105a7d <sys_open+0xad>
    return -1;

  begin_op();
80105a04:	e8 37 d3 ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
80105a09:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a0d:	75 79                	jne    80105a88 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a0f:	83 ec 0c             	sub    $0xc,%esp
80105a12:	ff 75 e0             	push   -0x20(%ebp)
80105a15:	e8 86 c6 ff ff       	call   801020a0 <namei>
80105a1a:	83 c4 10             	add    $0x10,%esp
80105a1d:	89 c6                	mov    %eax,%esi
80105a1f:	85 c0                	test   %eax,%eax
80105a21:	0f 84 7e 00 00 00    	je     80105aa5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105a27:	83 ec 0c             	sub    $0xc,%esp
80105a2a:	50                   	push   %eax
80105a2b:	e8 50 bd ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a30:	83 c4 10             	add    $0x10,%esp
80105a33:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a38:	0f 84 c2 00 00 00    	je     80105b00 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a3e:	e8 ed b3 ff ff       	call   80100e30 <filealloc>
80105a43:	89 c7                	mov    %eax,%edi
80105a45:	85 c0                	test   %eax,%eax
80105a47:	74 23                	je     80105a6c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105a49:	e8 12 e3 ff ff       	call   80103d60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a4e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105a50:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105a54:	85 d2                	test   %edx,%edx
80105a56:	74 60                	je     80105ab8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105a58:	83 c3 01             	add    $0x1,%ebx
80105a5b:	83 fb 10             	cmp    $0x10,%ebx
80105a5e:	75 f0                	jne    80105a50 <sys_open+0x80>
    if(f)
      fileclose(f);
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	57                   	push   %edi
80105a64:	e8 87 b4 ff ff       	call   80100ef0 <fileclose>
80105a69:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a6c:	83 ec 0c             	sub    $0xc,%esp
80105a6f:	56                   	push   %esi
80105a70:	e8 9b bf ff ff       	call   80101a10 <iunlockput>
    end_op();
80105a75:	e8 36 d3 ff ff       	call   80102db0 <end_op>
    return -1;
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a82:	eb 6d                	jmp    80105af1 <sys_open+0x121>
80105a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a8e:	31 c9                	xor    %ecx,%ecx
80105a90:	ba 02 00 00 00       	mov    $0x2,%edx
80105a95:	6a 00                	push   $0x0
80105a97:	e8 14 f8 ff ff       	call   801052b0 <create>
    if(ip == 0){
80105a9c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105a9f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105aa1:	85 c0                	test   %eax,%eax
80105aa3:	75 99                	jne    80105a3e <sys_open+0x6e>
      end_op();
80105aa5:	e8 06 d3 ff ff       	call   80102db0 <end_op>
      return -1;
80105aaa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105aaf:	eb 40                	jmp    80105af1 <sys_open+0x121>
80105ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105abb:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
80105abf:	56                   	push   %esi
80105ac0:	e8 9b bd ff ff       	call   80101860 <iunlock>
  end_op();
80105ac5:	e8 e6 d2 ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
80105aca:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105ad0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ad3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105ad6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105ad9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105adb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105ae2:	f7 d0                	not    %eax
80105ae4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ae7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105aea:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105aed:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105af4:	89 d8                	mov    %ebx,%eax
80105af6:	5b                   	pop    %ebx
80105af7:	5e                   	pop    %esi
80105af8:	5f                   	pop    %edi
80105af9:	5d                   	pop    %ebp
80105afa:	c3                   	ret    
80105afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aff:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b00:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b03:	85 c9                	test   %ecx,%ecx
80105b05:	0f 84 33 ff ff ff    	je     80105a3e <sys_open+0x6e>
80105b0b:	e9 5c ff ff ff       	jmp    80105a6c <sys_open+0x9c>

80105b10 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b16:	e8 25 d2 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b1b:	83 ec 08             	sub    $0x8,%esp
80105b1e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b21:	50                   	push   %eax
80105b22:	6a 00                	push   $0x0
80105b24:	e8 97 f6 ff ff       	call   801051c0 <argstr>
80105b29:	83 c4 10             	add    $0x10,%esp
80105b2c:	85 c0                	test   %eax,%eax
80105b2e:	78 30                	js     80105b60 <sys_mkdir+0x50>
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b36:	31 c9                	xor    %ecx,%ecx
80105b38:	ba 01 00 00 00       	mov    $0x1,%edx
80105b3d:	6a 00                	push   $0x0
80105b3f:	e8 6c f7 ff ff       	call   801052b0 <create>
80105b44:	83 c4 10             	add    $0x10,%esp
80105b47:	85 c0                	test   %eax,%eax
80105b49:	74 15                	je     80105b60 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b4b:	83 ec 0c             	sub    $0xc,%esp
80105b4e:	50                   	push   %eax
80105b4f:	e8 bc be ff ff       	call   80101a10 <iunlockput>
  end_op();
80105b54:	e8 57 d2 ff ff       	call   80102db0 <end_op>
  return 0;
80105b59:	83 c4 10             	add    $0x10,%esp
80105b5c:	31 c0                	xor    %eax,%eax
}
80105b5e:	c9                   	leave  
80105b5f:	c3                   	ret    
    end_op();
80105b60:	e8 4b d2 ff ff       	call   80102db0 <end_op>
    return -1;
80105b65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b6a:	c9                   	leave  
80105b6b:	c3                   	ret    
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <sys_mknod>:

int
sys_mknod(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105b76:	e8 c5 d1 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105b7b:	83 ec 08             	sub    $0x8,%esp
80105b7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b81:	50                   	push   %eax
80105b82:	6a 00                	push   $0x0
80105b84:	e8 37 f6 ff ff       	call   801051c0 <argstr>
80105b89:	83 c4 10             	add    $0x10,%esp
80105b8c:	85 c0                	test   %eax,%eax
80105b8e:	78 60                	js     80105bf0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105b90:	83 ec 08             	sub    $0x8,%esp
80105b93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b96:	50                   	push   %eax
80105b97:	6a 01                	push   $0x1
80105b99:	e8 62 f5 ff ff       	call   80105100 <argint>
  if((argstr(0, &path)) < 0 ||
80105b9e:	83 c4 10             	add    $0x10,%esp
80105ba1:	85 c0                	test   %eax,%eax
80105ba3:	78 4b                	js     80105bf0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105ba5:	83 ec 08             	sub    $0x8,%esp
80105ba8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bab:	50                   	push   %eax
80105bac:	6a 02                	push   $0x2
80105bae:	e8 4d f5 ff ff       	call   80105100 <argint>
     argint(1, &major) < 0 ||
80105bb3:	83 c4 10             	add    $0x10,%esp
80105bb6:	85 c0                	test   %eax,%eax
80105bb8:	78 36                	js     80105bf0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105bba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105bbe:	83 ec 0c             	sub    $0xc,%esp
80105bc1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105bc5:	ba 03 00 00 00       	mov    $0x3,%edx
80105bca:	50                   	push   %eax
80105bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105bce:	e8 dd f6 ff ff       	call   801052b0 <create>
     argint(2, &minor) < 0 ||
80105bd3:	83 c4 10             	add    $0x10,%esp
80105bd6:	85 c0                	test   %eax,%eax
80105bd8:	74 16                	je     80105bf0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bda:	83 ec 0c             	sub    $0xc,%esp
80105bdd:	50                   	push   %eax
80105bde:	e8 2d be ff ff       	call   80101a10 <iunlockput>
  end_op();
80105be3:	e8 c8 d1 ff ff       	call   80102db0 <end_op>
  return 0;
80105be8:	83 c4 10             	add    $0x10,%esp
80105beb:	31 c0                	xor    %eax,%eax
}
80105bed:	c9                   	leave  
80105bee:	c3                   	ret    
80105bef:	90                   	nop
    end_op();
80105bf0:	e8 bb d1 ff ff       	call   80102db0 <end_op>
    return -1;
80105bf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bfa:	c9                   	leave  
80105bfb:	c3                   	ret    
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c00 <sys_chdir>:

int
sys_chdir(void)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	56                   	push   %esi
80105c04:	53                   	push   %ebx
80105c05:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c08:	e8 53 e1 ff ff       	call   80103d60 <myproc>
80105c0d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c0f:	e8 2c d1 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c14:	83 ec 08             	sub    $0x8,%esp
80105c17:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c1a:	50                   	push   %eax
80105c1b:	6a 00                	push   $0x0
80105c1d:	e8 9e f5 ff ff       	call   801051c0 <argstr>
80105c22:	83 c4 10             	add    $0x10,%esp
80105c25:	85 c0                	test   %eax,%eax
80105c27:	78 77                	js     80105ca0 <sys_chdir+0xa0>
80105c29:	83 ec 0c             	sub    $0xc,%esp
80105c2c:	ff 75 f4             	push   -0xc(%ebp)
80105c2f:	e8 6c c4 ff ff       	call   801020a0 <namei>
80105c34:	83 c4 10             	add    $0x10,%esp
80105c37:	89 c3                	mov    %eax,%ebx
80105c39:	85 c0                	test   %eax,%eax
80105c3b:	74 63                	je     80105ca0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c3d:	83 ec 0c             	sub    $0xc,%esp
80105c40:	50                   	push   %eax
80105c41:	e8 3a bb ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105c46:	83 c4 10             	add    $0x10,%esp
80105c49:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c4e:	75 30                	jne    80105c80 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c50:	83 ec 0c             	sub    $0xc,%esp
80105c53:	53                   	push   %ebx
80105c54:	e8 07 bc ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105c59:	58                   	pop    %eax
80105c5a:	ff 76 6c             	push   0x6c(%esi)
80105c5d:	e8 4e bc ff ff       	call   801018b0 <iput>
  end_op();
80105c62:	e8 49 d1 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
80105c67:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
80105c6a:	83 c4 10             	add    $0x10,%esp
80105c6d:	31 c0                	xor    %eax,%eax
}
80105c6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c72:	5b                   	pop    %ebx
80105c73:	5e                   	pop    %esi
80105c74:	5d                   	pop    %ebp
80105c75:	c3                   	ret    
80105c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	53                   	push   %ebx
80105c84:	e8 87 bd ff ff       	call   80101a10 <iunlockput>
    end_op();
80105c89:	e8 22 d1 ff ff       	call   80102db0 <end_op>
    return -1;
80105c8e:	83 c4 10             	add    $0x10,%esp
80105c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c96:	eb d7                	jmp    80105c6f <sys_chdir+0x6f>
80105c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9f:	90                   	nop
    end_op();
80105ca0:	e8 0b d1 ff ff       	call   80102db0 <end_op>
    return -1;
80105ca5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105caa:	eb c3                	jmp    80105c6f <sys_chdir+0x6f>
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <sys_exec>:

int
sys_exec(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	57                   	push   %edi
80105cb4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cb5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105cbb:	53                   	push   %ebx
80105cbc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cc2:	50                   	push   %eax
80105cc3:	6a 00                	push   $0x0
80105cc5:	e8 f6 f4 ff ff       	call   801051c0 <argstr>
80105cca:	83 c4 10             	add    $0x10,%esp
80105ccd:	85 c0                	test   %eax,%eax
80105ccf:	0f 88 87 00 00 00    	js     80105d5c <sys_exec+0xac>
80105cd5:	83 ec 08             	sub    $0x8,%esp
80105cd8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105cde:	50                   	push   %eax
80105cdf:	6a 01                	push   $0x1
80105ce1:	e8 1a f4 ff ff       	call   80105100 <argint>
80105ce6:	83 c4 10             	add    $0x10,%esp
80105ce9:	85 c0                	test   %eax,%eax
80105ceb:	78 6f                	js     80105d5c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105ced:	83 ec 04             	sub    $0x4,%esp
80105cf0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105cf6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105cf8:	68 80 00 00 00       	push   $0x80
80105cfd:	6a 00                	push   $0x0
80105cff:	56                   	push   %esi
80105d00:	e8 3b f1 ff ff       	call   80104e40 <memset>
80105d05:	83 c4 10             	add    $0x10,%esp
80105d08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d10:	83 ec 08             	sub    $0x8,%esp
80105d13:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105d19:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105d20:	50                   	push   %eax
80105d21:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d27:	01 f8                	add    %edi,%eax
80105d29:	50                   	push   %eax
80105d2a:	e8 41 f3 ff ff       	call   80105070 <fetchint>
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	85 c0                	test   %eax,%eax
80105d34:	78 26                	js     80105d5c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105d36:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d3c:	85 c0                	test   %eax,%eax
80105d3e:	74 30                	je     80105d70 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d40:	83 ec 08             	sub    $0x8,%esp
80105d43:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105d46:	52                   	push   %edx
80105d47:	50                   	push   %eax
80105d48:	e8 63 f3 ff ff       	call   801050b0 <fetchstr>
80105d4d:	83 c4 10             	add    $0x10,%esp
80105d50:	85 c0                	test   %eax,%eax
80105d52:	78 08                	js     80105d5c <sys_exec+0xac>
  for(i=0;; i++){
80105d54:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105d57:	83 fb 20             	cmp    $0x20,%ebx
80105d5a:	75 b4                	jne    80105d10 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105d5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d64:	5b                   	pop    %ebx
80105d65:	5e                   	pop    %esi
80105d66:	5f                   	pop    %edi
80105d67:	5d                   	pop    %ebp
80105d68:	c3                   	ret    
80105d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105d70:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105d77:	00 00 00 00 
  return exec(path, argv);
80105d7b:	83 ec 08             	sub    $0x8,%esp
80105d7e:	56                   	push   %esi
80105d7f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105d85:	e8 26 ad ff ff       	call   80100ab0 <exec>
80105d8a:	83 c4 10             	add    $0x10,%esp
}
80105d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d90:	5b                   	pop    %ebx
80105d91:	5e                   	pop    %esi
80105d92:	5f                   	pop    %edi
80105d93:	5d                   	pop    %ebp
80105d94:	c3                   	ret    
80105d95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105da0 <sys_pipe>:

int
sys_pipe(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105da5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105da8:	53                   	push   %ebx
80105da9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105dac:	6a 08                	push   $0x8
80105dae:	50                   	push   %eax
80105daf:	6a 00                	push   $0x0
80105db1:	e8 9a f3 ff ff       	call   80105150 <argptr>
80105db6:	83 c4 10             	add    $0x10,%esp
80105db9:	85 c0                	test   %eax,%eax
80105dbb:	78 4a                	js     80105e07 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105dbd:	83 ec 08             	sub    $0x8,%esp
80105dc0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105dc3:	50                   	push   %eax
80105dc4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105dc7:	50                   	push   %eax
80105dc8:	e8 33 d6 ff ff       	call   80103400 <pipealloc>
80105dcd:	83 c4 10             	add    $0x10,%esp
80105dd0:	85 c0                	test   %eax,%eax
80105dd2:	78 33                	js     80105e07 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105dd4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105dd7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105dd9:	e8 82 df ff ff       	call   80103d60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105dde:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105de0:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105de4:	85 f6                	test   %esi,%esi
80105de6:	74 28                	je     80105e10 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105de8:	83 c3 01             	add    $0x1,%ebx
80105deb:	83 fb 10             	cmp    $0x10,%ebx
80105dee:	75 f0                	jne    80105de0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105df0:	83 ec 0c             	sub    $0xc,%esp
80105df3:	ff 75 e0             	push   -0x20(%ebp)
80105df6:	e8 f5 b0 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80105dfb:	58                   	pop    %eax
80105dfc:	ff 75 e4             	push   -0x1c(%ebp)
80105dff:	e8 ec b0 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105e04:	83 c4 10             	add    $0x10,%esp
80105e07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e0c:	eb 53                	jmp    80105e61 <sys_pipe+0xc1>
80105e0e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e10:	8d 73 08             	lea    0x8(%ebx),%esi
80105e13:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e1a:	e8 41 df ff ff       	call   80103d60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e1f:	31 d2                	xor    %edx,%edx
80105e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e28:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80105e2c:	85 c9                	test   %ecx,%ecx
80105e2e:	74 20                	je     80105e50 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105e30:	83 c2 01             	add    $0x1,%edx
80105e33:	83 fa 10             	cmp    $0x10,%edx
80105e36:	75 f0                	jne    80105e28 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105e38:	e8 23 df ff ff       	call   80103d60 <myproc>
80105e3d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105e44:	00 
80105e45:	eb a9                	jmp    80105df0 <sys_pipe+0x50>
80105e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e50:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
  }
  fd[0] = fd0;
80105e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e57:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e59:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e5c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105e5f:	31 c0                	xor    %eax,%eax
}
80105e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e64:	5b                   	pop    %ebx
80105e65:	5e                   	pop    %esi
80105e66:	5f                   	pop    %edi
80105e67:	5d                   	pop    %ebp
80105e68:	c3                   	ret    
80105e69:	66 90                	xchg   %ax,%ax
80105e6b:	66 90                	xchg   %ax,%ax
80105e6d:	66 90                	xchg   %ax,%ax
80105e6f:	90                   	nop

80105e70 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105e70:	e9 8b e0 ff ff       	jmp    80103f00 <fork>
80105e75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e80 <sys_exit>:
}

int
sys_exit(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e86:	e8 f5 e4 ff ff       	call   80104380 <exit>
  return 0;  // not reached
}
80105e8b:	31 c0                	xor    %eax,%eax
80105e8d:	c9                   	leave  
80105e8e:	c3                   	ret    
80105e8f:	90                   	nop

80105e90 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105e90:	e9 1b e6 ff ff       	jmp    801044b0 <wait>
80105e95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ea0 <sys_kill>:
}

int
sys_kill(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ea6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ea9:	50                   	push   %eax
80105eaa:	6a 00                	push   $0x0
80105eac:	e8 4f f2 ff ff       	call   80105100 <argint>
80105eb1:	83 c4 10             	add    $0x10,%esp
80105eb4:	85 c0                	test   %eax,%eax
80105eb6:	78 18                	js     80105ed0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105eb8:	83 ec 0c             	sub    $0xc,%esp
80105ebb:	ff 75 f4             	push   -0xc(%ebp)
80105ebe:	e8 4d ea ff ff       	call   80104910 <kill>
80105ec3:	83 c4 10             	add    $0x10,%esp
}
80105ec6:	c9                   	leave  
80105ec7:	c3                   	ret    
80105ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ecf:	90                   	nop
80105ed0:	c9                   	leave  
    return -1;
80105ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ed6:	c3                   	ret    
80105ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ede:	66 90                	xchg   %ax,%ax

80105ee0 <sys_getpid>:

int
sys_getpid(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ee6:	e8 75 de ff ff       	call   80103d60 <myproc>
80105eeb:	8b 40 14             	mov    0x14(%eax),%eax
}
80105eee:	c9                   	leave  
80105eef:	c3                   	ret    

80105ef0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ef4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ef7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105efa:	50                   	push   %eax
80105efb:	6a 00                	push   $0x0
80105efd:	e8 fe f1 ff ff       	call   80105100 <argint>
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	85 c0                	test   %eax,%eax
80105f07:	78 27                	js     80105f30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f09:	e8 52 de ff ff       	call   80103d60 <myproc>
  if(growproc(n) < 0)
80105f0e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105f11:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f13:	ff 75 f4             	push   -0xc(%ebp)
80105f16:	e8 65 df ff ff       	call   80103e80 <growproc>
80105f1b:	83 c4 10             	add    $0x10,%esp
80105f1e:	85 c0                	test   %eax,%eax
80105f20:	78 0e                	js     80105f30 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105f22:	89 d8                	mov    %ebx,%eax
80105f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f27:	c9                   	leave  
80105f28:	c3                   	ret    
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f35:	eb eb                	jmp    80105f22 <sys_sbrk+0x32>
80105f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <sys_sleep>:

int
sys_sleep(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f4a:	50                   	push   %eax
80105f4b:	6a 00                	push   $0x0
80105f4d:	e8 ae f1 ff ff       	call   80105100 <argint>
80105f52:	83 c4 10             	add    $0x10,%esp
80105f55:	85 c0                	test   %eax,%eax
80105f57:	0f 88 8a 00 00 00    	js     80105fe7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105f5d:	83 ec 0c             	sub    $0xc,%esp
80105f60:	68 e0 54 11 80       	push   $0x801154e0
80105f65:	e8 16 ee ff ff       	call   80104d80 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105f6d:	8b 1d c0 54 11 80    	mov    0x801154c0,%ebx
  while(ticks - ticks0 < n){
80105f73:	83 c4 10             	add    $0x10,%esp
80105f76:	85 d2                	test   %edx,%edx
80105f78:	75 27                	jne    80105fa1 <sys_sleep+0x61>
80105f7a:	eb 54                	jmp    80105fd0 <sys_sleep+0x90>
80105f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105f80:	83 ec 08             	sub    $0x8,%esp
80105f83:	68 e0 54 11 80       	push   $0x801154e0
80105f88:	68 c0 54 11 80       	push   $0x801154c0
80105f8d:	e8 5e e8 ff ff       	call   801047f0 <sleep>
  while(ticks - ticks0 < n){
80105f92:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80105f97:	83 c4 10             	add    $0x10,%esp
80105f9a:	29 d8                	sub    %ebx,%eax
80105f9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105f9f:	73 2f                	jae    80105fd0 <sys_sleep+0x90>
    if(myproc()->killed){
80105fa1:	e8 ba dd ff ff       	call   80103d60 <myproc>
80105fa6:	8b 40 28             	mov    0x28(%eax),%eax
80105fa9:	85 c0                	test   %eax,%eax
80105fab:	74 d3                	je     80105f80 <sys_sleep+0x40>
      release(&tickslock);
80105fad:	83 ec 0c             	sub    $0xc,%esp
80105fb0:	68 e0 54 11 80       	push   $0x801154e0
80105fb5:	e8 66 ed ff ff       	call   80104d20 <release>
  }
  release(&tickslock);
  return 0;
}
80105fba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105fbd:	83 c4 10             	add    $0x10,%esp
80105fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fc5:	c9                   	leave  
80105fc6:	c3                   	ret    
80105fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	68 e0 54 11 80       	push   $0x801154e0
80105fd8:	e8 43 ed ff ff       	call   80104d20 <release>
  return 0;
80105fdd:	83 c4 10             	add    $0x10,%esp
80105fe0:	31 c0                	xor    %eax,%eax
}
80105fe2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fe5:	c9                   	leave  
80105fe6:	c3                   	ret    
    return -1;
80105fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fec:	eb f4                	jmp    80105fe2 <sys_sleep+0xa2>
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	53                   	push   %ebx
80105ff4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ff7:	68 e0 54 11 80       	push   $0x801154e0
80105ffc:	e8 7f ed ff ff       	call   80104d80 <acquire>
  xticks = ticks;
80106001:	8b 1d c0 54 11 80    	mov    0x801154c0,%ebx
  release(&tickslock);
80106007:	c7 04 24 e0 54 11 80 	movl   $0x801154e0,(%esp)
8010600e:	e8 0d ed ff ff       	call   80104d20 <release>
  return xticks;
}
80106013:	89 d8                	mov    %ebx,%eax
80106015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106018:	c9                   	leave  
80106019:	c3                   	ret    

8010601a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010601a:	1e                   	push   %ds
  pushl %es
8010601b:	06                   	push   %es
  pushl %fs
8010601c:	0f a0                	push   %fs
  pushl %gs
8010601e:	0f a8                	push   %gs
  pushal
80106020:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106021:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106025:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106027:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106029:	54                   	push   %esp
  call trap
8010602a:	e8 c1 00 00 00       	call   801060f0 <trap>
  addl $4, %esp
8010602f:	83 c4 04             	add    $0x4,%esp

80106032 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106032:	61                   	popa   
  popl %gs
80106033:	0f a9                	pop    %gs
  popl %fs
80106035:	0f a1                	pop    %fs
  popl %es
80106037:	07                   	pop    %es
  popl %ds
80106038:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106039:	83 c4 08             	add    $0x8,%esp
  iret
8010603c:	cf                   	iret   
8010603d:	66 90                	xchg   %ax,%ax
8010603f:	90                   	nop

80106040 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106040:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106041:	31 c0                	xor    %eax,%eax
{
80106043:	89 e5                	mov    %esp,%ebp
80106045:	83 ec 08             	sub    $0x8,%esp
80106048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010604f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106050:	8b 14 85 18 b0 10 80 	mov    -0x7fef4fe8(,%eax,4),%edx
80106057:	c7 04 c5 22 55 11 80 	movl   $0x8e000008,-0x7feeaade(,%eax,8)
8010605e:	08 00 00 8e 
80106062:	66 89 14 c5 20 55 11 	mov    %dx,-0x7feeaae0(,%eax,8)
80106069:	80 
8010606a:	c1 ea 10             	shr    $0x10,%edx
8010606d:	66 89 14 c5 26 55 11 	mov    %dx,-0x7feeaada(,%eax,8)
80106074:	80 
  for(i = 0; i < 256; i++)
80106075:	83 c0 01             	add    $0x1,%eax
80106078:	3d 00 01 00 00       	cmp    $0x100,%eax
8010607d:	75 d1                	jne    80106050 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010607f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106082:	a1 18 b1 10 80       	mov    0x8010b118,%eax
80106087:	c7 05 22 57 11 80 08 	movl   $0xef000008,0x80115722
8010608e:	00 00 ef 
  initlock(&tickslock, "time");
80106091:	68 79 81 10 80       	push   $0x80108179
80106096:	68 e0 54 11 80       	push   $0x801154e0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010609b:	66 a3 20 57 11 80    	mov    %ax,0x80115720
801060a1:	c1 e8 10             	shr    $0x10,%eax
801060a4:	66 a3 26 57 11 80    	mov    %ax,0x80115726
  initlock(&tickslock, "time");
801060aa:	e8 01 eb ff ff       	call   80104bb0 <initlock>
}
801060af:	83 c4 10             	add    $0x10,%esp
801060b2:	c9                   	leave  
801060b3:	c3                   	ret    
801060b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060bf:	90                   	nop

801060c0 <idtinit>:

void
idtinit(void)
{
801060c0:	55                   	push   %ebp
  pd[0] = size-1;
801060c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801060c6:	89 e5                	mov    %esp,%ebp
801060c8:	83 ec 10             	sub    $0x10,%esp
801060cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801060cf:	b8 20 55 11 80       	mov    $0x80115520,%eax
801060d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801060d8:	c1 e8 10             	shr    $0x10,%eax
801060db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801060df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801060e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801060e5:	c9                   	leave  
801060e6:	c3                   	ret    
801060e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ee:	66 90                	xchg   %ax,%ax

801060f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	57                   	push   %edi
801060f4:	56                   	push   %esi
801060f5:	53                   	push   %ebx
801060f6:	83 ec 1c             	sub    $0x1c,%esp
801060f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801060fc:	8b 43 30             	mov    0x30(%ebx),%eax
801060ff:	83 f8 40             	cmp    $0x40,%eax
80106102:	0f 84 70 01 00 00    	je     80106278 <trap+0x188>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106108:	83 e8 20             	sub    $0x20,%eax
8010610b:	83 f8 1f             	cmp    $0x1f,%eax
8010610e:	0f 87 8c 00 00 00    	ja     801061a0 <trap+0xb0>
80106114:	ff 24 85 20 82 10 80 	jmp    *-0x7fef7de0(,%eax,4)
8010611b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010611f:	90                   	nop
      myproc()->rtime++;
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106120:	e8 1b c1 ff ff       	call   80102240 <ideintr>
    lapiceoi();
80106125:	e8 d6 c7 ff ff       	call   80102900 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010612a:	e8 31 dc ff ff       	call   80103d60 <myproc>
8010612f:	85 c0                	test   %eax,%eax
80106131:	74 1d                	je     80106150 <trap+0x60>
80106133:	e8 28 dc ff ff       	call   80103d60 <myproc>
80106138:	8b 50 28             	mov    0x28(%eax),%edx
8010613b:	85 d2                	test   %edx,%edx
8010613d:	74 11                	je     80106150 <trap+0x60>
8010613f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106143:	83 e0 03             	and    $0x3,%eax
80106146:	66 83 f8 03          	cmp    $0x3,%ax
8010614a:	0f 84 20 02 00 00    	je     80106370 <trap+0x280>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106150:	e8 0b dc ff ff       	call   80103d60 <myproc>
80106155:	85 c0                	test   %eax,%eax
80106157:	74 0f                	je     80106168 <trap+0x78>
80106159:	e8 02 dc ff ff       	call   80103d60 <myproc>
8010615e:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80106162:	0f 84 b8 00 00 00    	je     80106220 <trap+0x130>
     tf->trapno == INTERV * (T_IRQ0+IRQ_TIMER))
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106168:	e8 f3 db ff ff       	call   80103d60 <myproc>
8010616d:	85 c0                	test   %eax,%eax
8010616f:	74 1d                	je     8010618e <trap+0x9e>
80106171:	e8 ea db ff ff       	call   80103d60 <myproc>
80106176:	8b 40 28             	mov    0x28(%eax),%eax
80106179:	85 c0                	test   %eax,%eax
8010617b:	74 11                	je     8010618e <trap+0x9e>
8010617d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106181:	83 e0 03             	and    $0x3,%eax
80106184:	66 83 f8 03          	cmp    $0x3,%ax
80106188:	0f 84 17 01 00 00    	je     801062a5 <trap+0x1b5>
    exit();
}
8010618e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106191:	5b                   	pop    %ebx
80106192:	5e                   	pop    %esi
80106193:	5f                   	pop    %edi
80106194:	5d                   	pop    %ebp
80106195:	c3                   	ret    
80106196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010619d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801061a0:	e8 bb db ff ff       	call   80103d60 <myproc>
801061a5:	8b 7b 38             	mov    0x38(%ebx),%edi
801061a8:	85 c0                	test   %eax,%eax
801061aa:	0f 84 fc 01 00 00    	je     801063ac <trap+0x2bc>
801061b0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801061b4:	0f 84 f2 01 00 00    	je     801063ac <trap+0x2bc>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801061ba:	0f 20 d1             	mov    %cr2,%ecx
801061bd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061c0:	e8 db d9 ff ff       	call   80103ba0 <cpuid>
801061c5:	8b 73 30             	mov    0x30(%ebx),%esi
801061c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801061cb:	8b 43 34             	mov    0x34(%ebx),%eax
801061ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801061d1:	e8 8a db ff ff       	call   80103d60 <myproc>
801061d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801061d9:	e8 82 db ff ff       	call   80103d60 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061de:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801061e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801061e4:	51                   	push   %ecx
801061e5:	57                   	push   %edi
801061e6:	52                   	push   %edx
801061e7:	ff 75 e4             	push   -0x1c(%ebp)
801061ea:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801061eb:	8b 75 e0             	mov    -0x20(%ebp),%esi
801061ee:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061f1:	56                   	push   %esi
801061f2:	ff 70 14             	push   0x14(%eax)
801061f5:	68 dc 81 10 80       	push   $0x801081dc
801061fa:	e8 a1 a4 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
801061ff:	83 c4 20             	add    $0x20,%esp
80106202:	e8 59 db ff ff       	call   80103d60 <myproc>
80106207:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010620e:	e8 4d db ff ff       	call   80103d60 <myproc>
80106213:	85 c0                	test   %eax,%eax
80106215:	0f 85 18 ff ff ff    	jne    80106133 <trap+0x43>
8010621b:	e9 30 ff ff ff       	jmp    80106150 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106220:	81 7b 30 a0 00 00 00 	cmpl   $0xa0,0x30(%ebx)
80106227:	0f 85 3b ff ff ff    	jne    80106168 <trap+0x78>
    yield();
8010622d:	e8 6e e5 ff ff       	call   801047a0 <yield>
80106232:	e9 31 ff ff ff       	jmp    80106168 <trap+0x78>
80106237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010623e:	66 90                	xchg   %ax,%ax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106240:	8b 7b 38             	mov    0x38(%ebx),%edi
80106243:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106247:	e8 54 d9 ff ff       	call   80103ba0 <cpuid>
8010624c:	57                   	push   %edi
8010624d:	56                   	push   %esi
8010624e:	50                   	push   %eax
8010624f:	68 84 81 10 80       	push   $0x80108184
80106254:	e8 47 a4 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106259:	e8 a2 c6 ff ff       	call   80102900 <lapiceoi>
    break;
8010625e:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106261:	e8 fa da ff ff       	call   80103d60 <myproc>
80106266:	85 c0                	test   %eax,%eax
80106268:	0f 85 c5 fe ff ff    	jne    80106133 <trap+0x43>
8010626e:	e9 dd fe ff ff       	jmp    80106150 <trap+0x60>
80106273:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106277:	90                   	nop
    if(myproc()->killed)
80106278:	e8 e3 da ff ff       	call   80103d60 <myproc>
8010627d:	8b 70 28             	mov    0x28(%eax),%esi
80106280:	85 f6                	test   %esi,%esi
80106282:	0f 85 f8 00 00 00    	jne    80106380 <trap+0x290>
    myproc()->tf = tf;
80106288:	e8 d3 da ff ff       	call   80103d60 <myproc>
8010628d:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80106290:	e8 ab ef ff ff       	call   80105240 <syscall>
    if(myproc()->killed)
80106295:	e8 c6 da ff ff       	call   80103d60 <myproc>
8010629a:	8b 48 28             	mov    0x28(%eax),%ecx
8010629d:	85 c9                	test   %ecx,%ecx
8010629f:	0f 84 e9 fe ff ff    	je     8010618e <trap+0x9e>
}
801062a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062a8:	5b                   	pop    %ebx
801062a9:	5e                   	pop    %esi
801062aa:	5f                   	pop    %edi
801062ab:	5d                   	pop    %ebp
      exit();
801062ac:	e9 cf e0 ff ff       	jmp    80104380 <exit>
801062b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801062b8:	e8 93 02 00 00       	call   80106550 <uartintr>
    lapiceoi();
801062bd:	e8 3e c6 ff ff       	call   80102900 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062c2:	e8 99 da ff ff       	call   80103d60 <myproc>
801062c7:	85 c0                	test   %eax,%eax
801062c9:	0f 85 64 fe ff ff    	jne    80106133 <trap+0x43>
801062cf:	e9 7c fe ff ff       	jmp    80106150 <trap+0x60>
801062d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801062d8:	e8 f3 c4 ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
801062dd:	e8 1e c6 ff ff       	call   80102900 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062e2:	e8 79 da ff ff       	call   80103d60 <myproc>
801062e7:	85 c0                	test   %eax,%eax
801062e9:	0f 85 44 fe ff ff    	jne    80106133 <trap+0x43>
801062ef:	e9 5c fe ff ff       	jmp    80106150 <trap+0x60>
801062f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801062f8:	e8 a3 d8 ff ff       	call   80103ba0 <cpuid>
801062fd:	85 c0                	test   %eax,%eax
801062ff:	0f 85 20 fe ff ff    	jne    80106125 <trap+0x35>
      acquire(&tickslock);
80106305:	83 ec 0c             	sub    $0xc,%esp
80106308:	68 e0 54 11 80       	push   $0x801154e0
8010630d:	e8 6e ea ff ff       	call   80104d80 <acquire>
      ticks++;
80106312:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80106317:	83 c4 10             	add    $0x10,%esp
8010631a:	83 c0 01             	add    $0x1,%eax
8010631d:	69 d0 29 5c 8f c2    	imul   $0xc28f5c29,%eax,%edx
80106323:	a3 c0 54 11 80       	mov    %eax,0x801154c0
80106328:	c1 ca 03             	ror    $0x3,%edx
      if(ticks % TO2 == 0){
8010632b:	81 fa 14 ae 47 01    	cmp    $0x147ae14,%edx
80106331:	76 6d                	jbe    801063a0 <trap+0x2b0>
      if(ticks % TO3 == 0){
80106333:	69 c0 29 5c 8f c2    	imul   $0xc28f5c29,%eax,%eax
80106339:	c1 c8 02             	ror    $0x2,%eax
8010633c:	3d 28 5c 8f 02       	cmp    $0x28f5c28,%eax
80106341:	76 4d                	jbe    80106390 <trap+0x2a0>
      wakeup(&ticks);
80106343:	83 ec 0c             	sub    $0xc,%esp
80106346:	68 c0 54 11 80       	push   $0x801154c0
8010634b:	e8 60 e5 ff ff       	call   801048b0 <wakeup>
      release(&tickslock);
80106350:	c7 04 24 e0 54 11 80 	movl   $0x801154e0,(%esp)
80106357:	e8 c4 e9 ff ff       	call   80104d20 <release>
      myproc()->rtime++;
8010635c:	e8 ff d9 ff ff       	call   80103d60 <myproc>
80106361:	83 c4 10             	add    $0x10,%esp
80106364:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
8010636b:	e9 b5 fd ff ff       	jmp    80106125 <trap+0x35>
    exit();
80106370:	e8 0b e0 ff ff       	call   80104380 <exit>
80106375:	e9 d6 fd ff ff       	jmp    80106150 <trap+0x60>
8010637a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106380:	e8 fb df ff ff       	call   80104380 <exit>
80106385:	e9 fe fe ff ff       	jmp    80106288 <trap+0x198>
8010638a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        aging_priority_2();
80106390:	e8 6b d9 ff ff       	call   80103d00 <aging_priority_2>
80106395:	eb ac                	jmp    80106343 <trap+0x253>
80106397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010639e:	66 90                	xchg   %ax,%ax
        aging_priority_1();
801063a0:	e8 fb d8 ff ff       	call   80103ca0 <aging_priority_1>
      if(ticks % TO3 == 0){
801063a5:	a1 c0 54 11 80       	mov    0x801154c0,%eax
801063aa:	eb 87                	jmp    80106333 <trap+0x243>
801063ac:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801063af:	e8 ec d7 ff ff       	call   80103ba0 <cpuid>
801063b4:	83 ec 0c             	sub    $0xc,%esp
801063b7:	56                   	push   %esi
801063b8:	57                   	push   %edi
801063b9:	50                   	push   %eax
801063ba:	ff 73 30             	push   0x30(%ebx)
801063bd:	68 a8 81 10 80       	push   $0x801081a8
801063c2:	e8 d9 a2 ff ff       	call   801006a0 <cprintf>
      panic("trap");
801063c7:	83 c4 14             	add    $0x14,%esp
801063ca:	68 7e 81 10 80       	push   $0x8010817e
801063cf:	e8 ac 9f ff ff       	call   80100380 <panic>
801063d4:	66 90                	xchg   %ax,%ax
801063d6:	66 90                	xchg   %ax,%ax
801063d8:	66 90                	xchg   %ax,%ax
801063da:	66 90                	xchg   %ax,%ax
801063dc:	66 90                	xchg   %ax,%ax
801063de:	66 90                	xchg   %ax,%ax

801063e0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801063e0:	a1 20 5d 11 80       	mov    0x80115d20,%eax
801063e5:	85 c0                	test   %eax,%eax
801063e7:	74 17                	je     80106400 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801063e9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063ee:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801063ef:	a8 01                	test   $0x1,%al
801063f1:	74 0d                	je     80106400 <uartgetc+0x20>
801063f3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063f8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801063f9:	0f b6 c0             	movzbl %al,%eax
801063fc:	c3                   	ret    
801063fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106405:	c3                   	ret    
80106406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640d:	8d 76 00             	lea    0x0(%esi),%esi

80106410 <uartinit>:
{
80106410:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106411:	31 c9                	xor    %ecx,%ecx
80106413:	89 c8                	mov    %ecx,%eax
80106415:	89 e5                	mov    %esp,%ebp
80106417:	57                   	push   %edi
80106418:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010641d:	56                   	push   %esi
8010641e:	89 fa                	mov    %edi,%edx
80106420:	53                   	push   %ebx
80106421:	83 ec 1c             	sub    $0x1c,%esp
80106424:	ee                   	out    %al,(%dx)
80106425:	be fb 03 00 00       	mov    $0x3fb,%esi
8010642a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010642f:	89 f2                	mov    %esi,%edx
80106431:	ee                   	out    %al,(%dx)
80106432:	b8 0c 00 00 00       	mov    $0xc,%eax
80106437:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010643c:	ee                   	out    %al,(%dx)
8010643d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106442:	89 c8                	mov    %ecx,%eax
80106444:	89 da                	mov    %ebx,%edx
80106446:	ee                   	out    %al,(%dx)
80106447:	b8 03 00 00 00       	mov    $0x3,%eax
8010644c:	89 f2                	mov    %esi,%edx
8010644e:	ee                   	out    %al,(%dx)
8010644f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106454:	89 c8                	mov    %ecx,%eax
80106456:	ee                   	out    %al,(%dx)
80106457:	b8 01 00 00 00       	mov    $0x1,%eax
8010645c:	89 da                	mov    %ebx,%edx
8010645e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010645f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106464:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106465:	3c ff                	cmp    $0xff,%al
80106467:	74 78                	je     801064e1 <uartinit+0xd1>
  uart = 1;
80106469:	c7 05 20 5d 11 80 01 	movl   $0x1,0x80115d20
80106470:	00 00 00 
80106473:	89 fa                	mov    %edi,%edx
80106475:	ec                   	in     (%dx),%al
80106476:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010647b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010647c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010647f:	bf a0 82 10 80       	mov    $0x801082a0,%edi
80106484:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106489:	6a 00                	push   $0x0
8010648b:	6a 04                	push   $0x4
8010648d:	e8 ee bf ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106492:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106496:	83 c4 10             	add    $0x10,%esp
80106499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801064a0:	a1 20 5d 11 80       	mov    0x80115d20,%eax
801064a5:	bb 80 00 00 00       	mov    $0x80,%ebx
801064aa:	85 c0                	test   %eax,%eax
801064ac:	75 14                	jne    801064c2 <uartinit+0xb2>
801064ae:	eb 23                	jmp    801064d3 <uartinit+0xc3>
    microdelay(10);
801064b0:	83 ec 0c             	sub    $0xc,%esp
801064b3:	6a 0a                	push   $0xa
801064b5:	e8 66 c4 ff ff       	call   80102920 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064ba:	83 c4 10             	add    $0x10,%esp
801064bd:	83 eb 01             	sub    $0x1,%ebx
801064c0:	74 07                	je     801064c9 <uartinit+0xb9>
801064c2:	89 f2                	mov    %esi,%edx
801064c4:	ec                   	in     (%dx),%al
801064c5:	a8 20                	test   $0x20,%al
801064c7:	74 e7                	je     801064b0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064c9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801064cd:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064d2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801064d3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801064d7:	83 c7 01             	add    $0x1,%edi
801064da:	88 45 e7             	mov    %al,-0x19(%ebp)
801064dd:	84 c0                	test   %al,%al
801064df:	75 bf                	jne    801064a0 <uartinit+0x90>
}
801064e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064e4:	5b                   	pop    %ebx
801064e5:	5e                   	pop    %esi
801064e6:	5f                   	pop    %edi
801064e7:	5d                   	pop    %ebp
801064e8:	c3                   	ret    
801064e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064f0 <uartputc>:
  if(!uart)
801064f0:	a1 20 5d 11 80       	mov    0x80115d20,%eax
801064f5:	85 c0                	test   %eax,%eax
801064f7:	74 47                	je     80106540 <uartputc+0x50>
{
801064f9:	55                   	push   %ebp
801064fa:	89 e5                	mov    %esp,%ebp
801064fc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064fd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106502:	53                   	push   %ebx
80106503:	bb 80 00 00 00       	mov    $0x80,%ebx
80106508:	eb 18                	jmp    80106522 <uartputc+0x32>
8010650a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106510:	83 ec 0c             	sub    $0xc,%esp
80106513:	6a 0a                	push   $0xa
80106515:	e8 06 c4 ff ff       	call   80102920 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010651a:	83 c4 10             	add    $0x10,%esp
8010651d:	83 eb 01             	sub    $0x1,%ebx
80106520:	74 07                	je     80106529 <uartputc+0x39>
80106522:	89 f2                	mov    %esi,%edx
80106524:	ec                   	in     (%dx),%al
80106525:	a8 20                	test   $0x20,%al
80106527:	74 e7                	je     80106510 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106529:	8b 45 08             	mov    0x8(%ebp),%eax
8010652c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106531:	ee                   	out    %al,(%dx)
}
80106532:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106535:	5b                   	pop    %ebx
80106536:	5e                   	pop    %esi
80106537:	5d                   	pop    %ebp
80106538:	c3                   	ret    
80106539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106540:	c3                   	ret    
80106541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010654f:	90                   	nop

80106550 <uartintr>:

void
uartintr(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106556:	68 e0 63 10 80       	push   $0x801063e0
8010655b:	e8 20 a3 ff ff       	call   80100880 <consoleintr>
}
80106560:	83 c4 10             	add    $0x10,%esp
80106563:	c9                   	leave  
80106564:	c3                   	ret    

80106565 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $0
80106567:	6a 00                	push   $0x0
  jmp alltraps
80106569:	e9 ac fa ff ff       	jmp    8010601a <alltraps>

8010656e <vector1>:
.globl vector1
vector1:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $1
80106570:	6a 01                	push   $0x1
  jmp alltraps
80106572:	e9 a3 fa ff ff       	jmp    8010601a <alltraps>

80106577 <vector2>:
.globl vector2
vector2:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $2
80106579:	6a 02                	push   $0x2
  jmp alltraps
8010657b:	e9 9a fa ff ff       	jmp    8010601a <alltraps>

80106580 <vector3>:
.globl vector3
vector3:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $3
80106582:	6a 03                	push   $0x3
  jmp alltraps
80106584:	e9 91 fa ff ff       	jmp    8010601a <alltraps>

80106589 <vector4>:
.globl vector4
vector4:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $4
8010658b:	6a 04                	push   $0x4
  jmp alltraps
8010658d:	e9 88 fa ff ff       	jmp    8010601a <alltraps>

80106592 <vector5>:
.globl vector5
vector5:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $5
80106594:	6a 05                	push   $0x5
  jmp alltraps
80106596:	e9 7f fa ff ff       	jmp    8010601a <alltraps>

8010659b <vector6>:
.globl vector6
vector6:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $6
8010659d:	6a 06                	push   $0x6
  jmp alltraps
8010659f:	e9 76 fa ff ff       	jmp    8010601a <alltraps>

801065a4 <vector7>:
.globl vector7
vector7:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $7
801065a6:	6a 07                	push   $0x7
  jmp alltraps
801065a8:	e9 6d fa ff ff       	jmp    8010601a <alltraps>

801065ad <vector8>:
.globl vector8
vector8:
  pushl $8
801065ad:	6a 08                	push   $0x8
  jmp alltraps
801065af:	e9 66 fa ff ff       	jmp    8010601a <alltraps>

801065b4 <vector9>:
.globl vector9
vector9:
  pushl $0
801065b4:	6a 00                	push   $0x0
  pushl $9
801065b6:	6a 09                	push   $0x9
  jmp alltraps
801065b8:	e9 5d fa ff ff       	jmp    8010601a <alltraps>

801065bd <vector10>:
.globl vector10
vector10:
  pushl $10
801065bd:	6a 0a                	push   $0xa
  jmp alltraps
801065bf:	e9 56 fa ff ff       	jmp    8010601a <alltraps>

801065c4 <vector11>:
.globl vector11
vector11:
  pushl $11
801065c4:	6a 0b                	push   $0xb
  jmp alltraps
801065c6:	e9 4f fa ff ff       	jmp    8010601a <alltraps>

801065cb <vector12>:
.globl vector12
vector12:
  pushl $12
801065cb:	6a 0c                	push   $0xc
  jmp alltraps
801065cd:	e9 48 fa ff ff       	jmp    8010601a <alltraps>

801065d2 <vector13>:
.globl vector13
vector13:
  pushl $13
801065d2:	6a 0d                	push   $0xd
  jmp alltraps
801065d4:	e9 41 fa ff ff       	jmp    8010601a <alltraps>

801065d9 <vector14>:
.globl vector14
vector14:
  pushl $14
801065d9:	6a 0e                	push   $0xe
  jmp alltraps
801065db:	e9 3a fa ff ff       	jmp    8010601a <alltraps>

801065e0 <vector15>:
.globl vector15
vector15:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $15
801065e2:	6a 0f                	push   $0xf
  jmp alltraps
801065e4:	e9 31 fa ff ff       	jmp    8010601a <alltraps>

801065e9 <vector16>:
.globl vector16
vector16:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $16
801065eb:	6a 10                	push   $0x10
  jmp alltraps
801065ed:	e9 28 fa ff ff       	jmp    8010601a <alltraps>

801065f2 <vector17>:
.globl vector17
vector17:
  pushl $17
801065f2:	6a 11                	push   $0x11
  jmp alltraps
801065f4:	e9 21 fa ff ff       	jmp    8010601a <alltraps>

801065f9 <vector18>:
.globl vector18
vector18:
  pushl $0
801065f9:	6a 00                	push   $0x0
  pushl $18
801065fb:	6a 12                	push   $0x12
  jmp alltraps
801065fd:	e9 18 fa ff ff       	jmp    8010601a <alltraps>

80106602 <vector19>:
.globl vector19
vector19:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $19
80106604:	6a 13                	push   $0x13
  jmp alltraps
80106606:	e9 0f fa ff ff       	jmp    8010601a <alltraps>

8010660b <vector20>:
.globl vector20
vector20:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $20
8010660d:	6a 14                	push   $0x14
  jmp alltraps
8010660f:	e9 06 fa ff ff       	jmp    8010601a <alltraps>

80106614 <vector21>:
.globl vector21
vector21:
  pushl $0
80106614:	6a 00                	push   $0x0
  pushl $21
80106616:	6a 15                	push   $0x15
  jmp alltraps
80106618:	e9 fd f9 ff ff       	jmp    8010601a <alltraps>

8010661d <vector22>:
.globl vector22
vector22:
  pushl $0
8010661d:	6a 00                	push   $0x0
  pushl $22
8010661f:	6a 16                	push   $0x16
  jmp alltraps
80106621:	e9 f4 f9 ff ff       	jmp    8010601a <alltraps>

80106626 <vector23>:
.globl vector23
vector23:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $23
80106628:	6a 17                	push   $0x17
  jmp alltraps
8010662a:	e9 eb f9 ff ff       	jmp    8010601a <alltraps>

8010662f <vector24>:
.globl vector24
vector24:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $24
80106631:	6a 18                	push   $0x18
  jmp alltraps
80106633:	e9 e2 f9 ff ff       	jmp    8010601a <alltraps>

80106638 <vector25>:
.globl vector25
vector25:
  pushl $0
80106638:	6a 00                	push   $0x0
  pushl $25
8010663a:	6a 19                	push   $0x19
  jmp alltraps
8010663c:	e9 d9 f9 ff ff       	jmp    8010601a <alltraps>

80106641 <vector26>:
.globl vector26
vector26:
  pushl $0
80106641:	6a 00                	push   $0x0
  pushl $26
80106643:	6a 1a                	push   $0x1a
  jmp alltraps
80106645:	e9 d0 f9 ff ff       	jmp    8010601a <alltraps>

8010664a <vector27>:
.globl vector27
vector27:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $27
8010664c:	6a 1b                	push   $0x1b
  jmp alltraps
8010664e:	e9 c7 f9 ff ff       	jmp    8010601a <alltraps>

80106653 <vector28>:
.globl vector28
vector28:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $28
80106655:	6a 1c                	push   $0x1c
  jmp alltraps
80106657:	e9 be f9 ff ff       	jmp    8010601a <alltraps>

8010665c <vector29>:
.globl vector29
vector29:
  pushl $0
8010665c:	6a 00                	push   $0x0
  pushl $29
8010665e:	6a 1d                	push   $0x1d
  jmp alltraps
80106660:	e9 b5 f9 ff ff       	jmp    8010601a <alltraps>

80106665 <vector30>:
.globl vector30
vector30:
  pushl $0
80106665:	6a 00                	push   $0x0
  pushl $30
80106667:	6a 1e                	push   $0x1e
  jmp alltraps
80106669:	e9 ac f9 ff ff       	jmp    8010601a <alltraps>

8010666e <vector31>:
.globl vector31
vector31:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $31
80106670:	6a 1f                	push   $0x1f
  jmp alltraps
80106672:	e9 a3 f9 ff ff       	jmp    8010601a <alltraps>

80106677 <vector32>:
.globl vector32
vector32:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $32
80106679:	6a 20                	push   $0x20
  jmp alltraps
8010667b:	e9 9a f9 ff ff       	jmp    8010601a <alltraps>

80106680 <vector33>:
.globl vector33
vector33:
  pushl $0
80106680:	6a 00                	push   $0x0
  pushl $33
80106682:	6a 21                	push   $0x21
  jmp alltraps
80106684:	e9 91 f9 ff ff       	jmp    8010601a <alltraps>

80106689 <vector34>:
.globl vector34
vector34:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $34
8010668b:	6a 22                	push   $0x22
  jmp alltraps
8010668d:	e9 88 f9 ff ff       	jmp    8010601a <alltraps>

80106692 <vector35>:
.globl vector35
vector35:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $35
80106694:	6a 23                	push   $0x23
  jmp alltraps
80106696:	e9 7f f9 ff ff       	jmp    8010601a <alltraps>

8010669b <vector36>:
.globl vector36
vector36:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $36
8010669d:	6a 24                	push   $0x24
  jmp alltraps
8010669f:	e9 76 f9 ff ff       	jmp    8010601a <alltraps>

801066a4 <vector37>:
.globl vector37
vector37:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $37
801066a6:	6a 25                	push   $0x25
  jmp alltraps
801066a8:	e9 6d f9 ff ff       	jmp    8010601a <alltraps>

801066ad <vector38>:
.globl vector38
vector38:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $38
801066af:	6a 26                	push   $0x26
  jmp alltraps
801066b1:	e9 64 f9 ff ff       	jmp    8010601a <alltraps>

801066b6 <vector39>:
.globl vector39
vector39:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $39
801066b8:	6a 27                	push   $0x27
  jmp alltraps
801066ba:	e9 5b f9 ff ff       	jmp    8010601a <alltraps>

801066bf <vector40>:
.globl vector40
vector40:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $40
801066c1:	6a 28                	push   $0x28
  jmp alltraps
801066c3:	e9 52 f9 ff ff       	jmp    8010601a <alltraps>

801066c8 <vector41>:
.globl vector41
vector41:
  pushl $0
801066c8:	6a 00                	push   $0x0
  pushl $41
801066ca:	6a 29                	push   $0x29
  jmp alltraps
801066cc:	e9 49 f9 ff ff       	jmp    8010601a <alltraps>

801066d1 <vector42>:
.globl vector42
vector42:
  pushl $0
801066d1:	6a 00                	push   $0x0
  pushl $42
801066d3:	6a 2a                	push   $0x2a
  jmp alltraps
801066d5:	e9 40 f9 ff ff       	jmp    8010601a <alltraps>

801066da <vector43>:
.globl vector43
vector43:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $43
801066dc:	6a 2b                	push   $0x2b
  jmp alltraps
801066de:	e9 37 f9 ff ff       	jmp    8010601a <alltraps>

801066e3 <vector44>:
.globl vector44
vector44:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $44
801066e5:	6a 2c                	push   $0x2c
  jmp alltraps
801066e7:	e9 2e f9 ff ff       	jmp    8010601a <alltraps>

801066ec <vector45>:
.globl vector45
vector45:
  pushl $0
801066ec:	6a 00                	push   $0x0
  pushl $45
801066ee:	6a 2d                	push   $0x2d
  jmp alltraps
801066f0:	e9 25 f9 ff ff       	jmp    8010601a <alltraps>

801066f5 <vector46>:
.globl vector46
vector46:
  pushl $0
801066f5:	6a 00                	push   $0x0
  pushl $46
801066f7:	6a 2e                	push   $0x2e
  jmp alltraps
801066f9:	e9 1c f9 ff ff       	jmp    8010601a <alltraps>

801066fe <vector47>:
.globl vector47
vector47:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $47
80106700:	6a 2f                	push   $0x2f
  jmp alltraps
80106702:	e9 13 f9 ff ff       	jmp    8010601a <alltraps>

80106707 <vector48>:
.globl vector48
vector48:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $48
80106709:	6a 30                	push   $0x30
  jmp alltraps
8010670b:	e9 0a f9 ff ff       	jmp    8010601a <alltraps>

80106710 <vector49>:
.globl vector49
vector49:
  pushl $0
80106710:	6a 00                	push   $0x0
  pushl $49
80106712:	6a 31                	push   $0x31
  jmp alltraps
80106714:	e9 01 f9 ff ff       	jmp    8010601a <alltraps>

80106719 <vector50>:
.globl vector50
vector50:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $50
8010671b:	6a 32                	push   $0x32
  jmp alltraps
8010671d:	e9 f8 f8 ff ff       	jmp    8010601a <alltraps>

80106722 <vector51>:
.globl vector51
vector51:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $51
80106724:	6a 33                	push   $0x33
  jmp alltraps
80106726:	e9 ef f8 ff ff       	jmp    8010601a <alltraps>

8010672b <vector52>:
.globl vector52
vector52:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $52
8010672d:	6a 34                	push   $0x34
  jmp alltraps
8010672f:	e9 e6 f8 ff ff       	jmp    8010601a <alltraps>

80106734 <vector53>:
.globl vector53
vector53:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $53
80106736:	6a 35                	push   $0x35
  jmp alltraps
80106738:	e9 dd f8 ff ff       	jmp    8010601a <alltraps>

8010673d <vector54>:
.globl vector54
vector54:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $54
8010673f:	6a 36                	push   $0x36
  jmp alltraps
80106741:	e9 d4 f8 ff ff       	jmp    8010601a <alltraps>

80106746 <vector55>:
.globl vector55
vector55:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $55
80106748:	6a 37                	push   $0x37
  jmp alltraps
8010674a:	e9 cb f8 ff ff       	jmp    8010601a <alltraps>

8010674f <vector56>:
.globl vector56
vector56:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $56
80106751:	6a 38                	push   $0x38
  jmp alltraps
80106753:	e9 c2 f8 ff ff       	jmp    8010601a <alltraps>

80106758 <vector57>:
.globl vector57
vector57:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $57
8010675a:	6a 39                	push   $0x39
  jmp alltraps
8010675c:	e9 b9 f8 ff ff       	jmp    8010601a <alltraps>

80106761 <vector58>:
.globl vector58
vector58:
  pushl $0
80106761:	6a 00                	push   $0x0
  pushl $58
80106763:	6a 3a                	push   $0x3a
  jmp alltraps
80106765:	e9 b0 f8 ff ff       	jmp    8010601a <alltraps>

8010676a <vector59>:
.globl vector59
vector59:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $59
8010676c:	6a 3b                	push   $0x3b
  jmp alltraps
8010676e:	e9 a7 f8 ff ff       	jmp    8010601a <alltraps>

80106773 <vector60>:
.globl vector60
vector60:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $60
80106775:	6a 3c                	push   $0x3c
  jmp alltraps
80106777:	e9 9e f8 ff ff       	jmp    8010601a <alltraps>

8010677c <vector61>:
.globl vector61
vector61:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $61
8010677e:	6a 3d                	push   $0x3d
  jmp alltraps
80106780:	e9 95 f8 ff ff       	jmp    8010601a <alltraps>

80106785 <vector62>:
.globl vector62
vector62:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $62
80106787:	6a 3e                	push   $0x3e
  jmp alltraps
80106789:	e9 8c f8 ff ff       	jmp    8010601a <alltraps>

8010678e <vector63>:
.globl vector63
vector63:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $63
80106790:	6a 3f                	push   $0x3f
  jmp alltraps
80106792:	e9 83 f8 ff ff       	jmp    8010601a <alltraps>

80106797 <vector64>:
.globl vector64
vector64:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $64
80106799:	6a 40                	push   $0x40
  jmp alltraps
8010679b:	e9 7a f8 ff ff       	jmp    8010601a <alltraps>

801067a0 <vector65>:
.globl vector65
vector65:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $65
801067a2:	6a 41                	push   $0x41
  jmp alltraps
801067a4:	e9 71 f8 ff ff       	jmp    8010601a <alltraps>

801067a9 <vector66>:
.globl vector66
vector66:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $66
801067ab:	6a 42                	push   $0x42
  jmp alltraps
801067ad:	e9 68 f8 ff ff       	jmp    8010601a <alltraps>

801067b2 <vector67>:
.globl vector67
vector67:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $67
801067b4:	6a 43                	push   $0x43
  jmp alltraps
801067b6:	e9 5f f8 ff ff       	jmp    8010601a <alltraps>

801067bb <vector68>:
.globl vector68
vector68:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $68
801067bd:	6a 44                	push   $0x44
  jmp alltraps
801067bf:	e9 56 f8 ff ff       	jmp    8010601a <alltraps>

801067c4 <vector69>:
.globl vector69
vector69:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $69
801067c6:	6a 45                	push   $0x45
  jmp alltraps
801067c8:	e9 4d f8 ff ff       	jmp    8010601a <alltraps>

801067cd <vector70>:
.globl vector70
vector70:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $70
801067cf:	6a 46                	push   $0x46
  jmp alltraps
801067d1:	e9 44 f8 ff ff       	jmp    8010601a <alltraps>

801067d6 <vector71>:
.globl vector71
vector71:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $71
801067d8:	6a 47                	push   $0x47
  jmp alltraps
801067da:	e9 3b f8 ff ff       	jmp    8010601a <alltraps>

801067df <vector72>:
.globl vector72
vector72:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $72
801067e1:	6a 48                	push   $0x48
  jmp alltraps
801067e3:	e9 32 f8 ff ff       	jmp    8010601a <alltraps>

801067e8 <vector73>:
.globl vector73
vector73:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $73
801067ea:	6a 49                	push   $0x49
  jmp alltraps
801067ec:	e9 29 f8 ff ff       	jmp    8010601a <alltraps>

801067f1 <vector74>:
.globl vector74
vector74:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $74
801067f3:	6a 4a                	push   $0x4a
  jmp alltraps
801067f5:	e9 20 f8 ff ff       	jmp    8010601a <alltraps>

801067fa <vector75>:
.globl vector75
vector75:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $75
801067fc:	6a 4b                	push   $0x4b
  jmp alltraps
801067fe:	e9 17 f8 ff ff       	jmp    8010601a <alltraps>

80106803 <vector76>:
.globl vector76
vector76:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $76
80106805:	6a 4c                	push   $0x4c
  jmp alltraps
80106807:	e9 0e f8 ff ff       	jmp    8010601a <alltraps>

8010680c <vector77>:
.globl vector77
vector77:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $77
8010680e:	6a 4d                	push   $0x4d
  jmp alltraps
80106810:	e9 05 f8 ff ff       	jmp    8010601a <alltraps>

80106815 <vector78>:
.globl vector78
vector78:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $78
80106817:	6a 4e                	push   $0x4e
  jmp alltraps
80106819:	e9 fc f7 ff ff       	jmp    8010601a <alltraps>

8010681e <vector79>:
.globl vector79
vector79:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $79
80106820:	6a 4f                	push   $0x4f
  jmp alltraps
80106822:	e9 f3 f7 ff ff       	jmp    8010601a <alltraps>

80106827 <vector80>:
.globl vector80
vector80:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $80
80106829:	6a 50                	push   $0x50
  jmp alltraps
8010682b:	e9 ea f7 ff ff       	jmp    8010601a <alltraps>

80106830 <vector81>:
.globl vector81
vector81:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $81
80106832:	6a 51                	push   $0x51
  jmp alltraps
80106834:	e9 e1 f7 ff ff       	jmp    8010601a <alltraps>

80106839 <vector82>:
.globl vector82
vector82:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $82
8010683b:	6a 52                	push   $0x52
  jmp alltraps
8010683d:	e9 d8 f7 ff ff       	jmp    8010601a <alltraps>

80106842 <vector83>:
.globl vector83
vector83:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $83
80106844:	6a 53                	push   $0x53
  jmp alltraps
80106846:	e9 cf f7 ff ff       	jmp    8010601a <alltraps>

8010684b <vector84>:
.globl vector84
vector84:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $84
8010684d:	6a 54                	push   $0x54
  jmp alltraps
8010684f:	e9 c6 f7 ff ff       	jmp    8010601a <alltraps>

80106854 <vector85>:
.globl vector85
vector85:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $85
80106856:	6a 55                	push   $0x55
  jmp alltraps
80106858:	e9 bd f7 ff ff       	jmp    8010601a <alltraps>

8010685d <vector86>:
.globl vector86
vector86:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $86
8010685f:	6a 56                	push   $0x56
  jmp alltraps
80106861:	e9 b4 f7 ff ff       	jmp    8010601a <alltraps>

80106866 <vector87>:
.globl vector87
vector87:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $87
80106868:	6a 57                	push   $0x57
  jmp alltraps
8010686a:	e9 ab f7 ff ff       	jmp    8010601a <alltraps>

8010686f <vector88>:
.globl vector88
vector88:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $88
80106871:	6a 58                	push   $0x58
  jmp alltraps
80106873:	e9 a2 f7 ff ff       	jmp    8010601a <alltraps>

80106878 <vector89>:
.globl vector89
vector89:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $89
8010687a:	6a 59                	push   $0x59
  jmp alltraps
8010687c:	e9 99 f7 ff ff       	jmp    8010601a <alltraps>

80106881 <vector90>:
.globl vector90
vector90:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $90
80106883:	6a 5a                	push   $0x5a
  jmp alltraps
80106885:	e9 90 f7 ff ff       	jmp    8010601a <alltraps>

8010688a <vector91>:
.globl vector91
vector91:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $91
8010688c:	6a 5b                	push   $0x5b
  jmp alltraps
8010688e:	e9 87 f7 ff ff       	jmp    8010601a <alltraps>

80106893 <vector92>:
.globl vector92
vector92:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $92
80106895:	6a 5c                	push   $0x5c
  jmp alltraps
80106897:	e9 7e f7 ff ff       	jmp    8010601a <alltraps>

8010689c <vector93>:
.globl vector93
vector93:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $93
8010689e:	6a 5d                	push   $0x5d
  jmp alltraps
801068a0:	e9 75 f7 ff ff       	jmp    8010601a <alltraps>

801068a5 <vector94>:
.globl vector94
vector94:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $94
801068a7:	6a 5e                	push   $0x5e
  jmp alltraps
801068a9:	e9 6c f7 ff ff       	jmp    8010601a <alltraps>

801068ae <vector95>:
.globl vector95
vector95:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $95
801068b0:	6a 5f                	push   $0x5f
  jmp alltraps
801068b2:	e9 63 f7 ff ff       	jmp    8010601a <alltraps>

801068b7 <vector96>:
.globl vector96
vector96:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $96
801068b9:	6a 60                	push   $0x60
  jmp alltraps
801068bb:	e9 5a f7 ff ff       	jmp    8010601a <alltraps>

801068c0 <vector97>:
.globl vector97
vector97:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $97
801068c2:	6a 61                	push   $0x61
  jmp alltraps
801068c4:	e9 51 f7 ff ff       	jmp    8010601a <alltraps>

801068c9 <vector98>:
.globl vector98
vector98:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $98
801068cb:	6a 62                	push   $0x62
  jmp alltraps
801068cd:	e9 48 f7 ff ff       	jmp    8010601a <alltraps>

801068d2 <vector99>:
.globl vector99
vector99:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $99
801068d4:	6a 63                	push   $0x63
  jmp alltraps
801068d6:	e9 3f f7 ff ff       	jmp    8010601a <alltraps>

801068db <vector100>:
.globl vector100
vector100:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $100
801068dd:	6a 64                	push   $0x64
  jmp alltraps
801068df:	e9 36 f7 ff ff       	jmp    8010601a <alltraps>

801068e4 <vector101>:
.globl vector101
vector101:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $101
801068e6:	6a 65                	push   $0x65
  jmp alltraps
801068e8:	e9 2d f7 ff ff       	jmp    8010601a <alltraps>

801068ed <vector102>:
.globl vector102
vector102:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $102
801068ef:	6a 66                	push   $0x66
  jmp alltraps
801068f1:	e9 24 f7 ff ff       	jmp    8010601a <alltraps>

801068f6 <vector103>:
.globl vector103
vector103:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $103
801068f8:	6a 67                	push   $0x67
  jmp alltraps
801068fa:	e9 1b f7 ff ff       	jmp    8010601a <alltraps>

801068ff <vector104>:
.globl vector104
vector104:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $104
80106901:	6a 68                	push   $0x68
  jmp alltraps
80106903:	e9 12 f7 ff ff       	jmp    8010601a <alltraps>

80106908 <vector105>:
.globl vector105
vector105:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $105
8010690a:	6a 69                	push   $0x69
  jmp alltraps
8010690c:	e9 09 f7 ff ff       	jmp    8010601a <alltraps>

80106911 <vector106>:
.globl vector106
vector106:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $106
80106913:	6a 6a                	push   $0x6a
  jmp alltraps
80106915:	e9 00 f7 ff ff       	jmp    8010601a <alltraps>

8010691a <vector107>:
.globl vector107
vector107:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $107
8010691c:	6a 6b                	push   $0x6b
  jmp alltraps
8010691e:	e9 f7 f6 ff ff       	jmp    8010601a <alltraps>

80106923 <vector108>:
.globl vector108
vector108:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $108
80106925:	6a 6c                	push   $0x6c
  jmp alltraps
80106927:	e9 ee f6 ff ff       	jmp    8010601a <alltraps>

8010692c <vector109>:
.globl vector109
vector109:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $109
8010692e:	6a 6d                	push   $0x6d
  jmp alltraps
80106930:	e9 e5 f6 ff ff       	jmp    8010601a <alltraps>

80106935 <vector110>:
.globl vector110
vector110:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $110
80106937:	6a 6e                	push   $0x6e
  jmp alltraps
80106939:	e9 dc f6 ff ff       	jmp    8010601a <alltraps>

8010693e <vector111>:
.globl vector111
vector111:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $111
80106940:	6a 6f                	push   $0x6f
  jmp alltraps
80106942:	e9 d3 f6 ff ff       	jmp    8010601a <alltraps>

80106947 <vector112>:
.globl vector112
vector112:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $112
80106949:	6a 70                	push   $0x70
  jmp alltraps
8010694b:	e9 ca f6 ff ff       	jmp    8010601a <alltraps>

80106950 <vector113>:
.globl vector113
vector113:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $113
80106952:	6a 71                	push   $0x71
  jmp alltraps
80106954:	e9 c1 f6 ff ff       	jmp    8010601a <alltraps>

80106959 <vector114>:
.globl vector114
vector114:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $114
8010695b:	6a 72                	push   $0x72
  jmp alltraps
8010695d:	e9 b8 f6 ff ff       	jmp    8010601a <alltraps>

80106962 <vector115>:
.globl vector115
vector115:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $115
80106964:	6a 73                	push   $0x73
  jmp alltraps
80106966:	e9 af f6 ff ff       	jmp    8010601a <alltraps>

8010696b <vector116>:
.globl vector116
vector116:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $116
8010696d:	6a 74                	push   $0x74
  jmp alltraps
8010696f:	e9 a6 f6 ff ff       	jmp    8010601a <alltraps>

80106974 <vector117>:
.globl vector117
vector117:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $117
80106976:	6a 75                	push   $0x75
  jmp alltraps
80106978:	e9 9d f6 ff ff       	jmp    8010601a <alltraps>

8010697d <vector118>:
.globl vector118
vector118:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $118
8010697f:	6a 76                	push   $0x76
  jmp alltraps
80106981:	e9 94 f6 ff ff       	jmp    8010601a <alltraps>

80106986 <vector119>:
.globl vector119
vector119:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $119
80106988:	6a 77                	push   $0x77
  jmp alltraps
8010698a:	e9 8b f6 ff ff       	jmp    8010601a <alltraps>

8010698f <vector120>:
.globl vector120
vector120:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $120
80106991:	6a 78                	push   $0x78
  jmp alltraps
80106993:	e9 82 f6 ff ff       	jmp    8010601a <alltraps>

80106998 <vector121>:
.globl vector121
vector121:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $121
8010699a:	6a 79                	push   $0x79
  jmp alltraps
8010699c:	e9 79 f6 ff ff       	jmp    8010601a <alltraps>

801069a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $122
801069a3:	6a 7a                	push   $0x7a
  jmp alltraps
801069a5:	e9 70 f6 ff ff       	jmp    8010601a <alltraps>

801069aa <vector123>:
.globl vector123
vector123:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $123
801069ac:	6a 7b                	push   $0x7b
  jmp alltraps
801069ae:	e9 67 f6 ff ff       	jmp    8010601a <alltraps>

801069b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $124
801069b5:	6a 7c                	push   $0x7c
  jmp alltraps
801069b7:	e9 5e f6 ff ff       	jmp    8010601a <alltraps>

801069bc <vector125>:
.globl vector125
vector125:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $125
801069be:	6a 7d                	push   $0x7d
  jmp alltraps
801069c0:	e9 55 f6 ff ff       	jmp    8010601a <alltraps>

801069c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $126
801069c7:	6a 7e                	push   $0x7e
  jmp alltraps
801069c9:	e9 4c f6 ff ff       	jmp    8010601a <alltraps>

801069ce <vector127>:
.globl vector127
vector127:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $127
801069d0:	6a 7f                	push   $0x7f
  jmp alltraps
801069d2:	e9 43 f6 ff ff       	jmp    8010601a <alltraps>

801069d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $128
801069d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801069de:	e9 37 f6 ff ff       	jmp    8010601a <alltraps>

801069e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $129
801069e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801069ea:	e9 2b f6 ff ff       	jmp    8010601a <alltraps>

801069ef <vector130>:
.globl vector130
vector130:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $130
801069f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801069f6:	e9 1f f6 ff ff       	jmp    8010601a <alltraps>

801069fb <vector131>:
.globl vector131
vector131:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $131
801069fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a02:	e9 13 f6 ff ff       	jmp    8010601a <alltraps>

80106a07 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $132
80106a09:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a0e:	e9 07 f6 ff ff       	jmp    8010601a <alltraps>

80106a13 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $133
80106a15:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a1a:	e9 fb f5 ff ff       	jmp    8010601a <alltraps>

80106a1f <vector134>:
.globl vector134
vector134:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $134
80106a21:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a26:	e9 ef f5 ff ff       	jmp    8010601a <alltraps>

80106a2b <vector135>:
.globl vector135
vector135:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $135
80106a2d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106a32:	e9 e3 f5 ff ff       	jmp    8010601a <alltraps>

80106a37 <vector136>:
.globl vector136
vector136:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $136
80106a39:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106a3e:	e9 d7 f5 ff ff       	jmp    8010601a <alltraps>

80106a43 <vector137>:
.globl vector137
vector137:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $137
80106a45:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106a4a:	e9 cb f5 ff ff       	jmp    8010601a <alltraps>

80106a4f <vector138>:
.globl vector138
vector138:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $138
80106a51:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a56:	e9 bf f5 ff ff       	jmp    8010601a <alltraps>

80106a5b <vector139>:
.globl vector139
vector139:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $139
80106a5d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a62:	e9 b3 f5 ff ff       	jmp    8010601a <alltraps>

80106a67 <vector140>:
.globl vector140
vector140:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $140
80106a69:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a6e:	e9 a7 f5 ff ff       	jmp    8010601a <alltraps>

80106a73 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $141
80106a75:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a7a:	e9 9b f5 ff ff       	jmp    8010601a <alltraps>

80106a7f <vector142>:
.globl vector142
vector142:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $142
80106a81:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106a86:	e9 8f f5 ff ff       	jmp    8010601a <alltraps>

80106a8b <vector143>:
.globl vector143
vector143:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $143
80106a8d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a92:	e9 83 f5 ff ff       	jmp    8010601a <alltraps>

80106a97 <vector144>:
.globl vector144
vector144:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $144
80106a99:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106a9e:	e9 77 f5 ff ff       	jmp    8010601a <alltraps>

80106aa3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $145
80106aa5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106aaa:	e9 6b f5 ff ff       	jmp    8010601a <alltraps>

80106aaf <vector146>:
.globl vector146
vector146:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $146
80106ab1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106ab6:	e9 5f f5 ff ff       	jmp    8010601a <alltraps>

80106abb <vector147>:
.globl vector147
vector147:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $147
80106abd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ac2:	e9 53 f5 ff ff       	jmp    8010601a <alltraps>

80106ac7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $148
80106ac9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ace:	e9 47 f5 ff ff       	jmp    8010601a <alltraps>

80106ad3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $149
80106ad5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106ada:	e9 3b f5 ff ff       	jmp    8010601a <alltraps>

80106adf <vector150>:
.globl vector150
vector150:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $150
80106ae1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ae6:	e9 2f f5 ff ff       	jmp    8010601a <alltraps>

80106aeb <vector151>:
.globl vector151
vector151:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $151
80106aed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106af2:	e9 23 f5 ff ff       	jmp    8010601a <alltraps>

80106af7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $152
80106af9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106afe:	e9 17 f5 ff ff       	jmp    8010601a <alltraps>

80106b03 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $153
80106b05:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b0a:	e9 0b f5 ff ff       	jmp    8010601a <alltraps>

80106b0f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $154
80106b11:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b16:	e9 ff f4 ff ff       	jmp    8010601a <alltraps>

80106b1b <vector155>:
.globl vector155
vector155:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $155
80106b1d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b22:	e9 f3 f4 ff ff       	jmp    8010601a <alltraps>

80106b27 <vector156>:
.globl vector156
vector156:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $156
80106b29:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106b2e:	e9 e7 f4 ff ff       	jmp    8010601a <alltraps>

80106b33 <vector157>:
.globl vector157
vector157:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $157
80106b35:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106b3a:	e9 db f4 ff ff       	jmp    8010601a <alltraps>

80106b3f <vector158>:
.globl vector158
vector158:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $158
80106b41:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106b46:	e9 cf f4 ff ff       	jmp    8010601a <alltraps>

80106b4b <vector159>:
.globl vector159
vector159:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $159
80106b4d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b52:	e9 c3 f4 ff ff       	jmp    8010601a <alltraps>

80106b57 <vector160>:
.globl vector160
vector160:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $160
80106b59:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b5e:	e9 b7 f4 ff ff       	jmp    8010601a <alltraps>

80106b63 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $161
80106b65:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b6a:	e9 ab f4 ff ff       	jmp    8010601a <alltraps>

80106b6f <vector162>:
.globl vector162
vector162:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $162
80106b71:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b76:	e9 9f f4 ff ff       	jmp    8010601a <alltraps>

80106b7b <vector163>:
.globl vector163
vector163:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $163
80106b7d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106b82:	e9 93 f4 ff ff       	jmp    8010601a <alltraps>

80106b87 <vector164>:
.globl vector164
vector164:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $164
80106b89:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106b8e:	e9 87 f4 ff ff       	jmp    8010601a <alltraps>

80106b93 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $165
80106b95:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b9a:	e9 7b f4 ff ff       	jmp    8010601a <alltraps>

80106b9f <vector166>:
.globl vector166
vector166:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $166
80106ba1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106ba6:	e9 6f f4 ff ff       	jmp    8010601a <alltraps>

80106bab <vector167>:
.globl vector167
vector167:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $167
80106bad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106bb2:	e9 63 f4 ff ff       	jmp    8010601a <alltraps>

80106bb7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $168
80106bb9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106bbe:	e9 57 f4 ff ff       	jmp    8010601a <alltraps>

80106bc3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $169
80106bc5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106bca:	e9 4b f4 ff ff       	jmp    8010601a <alltraps>

80106bcf <vector170>:
.globl vector170
vector170:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $170
80106bd1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106bd6:	e9 3f f4 ff ff       	jmp    8010601a <alltraps>

80106bdb <vector171>:
.globl vector171
vector171:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $171
80106bdd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106be2:	e9 33 f4 ff ff       	jmp    8010601a <alltraps>

80106be7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $172
80106be9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106bee:	e9 27 f4 ff ff       	jmp    8010601a <alltraps>

80106bf3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $173
80106bf5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106bfa:	e9 1b f4 ff ff       	jmp    8010601a <alltraps>

80106bff <vector174>:
.globl vector174
vector174:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $174
80106c01:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c06:	e9 0f f4 ff ff       	jmp    8010601a <alltraps>

80106c0b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $175
80106c0d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c12:	e9 03 f4 ff ff       	jmp    8010601a <alltraps>

80106c17 <vector176>:
.globl vector176
vector176:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $176
80106c19:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c1e:	e9 f7 f3 ff ff       	jmp    8010601a <alltraps>

80106c23 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $177
80106c25:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c2a:	e9 eb f3 ff ff       	jmp    8010601a <alltraps>

80106c2f <vector178>:
.globl vector178
vector178:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $178
80106c31:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106c36:	e9 df f3 ff ff       	jmp    8010601a <alltraps>

80106c3b <vector179>:
.globl vector179
vector179:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $179
80106c3d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106c42:	e9 d3 f3 ff ff       	jmp    8010601a <alltraps>

80106c47 <vector180>:
.globl vector180
vector180:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $180
80106c49:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106c4e:	e9 c7 f3 ff ff       	jmp    8010601a <alltraps>

80106c53 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $181
80106c55:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c5a:	e9 bb f3 ff ff       	jmp    8010601a <alltraps>

80106c5f <vector182>:
.globl vector182
vector182:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $182
80106c61:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c66:	e9 af f3 ff ff       	jmp    8010601a <alltraps>

80106c6b <vector183>:
.globl vector183
vector183:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $183
80106c6d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c72:	e9 a3 f3 ff ff       	jmp    8010601a <alltraps>

80106c77 <vector184>:
.globl vector184
vector184:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $184
80106c79:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c7e:	e9 97 f3 ff ff       	jmp    8010601a <alltraps>

80106c83 <vector185>:
.globl vector185
vector185:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $185
80106c85:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106c8a:	e9 8b f3 ff ff       	jmp    8010601a <alltraps>

80106c8f <vector186>:
.globl vector186
vector186:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $186
80106c91:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c96:	e9 7f f3 ff ff       	jmp    8010601a <alltraps>

80106c9b <vector187>:
.globl vector187
vector187:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $187
80106c9d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ca2:	e9 73 f3 ff ff       	jmp    8010601a <alltraps>

80106ca7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $188
80106ca9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106cae:	e9 67 f3 ff ff       	jmp    8010601a <alltraps>

80106cb3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $189
80106cb5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106cba:	e9 5b f3 ff ff       	jmp    8010601a <alltraps>

80106cbf <vector190>:
.globl vector190
vector190:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $190
80106cc1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106cc6:	e9 4f f3 ff ff       	jmp    8010601a <alltraps>

80106ccb <vector191>:
.globl vector191
vector191:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $191
80106ccd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106cd2:	e9 43 f3 ff ff       	jmp    8010601a <alltraps>

80106cd7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $192
80106cd9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106cde:	e9 37 f3 ff ff       	jmp    8010601a <alltraps>

80106ce3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $193
80106ce5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106cea:	e9 2b f3 ff ff       	jmp    8010601a <alltraps>

80106cef <vector194>:
.globl vector194
vector194:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $194
80106cf1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106cf6:	e9 1f f3 ff ff       	jmp    8010601a <alltraps>

80106cfb <vector195>:
.globl vector195
vector195:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $195
80106cfd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d02:	e9 13 f3 ff ff       	jmp    8010601a <alltraps>

80106d07 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $196
80106d09:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d0e:	e9 07 f3 ff ff       	jmp    8010601a <alltraps>

80106d13 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $197
80106d15:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d1a:	e9 fb f2 ff ff       	jmp    8010601a <alltraps>

80106d1f <vector198>:
.globl vector198
vector198:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $198
80106d21:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d26:	e9 ef f2 ff ff       	jmp    8010601a <alltraps>

80106d2b <vector199>:
.globl vector199
vector199:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $199
80106d2d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106d32:	e9 e3 f2 ff ff       	jmp    8010601a <alltraps>

80106d37 <vector200>:
.globl vector200
vector200:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $200
80106d39:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106d3e:	e9 d7 f2 ff ff       	jmp    8010601a <alltraps>

80106d43 <vector201>:
.globl vector201
vector201:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $201
80106d45:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106d4a:	e9 cb f2 ff ff       	jmp    8010601a <alltraps>

80106d4f <vector202>:
.globl vector202
vector202:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $202
80106d51:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d56:	e9 bf f2 ff ff       	jmp    8010601a <alltraps>

80106d5b <vector203>:
.globl vector203
vector203:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $203
80106d5d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d62:	e9 b3 f2 ff ff       	jmp    8010601a <alltraps>

80106d67 <vector204>:
.globl vector204
vector204:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $204
80106d69:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d6e:	e9 a7 f2 ff ff       	jmp    8010601a <alltraps>

80106d73 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $205
80106d75:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d7a:	e9 9b f2 ff ff       	jmp    8010601a <alltraps>

80106d7f <vector206>:
.globl vector206
vector206:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $206
80106d81:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106d86:	e9 8f f2 ff ff       	jmp    8010601a <alltraps>

80106d8b <vector207>:
.globl vector207
vector207:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $207
80106d8d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d92:	e9 83 f2 ff ff       	jmp    8010601a <alltraps>

80106d97 <vector208>:
.globl vector208
vector208:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $208
80106d99:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106d9e:	e9 77 f2 ff ff       	jmp    8010601a <alltraps>

80106da3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $209
80106da5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106daa:	e9 6b f2 ff ff       	jmp    8010601a <alltraps>

80106daf <vector210>:
.globl vector210
vector210:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $210
80106db1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106db6:	e9 5f f2 ff ff       	jmp    8010601a <alltraps>

80106dbb <vector211>:
.globl vector211
vector211:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $211
80106dbd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106dc2:	e9 53 f2 ff ff       	jmp    8010601a <alltraps>

80106dc7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $212
80106dc9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106dce:	e9 47 f2 ff ff       	jmp    8010601a <alltraps>

80106dd3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $213
80106dd5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106dda:	e9 3b f2 ff ff       	jmp    8010601a <alltraps>

80106ddf <vector214>:
.globl vector214
vector214:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $214
80106de1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106de6:	e9 2f f2 ff ff       	jmp    8010601a <alltraps>

80106deb <vector215>:
.globl vector215
vector215:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $215
80106ded:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106df2:	e9 23 f2 ff ff       	jmp    8010601a <alltraps>

80106df7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $216
80106df9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106dfe:	e9 17 f2 ff ff       	jmp    8010601a <alltraps>

80106e03 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $217
80106e05:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e0a:	e9 0b f2 ff ff       	jmp    8010601a <alltraps>

80106e0f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $218
80106e11:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e16:	e9 ff f1 ff ff       	jmp    8010601a <alltraps>

80106e1b <vector219>:
.globl vector219
vector219:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $219
80106e1d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e22:	e9 f3 f1 ff ff       	jmp    8010601a <alltraps>

80106e27 <vector220>:
.globl vector220
vector220:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $220
80106e29:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106e2e:	e9 e7 f1 ff ff       	jmp    8010601a <alltraps>

80106e33 <vector221>:
.globl vector221
vector221:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $221
80106e35:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106e3a:	e9 db f1 ff ff       	jmp    8010601a <alltraps>

80106e3f <vector222>:
.globl vector222
vector222:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $222
80106e41:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106e46:	e9 cf f1 ff ff       	jmp    8010601a <alltraps>

80106e4b <vector223>:
.globl vector223
vector223:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $223
80106e4d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e52:	e9 c3 f1 ff ff       	jmp    8010601a <alltraps>

80106e57 <vector224>:
.globl vector224
vector224:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $224
80106e59:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e5e:	e9 b7 f1 ff ff       	jmp    8010601a <alltraps>

80106e63 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $225
80106e65:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e6a:	e9 ab f1 ff ff       	jmp    8010601a <alltraps>

80106e6f <vector226>:
.globl vector226
vector226:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $226
80106e71:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e76:	e9 9f f1 ff ff       	jmp    8010601a <alltraps>

80106e7b <vector227>:
.globl vector227
vector227:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $227
80106e7d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106e82:	e9 93 f1 ff ff       	jmp    8010601a <alltraps>

80106e87 <vector228>:
.globl vector228
vector228:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $228
80106e89:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106e8e:	e9 87 f1 ff ff       	jmp    8010601a <alltraps>

80106e93 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $229
80106e95:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e9a:	e9 7b f1 ff ff       	jmp    8010601a <alltraps>

80106e9f <vector230>:
.globl vector230
vector230:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $230
80106ea1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ea6:	e9 6f f1 ff ff       	jmp    8010601a <alltraps>

80106eab <vector231>:
.globl vector231
vector231:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $231
80106ead:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106eb2:	e9 63 f1 ff ff       	jmp    8010601a <alltraps>

80106eb7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $232
80106eb9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ebe:	e9 57 f1 ff ff       	jmp    8010601a <alltraps>

80106ec3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $233
80106ec5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106eca:	e9 4b f1 ff ff       	jmp    8010601a <alltraps>

80106ecf <vector234>:
.globl vector234
vector234:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $234
80106ed1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ed6:	e9 3f f1 ff ff       	jmp    8010601a <alltraps>

80106edb <vector235>:
.globl vector235
vector235:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $235
80106edd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ee2:	e9 33 f1 ff ff       	jmp    8010601a <alltraps>

80106ee7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $236
80106ee9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106eee:	e9 27 f1 ff ff       	jmp    8010601a <alltraps>

80106ef3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $237
80106ef5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106efa:	e9 1b f1 ff ff       	jmp    8010601a <alltraps>

80106eff <vector238>:
.globl vector238
vector238:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $238
80106f01:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f06:	e9 0f f1 ff ff       	jmp    8010601a <alltraps>

80106f0b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $239
80106f0d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f12:	e9 03 f1 ff ff       	jmp    8010601a <alltraps>

80106f17 <vector240>:
.globl vector240
vector240:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $240
80106f19:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f1e:	e9 f7 f0 ff ff       	jmp    8010601a <alltraps>

80106f23 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $241
80106f25:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f2a:	e9 eb f0 ff ff       	jmp    8010601a <alltraps>

80106f2f <vector242>:
.globl vector242
vector242:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $242
80106f31:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106f36:	e9 df f0 ff ff       	jmp    8010601a <alltraps>

80106f3b <vector243>:
.globl vector243
vector243:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $243
80106f3d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106f42:	e9 d3 f0 ff ff       	jmp    8010601a <alltraps>

80106f47 <vector244>:
.globl vector244
vector244:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $244
80106f49:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106f4e:	e9 c7 f0 ff ff       	jmp    8010601a <alltraps>

80106f53 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $245
80106f55:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f5a:	e9 bb f0 ff ff       	jmp    8010601a <alltraps>

80106f5f <vector246>:
.globl vector246
vector246:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $246
80106f61:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f66:	e9 af f0 ff ff       	jmp    8010601a <alltraps>

80106f6b <vector247>:
.globl vector247
vector247:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $247
80106f6d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f72:	e9 a3 f0 ff ff       	jmp    8010601a <alltraps>

80106f77 <vector248>:
.globl vector248
vector248:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $248
80106f79:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f7e:	e9 97 f0 ff ff       	jmp    8010601a <alltraps>

80106f83 <vector249>:
.globl vector249
vector249:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $249
80106f85:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106f8a:	e9 8b f0 ff ff       	jmp    8010601a <alltraps>

80106f8f <vector250>:
.globl vector250
vector250:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $250
80106f91:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f96:	e9 7f f0 ff ff       	jmp    8010601a <alltraps>

80106f9b <vector251>:
.globl vector251
vector251:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $251
80106f9d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106fa2:	e9 73 f0 ff ff       	jmp    8010601a <alltraps>

80106fa7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $252
80106fa9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106fae:	e9 67 f0 ff ff       	jmp    8010601a <alltraps>

80106fb3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $253
80106fb5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106fba:	e9 5b f0 ff ff       	jmp    8010601a <alltraps>

80106fbf <vector254>:
.globl vector254
vector254:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $254
80106fc1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106fc6:	e9 4f f0 ff ff       	jmp    8010601a <alltraps>

80106fcb <vector255>:
.globl vector255
vector255:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $255
80106fcd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106fd2:	e9 43 f0 ff ff       	jmp    8010601a <alltraps>
80106fd7:	66 90                	xchg   %ax,%ax
80106fd9:	66 90                	xchg   %ax,%ax
80106fdb:	66 90                	xchg   %ax,%ax
80106fdd:	66 90                	xchg   %ax,%ax
80106fdf:	90                   	nop

80106fe0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106fe6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106fec:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ff2:	83 ec 1c             	sub    $0x1c,%esp
80106ff5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106ff8:	39 d3                	cmp    %edx,%ebx
80106ffa:	73 49                	jae    80107045 <deallocuvm.part.0+0x65>
80106ffc:	89 c7                	mov    %eax,%edi
80106ffe:	eb 0c                	jmp    8010700c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107000:	83 c0 01             	add    $0x1,%eax
80107003:	c1 e0 16             	shl    $0x16,%eax
80107006:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107008:	39 da                	cmp    %ebx,%edx
8010700a:	76 39                	jbe    80107045 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010700c:	89 d8                	mov    %ebx,%eax
8010700e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107011:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107014:	f6 c1 01             	test   $0x1,%cl
80107017:	74 e7                	je     80107000 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107019:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010701b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107021:	c1 ee 0a             	shr    $0xa,%esi
80107024:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010702a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107031:	85 f6                	test   %esi,%esi
80107033:	74 cb                	je     80107000 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107035:	8b 06                	mov    (%esi),%eax
80107037:	a8 01                	test   $0x1,%al
80107039:	75 15                	jne    80107050 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010703b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107041:	39 da                	cmp    %ebx,%edx
80107043:	77 c7                	ja     8010700c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107045:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010704b:	5b                   	pop    %ebx
8010704c:	5e                   	pop    %esi
8010704d:	5f                   	pop    %edi
8010704e:	5d                   	pop    %ebp
8010704f:	c3                   	ret    
      if(pa == 0)
80107050:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107055:	74 25                	je     8010707c <deallocuvm.part.0+0x9c>
      kfree(v);
80107057:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010705a:	05 00 00 00 80       	add    $0x80000000,%eax
8010705f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107062:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107068:	50                   	push   %eax
80107069:	e8 52 b4 ff ff       	call   801024c0 <kfree>
      *pte = 0;
8010706e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107074:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107077:	83 c4 10             	add    $0x10,%esp
8010707a:	eb 8c                	jmp    80107008 <deallocuvm.part.0+0x28>
        panic("kfree");
8010707c:	83 ec 0c             	sub    $0xc,%esp
8010707f:	68 46 7c 10 80       	push   $0x80107c46
80107084:	e8 f7 92 ff ff       	call   80100380 <panic>
80107089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107090 <mappages>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	57                   	push   %edi
80107094:	56                   	push   %esi
80107095:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107096:	89 d3                	mov    %edx,%ebx
80107098:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010709e:	83 ec 1c             	sub    $0x1c,%esp
801070a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070a4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801070a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801070ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
801070b0:	8b 45 08             	mov    0x8(%ebp),%eax
801070b3:	29 d8                	sub    %ebx,%eax
801070b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070b8:	eb 3d                	jmp    801070f7 <mappages+0x67>
801070ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801070c0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801070c7:	c1 ea 0a             	shr    $0xa,%edx
801070ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801070d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801070d7:	85 c0                	test   %eax,%eax
801070d9:	74 75                	je     80107150 <mappages+0xc0>
    if(*pte & PTE_P)
801070db:	f6 00 01             	testb  $0x1,(%eax)
801070de:	0f 85 86 00 00 00    	jne    8010716a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801070e4:	0b 75 0c             	or     0xc(%ebp),%esi
801070e7:	83 ce 01             	or     $0x1,%esi
801070ea:	89 30                	mov    %esi,(%eax)
    if(a == last)
801070ec:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801070ef:	74 6f                	je     80107160 <mappages+0xd0>
    a += PGSIZE;
801070f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801070f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801070fa:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070fd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107100:	89 d8                	mov    %ebx,%eax
80107102:	c1 e8 16             	shr    $0x16,%eax
80107105:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107108:	8b 07                	mov    (%edi),%eax
8010710a:	a8 01                	test   $0x1,%al
8010710c:	75 b2                	jne    801070c0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010710e:	e8 6d b5 ff ff       	call   80102680 <kalloc>
80107113:	85 c0                	test   %eax,%eax
80107115:	74 39                	je     80107150 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107117:	83 ec 04             	sub    $0x4,%esp
8010711a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010711d:	68 00 10 00 00       	push   $0x1000
80107122:	6a 00                	push   $0x0
80107124:	50                   	push   %eax
80107125:	e8 16 dd ff ff       	call   80104e40 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010712a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010712d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107130:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107136:	83 c8 07             	or     $0x7,%eax
80107139:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010713b:	89 d8                	mov    %ebx,%eax
8010713d:	c1 e8 0a             	shr    $0xa,%eax
80107140:	25 fc 0f 00 00       	and    $0xffc,%eax
80107145:	01 d0                	add    %edx,%eax
80107147:	eb 92                	jmp    801070db <mappages+0x4b>
80107149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107150:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107153:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107158:	5b                   	pop    %ebx
80107159:	5e                   	pop    %esi
8010715a:	5f                   	pop    %edi
8010715b:	5d                   	pop    %ebp
8010715c:	c3                   	ret    
8010715d:	8d 76 00             	lea    0x0(%esi),%esi
80107160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107163:	31 c0                	xor    %eax,%eax
}
80107165:	5b                   	pop    %ebx
80107166:	5e                   	pop    %esi
80107167:	5f                   	pop    %edi
80107168:	5d                   	pop    %ebp
80107169:	c3                   	ret    
      panic("remap");
8010716a:	83 ec 0c             	sub    $0xc,%esp
8010716d:	68 a8 82 10 80       	push   $0x801082a8
80107172:	e8 09 92 ff ff       	call   80100380 <panic>
80107177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010717e:	66 90                	xchg   %ax,%ax

80107180 <seginit>:
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107186:	e8 15 ca ff ff       	call   80103ba0 <cpuid>
  pd[0] = size-1;
8010718b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107190:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107196:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010719a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
801071a1:	ff 00 00 
801071a4:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
801071ab:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801071ae:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
801071b5:	ff 00 00 
801071b8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
801071bf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801071c2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
801071c9:	ff 00 00 
801071cc:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
801071d3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801071d6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
801071dd:	ff 00 00 
801071e0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
801071e7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801071ea:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
801071ef:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801071f3:	c1 e8 10             	shr    $0x10,%eax
801071f6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801071fa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801071fd:	0f 01 10             	lgdtl  (%eax)
}
80107200:	c9                   	leave  
80107201:	c3                   	ret    
80107202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107210 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107210:	a1 24 5d 11 80       	mov    0x80115d24,%eax
80107215:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010721a:	0f 22 d8             	mov    %eax,%cr3
}
8010721d:	c3                   	ret    
8010721e:	66 90                	xchg   %ax,%ax

80107220 <switchuvm>:
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	57                   	push   %edi
80107224:	56                   	push   %esi
80107225:	53                   	push   %ebx
80107226:	83 ec 1c             	sub    $0x1c,%esp
80107229:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010722c:	85 f6                	test   %esi,%esi
8010722e:	0f 84 cb 00 00 00    	je     801072ff <switchuvm+0xdf>
  if(p->kstack == 0)
80107234:	8b 46 0c             	mov    0xc(%esi),%eax
80107237:	85 c0                	test   %eax,%eax
80107239:	0f 84 da 00 00 00    	je     80107319 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010723f:	8b 46 08             	mov    0x8(%esi),%eax
80107242:	85 c0                	test   %eax,%eax
80107244:	0f 84 c2 00 00 00    	je     8010730c <switchuvm+0xec>
  pushcli();
8010724a:	e8 e1 d9 ff ff       	call   80104c30 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010724f:	e8 ec c8 ff ff       	call   80103b40 <mycpu>
80107254:	89 c3                	mov    %eax,%ebx
80107256:	e8 e5 c8 ff ff       	call   80103b40 <mycpu>
8010725b:	89 c7                	mov    %eax,%edi
8010725d:	e8 de c8 ff ff       	call   80103b40 <mycpu>
80107262:	83 c7 08             	add    $0x8,%edi
80107265:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107268:	e8 d3 c8 ff ff       	call   80103b40 <mycpu>
8010726d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107270:	ba 67 00 00 00       	mov    $0x67,%edx
80107275:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010727c:	83 c0 08             	add    $0x8,%eax
8010727f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107286:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010728b:	83 c1 08             	add    $0x8,%ecx
8010728e:	c1 e8 18             	shr    $0x18,%eax
80107291:	c1 e9 10             	shr    $0x10,%ecx
80107294:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010729a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801072a0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072a5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072ac:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801072b1:	e8 8a c8 ff ff       	call   80103b40 <mycpu>
801072b6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072bd:	e8 7e c8 ff ff       	call   80103b40 <mycpu>
801072c2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072c6:	8b 5e 0c             	mov    0xc(%esi),%ebx
801072c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072cf:	e8 6c c8 ff ff       	call   80103b40 <mycpu>
801072d4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072d7:	e8 64 c8 ff ff       	call   80103b40 <mycpu>
801072dc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801072e0:	b8 28 00 00 00       	mov    $0x28,%eax
801072e5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801072e8:	8b 46 08             	mov    0x8(%esi),%eax
801072eb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072f0:	0f 22 d8             	mov    %eax,%cr3
}
801072f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f6:	5b                   	pop    %ebx
801072f7:	5e                   	pop    %esi
801072f8:	5f                   	pop    %edi
801072f9:	5d                   	pop    %ebp
  popcli();
801072fa:	e9 81 d9 ff ff       	jmp    80104c80 <popcli>
    panic("switchuvm: no process");
801072ff:	83 ec 0c             	sub    $0xc,%esp
80107302:	68 ae 82 10 80       	push   $0x801082ae
80107307:	e8 74 90 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010730c:	83 ec 0c             	sub    $0xc,%esp
8010730f:	68 d9 82 10 80       	push   $0x801082d9
80107314:	e8 67 90 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107319:	83 ec 0c             	sub    $0xc,%esp
8010731c:	68 c4 82 10 80       	push   $0x801082c4
80107321:	e8 5a 90 ff ff       	call   80100380 <panic>
80107326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010732d:	8d 76 00             	lea    0x0(%esi),%esi

80107330 <inituvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 1c             	sub    $0x1c,%esp
80107339:	8b 45 0c             	mov    0xc(%ebp),%eax
8010733c:	8b 75 10             	mov    0x10(%ebp),%esi
8010733f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107342:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107345:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010734b:	77 4b                	ja     80107398 <inituvm+0x68>
  mem = kalloc();
8010734d:	e8 2e b3 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107352:	83 ec 04             	sub    $0x4,%esp
80107355:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010735a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010735c:	6a 00                	push   $0x0
8010735e:	50                   	push   %eax
8010735f:	e8 dc da ff ff       	call   80104e40 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107364:	58                   	pop    %eax
80107365:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010736b:	5a                   	pop    %edx
8010736c:	6a 06                	push   $0x6
8010736e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107373:	31 d2                	xor    %edx,%edx
80107375:	50                   	push   %eax
80107376:	89 f8                	mov    %edi,%eax
80107378:	e8 13 fd ff ff       	call   80107090 <mappages>
  memmove(mem, init, sz);
8010737d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107380:	89 75 10             	mov    %esi,0x10(%ebp)
80107383:	83 c4 10             	add    $0x10,%esp
80107386:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107389:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010738c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010738f:	5b                   	pop    %ebx
80107390:	5e                   	pop    %esi
80107391:	5f                   	pop    %edi
80107392:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107393:	e9 48 db ff ff       	jmp    80104ee0 <memmove>
    panic("inituvm: more than a page");
80107398:	83 ec 0c             	sub    $0xc,%esp
8010739b:	68 ed 82 10 80       	push   $0x801082ed
801073a0:	e8 db 8f ff ff       	call   80100380 <panic>
801073a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073b0 <loaduvm>:
{
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	57                   	push   %edi
801073b4:	56                   	push   %esi
801073b5:	53                   	push   %ebx
801073b6:	83 ec 1c             	sub    $0x1c,%esp
801073b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801073bc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801073bf:	a9 ff 0f 00 00       	test   $0xfff,%eax
801073c4:	0f 85 bb 00 00 00    	jne    80107485 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801073ca:	01 f0                	add    %esi,%eax
801073cc:	89 f3                	mov    %esi,%ebx
801073ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073d1:	8b 45 14             	mov    0x14(%ebp),%eax
801073d4:	01 f0                	add    %esi,%eax
801073d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801073d9:	85 f6                	test   %esi,%esi
801073db:	0f 84 87 00 00 00    	je     80107468 <loaduvm+0xb8>
801073e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801073e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801073eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801073ee:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801073f0:	89 c2                	mov    %eax,%edx
801073f2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801073f5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801073f8:	f6 c2 01             	test   $0x1,%dl
801073fb:	75 13                	jne    80107410 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801073fd:	83 ec 0c             	sub    $0xc,%esp
80107400:	68 07 83 10 80       	push   $0x80108307
80107405:	e8 76 8f ff ff       	call   80100380 <panic>
8010740a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107410:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107413:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107419:	25 fc 0f 00 00       	and    $0xffc,%eax
8010741e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107425:	85 c0                	test   %eax,%eax
80107427:	74 d4                	je     801073fd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107429:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010742b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010742e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107433:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107438:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010743e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107441:	29 d9                	sub    %ebx,%ecx
80107443:	05 00 00 00 80       	add    $0x80000000,%eax
80107448:	57                   	push   %edi
80107449:	51                   	push   %ecx
8010744a:	50                   	push   %eax
8010744b:	ff 75 10             	push   0x10(%ebp)
8010744e:	e8 3d a6 ff ff       	call   80101a90 <readi>
80107453:	83 c4 10             	add    $0x10,%esp
80107456:	39 f8                	cmp    %edi,%eax
80107458:	75 1e                	jne    80107478 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010745a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107460:	89 f0                	mov    %esi,%eax
80107462:	29 d8                	sub    %ebx,%eax
80107464:	39 c6                	cmp    %eax,%esi
80107466:	77 80                	ja     801073e8 <loaduvm+0x38>
}
80107468:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010746b:	31 c0                	xor    %eax,%eax
}
8010746d:	5b                   	pop    %ebx
8010746e:	5e                   	pop    %esi
8010746f:	5f                   	pop    %edi
80107470:	5d                   	pop    %ebp
80107471:	c3                   	ret    
80107472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107478:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010747b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107480:	5b                   	pop    %ebx
80107481:	5e                   	pop    %esi
80107482:	5f                   	pop    %edi
80107483:	5d                   	pop    %ebp
80107484:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107485:	83 ec 0c             	sub    $0xc,%esp
80107488:	68 a8 83 10 80       	push   $0x801083a8
8010748d:	e8 ee 8e ff ff       	call   80100380 <panic>
80107492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074a0 <allocuvm>:
{
801074a0:	55                   	push   %ebp
801074a1:	89 e5                	mov    %esp,%ebp
801074a3:	57                   	push   %edi
801074a4:	56                   	push   %esi
801074a5:	53                   	push   %ebx
801074a6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801074a9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801074ac:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801074af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074b2:	85 c0                	test   %eax,%eax
801074b4:	0f 88 b6 00 00 00    	js     80107570 <allocuvm+0xd0>
  if(newsz < oldsz)
801074ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801074bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801074c0:	0f 82 9a 00 00 00    	jb     80107560 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801074c6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801074cc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801074d2:	39 75 10             	cmp    %esi,0x10(%ebp)
801074d5:	77 44                	ja     8010751b <allocuvm+0x7b>
801074d7:	e9 87 00 00 00       	jmp    80107563 <allocuvm+0xc3>
801074dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801074e0:	83 ec 04             	sub    $0x4,%esp
801074e3:	68 00 10 00 00       	push   $0x1000
801074e8:	6a 00                	push   $0x0
801074ea:	50                   	push   %eax
801074eb:	e8 50 d9 ff ff       	call   80104e40 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801074f0:	58                   	pop    %eax
801074f1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074f7:	5a                   	pop    %edx
801074f8:	6a 06                	push   $0x6
801074fa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801074ff:	89 f2                	mov    %esi,%edx
80107501:	50                   	push   %eax
80107502:	89 f8                	mov    %edi,%eax
80107504:	e8 87 fb ff ff       	call   80107090 <mappages>
80107509:	83 c4 10             	add    $0x10,%esp
8010750c:	85 c0                	test   %eax,%eax
8010750e:	78 78                	js     80107588 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107510:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107516:	39 75 10             	cmp    %esi,0x10(%ebp)
80107519:	76 48                	jbe    80107563 <allocuvm+0xc3>
    mem = kalloc();
8010751b:	e8 60 b1 ff ff       	call   80102680 <kalloc>
80107520:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107522:	85 c0                	test   %eax,%eax
80107524:	75 ba                	jne    801074e0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107526:	83 ec 0c             	sub    $0xc,%esp
80107529:	68 25 83 10 80       	push   $0x80108325
8010752e:	e8 6d 91 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107533:	8b 45 0c             	mov    0xc(%ebp),%eax
80107536:	83 c4 10             	add    $0x10,%esp
80107539:	39 45 10             	cmp    %eax,0x10(%ebp)
8010753c:	74 32                	je     80107570 <allocuvm+0xd0>
8010753e:	8b 55 10             	mov    0x10(%ebp),%edx
80107541:	89 c1                	mov    %eax,%ecx
80107543:	89 f8                	mov    %edi,%eax
80107545:	e8 96 fa ff ff       	call   80106fe0 <deallocuvm.part.0>
      return 0;
8010754a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107554:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107557:	5b                   	pop    %ebx
80107558:	5e                   	pop    %esi
80107559:	5f                   	pop    %edi
8010755a:	5d                   	pop    %ebp
8010755b:	c3                   	ret    
8010755c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107566:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107569:	5b                   	pop    %ebx
8010756a:	5e                   	pop    %esi
8010756b:	5f                   	pop    %edi
8010756c:	5d                   	pop    %ebp
8010756d:	c3                   	ret    
8010756e:	66 90                	xchg   %ax,%ax
    return 0;
80107570:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010757a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010757d:	5b                   	pop    %ebx
8010757e:	5e                   	pop    %esi
8010757f:	5f                   	pop    %edi
80107580:	5d                   	pop    %ebp
80107581:	c3                   	ret    
80107582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107588:	83 ec 0c             	sub    $0xc,%esp
8010758b:	68 3d 83 10 80       	push   $0x8010833d
80107590:	e8 0b 91 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107595:	8b 45 0c             	mov    0xc(%ebp),%eax
80107598:	83 c4 10             	add    $0x10,%esp
8010759b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010759e:	74 0c                	je     801075ac <allocuvm+0x10c>
801075a0:	8b 55 10             	mov    0x10(%ebp),%edx
801075a3:	89 c1                	mov    %eax,%ecx
801075a5:	89 f8                	mov    %edi,%eax
801075a7:	e8 34 fa ff ff       	call   80106fe0 <deallocuvm.part.0>
      kfree(mem);
801075ac:	83 ec 0c             	sub    $0xc,%esp
801075af:	53                   	push   %ebx
801075b0:	e8 0b af ff ff       	call   801024c0 <kfree>
      return 0;
801075b5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801075bc:	83 c4 10             	add    $0x10,%esp
}
801075bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075c5:	5b                   	pop    %ebx
801075c6:	5e                   	pop    %esi
801075c7:	5f                   	pop    %edi
801075c8:	5d                   	pop    %ebp
801075c9:	c3                   	ret    
801075ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075d0 <deallocuvm>:
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801075d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801075d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801075dc:	39 d1                	cmp    %edx,%ecx
801075de:	73 10                	jae    801075f0 <deallocuvm+0x20>
}
801075e0:	5d                   	pop    %ebp
801075e1:	e9 fa f9 ff ff       	jmp    80106fe0 <deallocuvm.part.0>
801075e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ed:	8d 76 00             	lea    0x0(%esi),%esi
801075f0:	89 d0                	mov    %edx,%eax
801075f2:	5d                   	pop    %ebp
801075f3:	c3                   	ret    
801075f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075ff:	90                   	nop

80107600 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	57                   	push   %edi
80107604:	56                   	push   %esi
80107605:	53                   	push   %ebx
80107606:	83 ec 0c             	sub    $0xc,%esp
80107609:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010760c:	85 f6                	test   %esi,%esi
8010760e:	74 59                	je     80107669 <freevm+0x69>
  if(newsz >= oldsz)
80107610:	31 c9                	xor    %ecx,%ecx
80107612:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107617:	89 f0                	mov    %esi,%eax
80107619:	89 f3                	mov    %esi,%ebx
8010761b:	e8 c0 f9 ff ff       	call   80106fe0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107620:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107626:	eb 0f                	jmp    80107637 <freevm+0x37>
80107628:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762f:	90                   	nop
80107630:	83 c3 04             	add    $0x4,%ebx
80107633:	39 df                	cmp    %ebx,%edi
80107635:	74 23                	je     8010765a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107637:	8b 03                	mov    (%ebx),%eax
80107639:	a8 01                	test   $0x1,%al
8010763b:	74 f3                	je     80107630 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010763d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107642:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107645:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107648:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010764d:	50                   	push   %eax
8010764e:	e8 6d ae ff ff       	call   801024c0 <kfree>
80107653:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107656:	39 df                	cmp    %ebx,%edi
80107658:	75 dd                	jne    80107637 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010765a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010765d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107660:	5b                   	pop    %ebx
80107661:	5e                   	pop    %esi
80107662:	5f                   	pop    %edi
80107663:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107664:	e9 57 ae ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107669:	83 ec 0c             	sub    $0xc,%esp
8010766c:	68 59 83 10 80       	push   $0x80108359
80107671:	e8 0a 8d ff ff       	call   80100380 <panic>
80107676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010767d:	8d 76 00             	lea    0x0(%esi),%esi

80107680 <setupkvm>:
{
80107680:	55                   	push   %ebp
80107681:	89 e5                	mov    %esp,%ebp
80107683:	56                   	push   %esi
80107684:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107685:	e8 f6 af ff ff       	call   80102680 <kalloc>
8010768a:	89 c6                	mov    %eax,%esi
8010768c:	85 c0                	test   %eax,%eax
8010768e:	74 42                	je     801076d2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107690:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107693:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107698:	68 00 10 00 00       	push   $0x1000
8010769d:	6a 00                	push   $0x0
8010769f:	50                   	push   %eax
801076a0:	e8 9b d7 ff ff       	call   80104e40 <memset>
801076a5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801076a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801076ab:	83 ec 08             	sub    $0x8,%esp
801076ae:	8b 4b 08             	mov    0x8(%ebx),%ecx
801076b1:	ff 73 0c             	push   0xc(%ebx)
801076b4:	8b 13                	mov    (%ebx),%edx
801076b6:	50                   	push   %eax
801076b7:	29 c1                	sub    %eax,%ecx
801076b9:	89 f0                	mov    %esi,%eax
801076bb:	e8 d0 f9 ff ff       	call   80107090 <mappages>
801076c0:	83 c4 10             	add    $0x10,%esp
801076c3:	85 c0                	test   %eax,%eax
801076c5:	78 19                	js     801076e0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076c7:	83 c3 10             	add    $0x10,%ebx
801076ca:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801076d0:	75 d6                	jne    801076a8 <setupkvm+0x28>
}
801076d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076d5:	89 f0                	mov    %esi,%eax
801076d7:	5b                   	pop    %ebx
801076d8:	5e                   	pop    %esi
801076d9:	5d                   	pop    %ebp
801076da:	c3                   	ret    
801076db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076df:	90                   	nop
      freevm(pgdir);
801076e0:	83 ec 0c             	sub    $0xc,%esp
801076e3:	56                   	push   %esi
      return 0;
801076e4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801076e6:	e8 15 ff ff ff       	call   80107600 <freevm>
      return 0;
801076eb:	83 c4 10             	add    $0x10,%esp
}
801076ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076f1:	89 f0                	mov    %esi,%eax
801076f3:	5b                   	pop    %ebx
801076f4:	5e                   	pop    %esi
801076f5:	5d                   	pop    %ebp
801076f6:	c3                   	ret    
801076f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076fe:	66 90                	xchg   %ax,%ax

80107700 <kvmalloc>:
{
80107700:	55                   	push   %ebp
80107701:	89 e5                	mov    %esp,%ebp
80107703:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107706:	e8 75 ff ff ff       	call   80107680 <setupkvm>
8010770b:	a3 24 5d 11 80       	mov    %eax,0x80115d24
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107710:	05 00 00 00 80       	add    $0x80000000,%eax
80107715:	0f 22 d8             	mov    %eax,%cr3
}
80107718:	c9                   	leave  
80107719:	c3                   	ret    
8010771a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107720 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107720:	55                   	push   %ebp
80107721:	89 e5                	mov    %esp,%ebp
80107723:	83 ec 08             	sub    $0x8,%esp
80107726:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107729:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010772c:	89 c1                	mov    %eax,%ecx
8010772e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107731:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107734:	f6 c2 01             	test   $0x1,%dl
80107737:	75 17                	jne    80107750 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107739:	83 ec 0c             	sub    $0xc,%esp
8010773c:	68 6a 83 10 80       	push   $0x8010836a
80107741:	e8 3a 8c ff ff       	call   80100380 <panic>
80107746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010774d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107750:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107753:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107759:	25 fc 0f 00 00       	and    $0xffc,%eax
8010775e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107765:	85 c0                	test   %eax,%eax
80107767:	74 d0                	je     80107739 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107769:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010776c:	c9                   	leave  
8010776d:	c3                   	ret    
8010776e:	66 90                	xchg   %ax,%ax

80107770 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107770:	55                   	push   %ebp
80107771:	89 e5                	mov    %esp,%ebp
80107773:	57                   	push   %edi
80107774:	56                   	push   %esi
80107775:	53                   	push   %ebx
80107776:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107779:	e8 02 ff ff ff       	call   80107680 <setupkvm>
8010777e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107781:	85 c0                	test   %eax,%eax
80107783:	0f 84 bd 00 00 00    	je     80107846 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107789:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010778c:	85 c9                	test   %ecx,%ecx
8010778e:	0f 84 b2 00 00 00    	je     80107846 <copyuvm+0xd6>
80107794:	31 f6                	xor    %esi,%esi
80107796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010779d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801077a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801077a3:	89 f0                	mov    %esi,%eax
801077a5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801077a8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801077ab:	a8 01                	test   $0x1,%al
801077ad:	75 11                	jne    801077c0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801077af:	83 ec 0c             	sub    $0xc,%esp
801077b2:	68 74 83 10 80       	push   $0x80108374
801077b7:	e8 c4 8b ff ff       	call   80100380 <panic>
801077bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801077c0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801077c7:	c1 ea 0a             	shr    $0xa,%edx
801077ca:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801077d0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801077d7:	85 c0                	test   %eax,%eax
801077d9:	74 d4                	je     801077af <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801077db:	8b 00                	mov    (%eax),%eax
801077dd:	a8 01                	test   $0x1,%al
801077df:	0f 84 9f 00 00 00    	je     80107884 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801077e5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801077e7:	25 ff 0f 00 00       	and    $0xfff,%eax
801077ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801077ef:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801077f5:	e8 86 ae ff ff       	call   80102680 <kalloc>
801077fa:	89 c3                	mov    %eax,%ebx
801077fc:	85 c0                	test   %eax,%eax
801077fe:	74 64                	je     80107864 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107800:	83 ec 04             	sub    $0x4,%esp
80107803:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107809:	68 00 10 00 00       	push   $0x1000
8010780e:	57                   	push   %edi
8010780f:	50                   	push   %eax
80107810:	e8 cb d6 ff ff       	call   80104ee0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107815:	58                   	pop    %eax
80107816:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010781c:	5a                   	pop    %edx
8010781d:	ff 75 e4             	push   -0x1c(%ebp)
80107820:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107825:	89 f2                	mov    %esi,%edx
80107827:	50                   	push   %eax
80107828:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010782b:	e8 60 f8 ff ff       	call   80107090 <mappages>
80107830:	83 c4 10             	add    $0x10,%esp
80107833:	85 c0                	test   %eax,%eax
80107835:	78 21                	js     80107858 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107837:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010783d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107840:	0f 87 5a ff ff ff    	ja     801077a0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107846:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107849:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010784c:	5b                   	pop    %ebx
8010784d:	5e                   	pop    %esi
8010784e:	5f                   	pop    %edi
8010784f:	5d                   	pop    %ebp
80107850:	c3                   	ret    
80107851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107858:	83 ec 0c             	sub    $0xc,%esp
8010785b:	53                   	push   %ebx
8010785c:	e8 5f ac ff ff       	call   801024c0 <kfree>
      goto bad;
80107861:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107864:	83 ec 0c             	sub    $0xc,%esp
80107867:	ff 75 e0             	push   -0x20(%ebp)
8010786a:	e8 91 fd ff ff       	call   80107600 <freevm>
  return 0;
8010786f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107876:	83 c4 10             	add    $0x10,%esp
}
80107879:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010787c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010787f:	5b                   	pop    %ebx
80107880:	5e                   	pop    %esi
80107881:	5f                   	pop    %edi
80107882:	5d                   	pop    %ebp
80107883:	c3                   	ret    
      panic("copyuvm: page not present");
80107884:	83 ec 0c             	sub    $0xc,%esp
80107887:	68 8e 83 10 80       	push   $0x8010838e
8010788c:	e8 ef 8a ff ff       	call   80100380 <panic>
80107891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010789f:	90                   	nop

801078a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078a0:	55                   	push   %ebp
801078a1:	89 e5                	mov    %esp,%ebp
801078a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801078a6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801078a9:	89 c1                	mov    %eax,%ecx
801078ab:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801078ae:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801078b1:	f6 c2 01             	test   $0x1,%dl
801078b4:	0f 84 00 01 00 00    	je     801079ba <uva2ka.cold>
  return &pgtab[PTX(va)];
801078ba:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078bd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801078c3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801078c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801078c9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801078d0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801078d7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078da:	05 00 00 00 80       	add    $0x80000000,%eax
801078df:	83 fa 05             	cmp    $0x5,%edx
801078e2:	ba 00 00 00 00       	mov    $0x0,%edx
801078e7:	0f 45 c2             	cmovne %edx,%eax
}
801078ea:	c3                   	ret    
801078eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
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
801078f6:	83 ec 0c             	sub    $0xc,%esp
801078f9:	8b 75 14             	mov    0x14(%ebp),%esi
801078fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801078ff:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107902:	85 f6                	test   %esi,%esi
80107904:	75 51                	jne    80107957 <copyout+0x67>
80107906:	e9 a5 00 00 00       	jmp    801079b0 <copyout+0xc0>
8010790b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010790f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107910:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107916:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010791c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107922:	74 75                	je     80107999 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107924:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107926:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107929:	29 c3                	sub    %eax,%ebx
8010792b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107931:	39 f3                	cmp    %esi,%ebx
80107933:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107936:	29 f8                	sub    %edi,%eax
80107938:	83 ec 04             	sub    $0x4,%esp
8010793b:	01 c1                	add    %eax,%ecx
8010793d:	53                   	push   %ebx
8010793e:	52                   	push   %edx
8010793f:	51                   	push   %ecx
80107940:	e8 9b d5 ff ff       	call   80104ee0 <memmove>
    len -= n;
    buf += n;
80107945:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107948:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010794e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107951:	01 da                	add    %ebx,%edx
  while(len > 0){
80107953:	29 de                	sub    %ebx,%esi
80107955:	74 59                	je     801079b0 <copyout+0xc0>
  if(*pde & PTE_P){
80107957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010795a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010795c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010795e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107961:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107967:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010796a:	f6 c1 01             	test   $0x1,%cl
8010796d:	0f 84 4e 00 00 00    	je     801079c1 <copyout.cold>
  return &pgtab[PTX(va)];
80107973:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107975:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010797b:	c1 eb 0c             	shr    $0xc,%ebx
8010797e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107984:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010798b:	89 d9                	mov    %ebx,%ecx
8010798d:	83 e1 05             	and    $0x5,%ecx
80107990:	83 f9 05             	cmp    $0x5,%ecx
80107993:	0f 84 77 ff ff ff    	je     80107910 <copyout+0x20>
  }
  return 0;
}
80107999:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010799c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079a1:	5b                   	pop    %ebx
801079a2:	5e                   	pop    %esi
801079a3:	5f                   	pop    %edi
801079a4:	5d                   	pop    %ebp
801079a5:	c3                   	ret    
801079a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079ad:	8d 76 00             	lea    0x0(%esi),%esi
801079b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079b3:	31 c0                	xor    %eax,%eax
}
801079b5:	5b                   	pop    %ebx
801079b6:	5e                   	pop    %esi
801079b7:	5f                   	pop    %edi
801079b8:	5d                   	pop    %ebp
801079b9:	c3                   	ret    

801079ba <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801079ba:	a1 00 00 00 00       	mov    0x0,%eax
801079bf:	0f 0b                	ud2    

801079c1 <copyout.cold>:
801079c1:	a1 00 00 00 00       	mov    0x0,%eax
801079c6:	0f 0b                	ud2    
