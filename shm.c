#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct shm_page {
    uint id;
    char* frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}



int shm_open(int id, char **pointer)      
{
    int found = 0; int emptyIndex = -1;
    char* mem = 0;

    acquire(&(shm_table.lock));
    for (int i = 0; i < 64; i++)
    {
        if (shm_table.shm_pages[i].id == id)
        {
            found = 1;
            if(mappages(myproc()->pgdir, (char*)myproc()->sz, PGSIZE, V2P(shm_table.shm_pages[i].frame), PTE_W|PTE_U) < 0)
	        cprintf("mapping of segment id to an available page in our virtual address space failed!!!\n");
            else
            {
                shm_table.shm_pages[i].refcnt++;
	        *pointer=(char *)myproc()->sz;
                myproc()->sz += PGSIZE;
            }
        
            break;
	}
        else if (!shm_table.shm_pages[i].id)
            emptyIndex = i;
    }

    if (!found)
    {
        shm_table.shm_pages[emptyIndex].id = id;
        
        mem = kalloc();
        if (!mem)
        {
            cprintf("shm_open out of memory\n");
            //deallocuvm(pgdir, newsz, oldsz);
            goto bad;
        }
        memset(mem, 0, PGSIZE);

        shm_table.shm_pages[emptyIndex].frame = mem;

        shm_table.shm_pages[emptyIndex].refcnt = 1;

        if(mappages(myproc()->pgdir, (char*)myproc()->sz, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0)
        {
            cprintf("shm_open out of memory (2)\n");
            //deallocuvm(pgdir, newsz, oldsz);
            kfree(mem); 
        }
        else
        {
            *pointer=(char *)myproc()->sz;
            myproc()->sz += PGSIZE;
        }
    }
    release(&(shm_table.lock));


    bad:
    return 0; //added to remove compiler warning -- you should decide what to return
}


int shm_close(int id)
{
    acquire(&(shm_table.lock));
    for (int i = 0; i < 64; i++)
    {
        if (shm_table.shm_pages[i].id == id)
        {
            shm_table.shm_pages[i].refcnt--;

            if (!shm_table.shm_pages[i].refcnt)
                shminit();

            break;
        }
    }
    release(&(shm_table.lock));

    return 0; //added to remove compiler warning -- you should decide what to return
}
