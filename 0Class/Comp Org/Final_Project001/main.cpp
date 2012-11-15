#include <stdio.h>
#include <math.h>
//Globals
#define uint unsigned int
#define ulong unsigned long

//breif: CacheBlocks are where data about a particular block is (the child is used for associative blocks).
class CacheBlock{
 public:
  CacheBlock(){child=NULL;dirty=false;}
  CacheBlock(ulong addressA){child=NULL;dirty=false;address=addressA;}
  //doing a linked list only makes sense for full associative.
  //CacheBlock* next;//linked list (forward one)
  //CacheBlock* back;//linked list (back one)
  CacheBlock* child;//the next child of an associative block
  ulong address;//The first address of the block stored in memory (must be mod block size==0)
  bool dirty;//a dirty bit
};

//breif: Global variables are used a lot to make the program more efficient. This is where they are stored.
namespace GlbDat{

  static ulong L1_block_size=32;
  static ulong L1_cache_size=8192;
  static ulong L1_assoc=1;
  static ulong L1_hit_time=1;
  static ulong L1_miss_time=1;

  static ulong L2_block_size=64;
  static ulong L2_cache_size=65536;
  static ulong L2_assoc=1;//(Number of colums)
  static ulong L2_hit_time=4;
  static ulong L2_miss_time=6;
  static ulong L2_transfer_time=6;
  static ulong L2_bus_width=16;

  static ulong mem_sendaddr=10;
  static ulong mem_ready=50;
  static ulong mem_chunktime=20;
  static ulong mem_chunksize=16;

  static ulong clock_cycle=0;//A running sum off all clock cycles

  //Dependant variables (these are calculated from the ones above but are used often enough to just stay const)
  static ulong L1_numBlocks;//(Number of rows)
  static ulong L1_numBlocksWA;//with associative

  //List of caches
  static CacheBlock** L1_Data;//probably going to be an array instead of linked list.
  static CacheBlock** L1_Prog;
  static CacheBlock** L2_Unif;

  class Cache{
   public:
    //Defined variables (must be defined at runtime or use the default values)
    ulong block_size;
    ulong cache_size;
    ulong assoc;
    ulong hit_time;
    ulong miss_time;

    //Dependant variables (these are calculated from the ones above but are used often enough to just stay const)
    ulong numBlocks;//(Number of rows)
    ulong numBlocksWA;//with associative
    CacheBlock** blocks;//cache var
  };
  class L1Cache:public Cache{
   public:
   L1Cache(){
    block_size =L1_block_size;
    cache_size =L1_cache_size;
    assoc      =L1_assoc;
    hit_time   =L1_hit_time;
    miss_time  =L1_miss_time;
    numBlocks  =L1_numBlocks;
    numBlocksWA=L1_numBlocksWA;
   }
  };
  class L2Cache:public Cache{
   public:
   L2Cache(){
    block_size=L2_block_size;
    cache_size=L2_cache_size;
    assoc     =L2_assoc;
    hit_time  =L2_hit_time;
    miss_time =L2_miss_time;
   }
  };

  //Cache Listing.
  static bool initialized=false;
  static Cache L1P;//L1 Program Cache
  static Cache L1D;//L1 Data Cache
  static Cache L2U;//L2 Unified Cache

  //breif: Update Dependant variables
  static void updateDV(){
   L1_numBlocksWA=L1_cache_size/L1_block_size;
   L1_numBlocks=L1_numBlocksWA/L1_assoc;
  }

  //brief: Intializes all globals if they have not already been initialized
  static void Initialize(){
   if(!initialized){
    initialized=true;
    updateDV();
    L1P=L1D=L1Cache();
    L2U    =L2Cache();
   }
  }

  //The best way to access respective caches.
  static Cache* getL1P(){
   Initialize();
   return &L1P;
  }
  static Cache* getL1D(){
   Initialize();
   return &L1D;
  }
  static Cache* getL2U(){
   Initialize();
   return &L2U;
  }
};

static void CBpush(CacheBlock* head,CacheBlock* value){
 if(head->child!=NULL)return CBpush(head->child,value);
 head->child=value;
 return;
}

//brief: Checks a paricular cache for a value (also updates the cache)
static int checkCache(GlbDat::Cache* cache,ulong addr){
 //Make the new cache value
 CacheBlock* newValue=new CacheBlock(floor(addr/cache->block_size)*cache->block_size);
 //L1 Program Cache
 ulong blockRow=(addr/cache->block_size)%cache->numBlocks;//floor of that value
 CacheBlock* tem_blk=cache->blocks[blockRow];
 CacheBlock* tem_blk_Old=NULL;
 for(ulong i=0;i<cache->assoc;i++){
  if(tem_blk==NULL){
   //not full need to add (no replacement needed)
   if(tem_blk!=NULL){
    tem_blk->child=newValue;
   }else{
    cache->blocks[blockRow]=newValue;
   }
   return 1;//Comming Soon: +checkL2PCache(addr);
  }
  if(tem_blk){
   return 0;
  }
  tem_blk_Old=tem_blk;
  tem_blk=tem_blk->child;
 }
 //not found bring in (need to replace 1) (shift->delete->append)
 tem_blk=cache->blocks[blockRow];
 cache->blocks[blockRow]=cache->blocks[blockRow]->child;
 delete tem_blk;

 tem_blk=cache->blocks[blockRow];
 while(true){
  if(tem_blk->child==NULL){
   tem_blk->child=newValue;
   return 1;//Comming Soon: +checkL2PCache(addr);
  }
  tem_blk=tem_blk->child;
 }
}

//finds access time
static void findTime(ulong addr){
 if(checkCache(GlbDat::getL1P(),addr)){
  //hit --> Just load in

 }else{
  //miss
 }
}

int main(){
 //Set Defaults
 GlbDat::Initialize();



 //Setup Loop Variables
 char op;
 uint address,exec_info;

 //Start Loop
 while (scanf("%c %x %xnn",&op,&address,&exec_info) == 3){
  switch(op){
   case 'L':

    break;
   case 'S':

    break;
   case 'B':

    break;
   case 'C':

    break;
  }
 }
}
