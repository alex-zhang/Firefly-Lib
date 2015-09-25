package com.fireflyLib.utils
{
	import flash.utils.Dictionary;

	public class UniqueLinkList
	{
		private var mLength:int = 0;
		private var mItemsHashMap:Dictionary = new Dictionary();//item->node
		private var mNodesPool:Vector.<Node> = new Vector.<Node>();
		private var mNodeSortArray:Vector.<Node>;
		
		private var mHeadNode:Node = null;
		private var mTailNode:Node = null;
		
		private var mCursorNode:Node = null;
		
		public function UniqueLinkList()
		{
			super();
		}
		
		public function findItemByFunction(filterFunc:Function = null):*
		{
			if(filterFunc != null && mLength > 0)
			{
				var item:* = null;
				var node:Node = mHeadNode;
				while(node)
				{
					item = node.value;
					if(filterFunc(item))
					{
						return item;
					}
					
					node = node.next;
				}
			}
			
			return undefined;
		}
		
		public function findItemsByFunction(results:Array = null, filterFunc:Function = null):Array
		{
			if(!results) results = [];
			
			if(filterFunc != null && mLength > 0)
			{
				var item:* = null;
				var node:Node = mHeadNode;
				while(node)
				{
					item = node.value;
					if(filterFunc(item))
					{
						results.push(item);
					}
					
					node = node.next;
				}
			}
			
			return results;
		}
		
		public function findAllItems(results:Array = null):Array
		{
			if(!results) results = [];
			
			if(mLength > 0)
			{
				var item:* = null;
				var node:Node = mHeadNode;
				while(node)
				{
					item = node.value;
					results.push(item);
					
					node = node.next;
				}
			}
			
			return results;
		}
		
		public function get length():int
		{
			return mLength;
		}
		
		public function clear():void
		{
			mCursorNode = mHeadNode = mTailNode = null;
			mLength = mNodesPool.length = 0;
			mItemsHashMap = new Dictionary();
		}
		
		public function add(item:*):*
		{
			if(!item || mItemsHashMap[item] !== undefined) return undefined;

			var node:Node = getFreeNode();
			
			if(mLength == 0)
			{
				mHeadNode = node;
			}
			else
			{
				mTailNode.next = node;
				node.pre = mTailNode;
			}
			
			//the new one become the tail
			mTailNode = node;
			
			node.value = item;
			mItemsHashMap[item] = node;
			mLength++;
			
			return item;
		}
		
		public function remove(item:*):*
		{
			if(!item || mLength == 0) return undefined;
			
			var itemNode:* = mItemsHashMap[item];
			if(itemNode === undefined) return undefined;
			
			var node:Node = Node(itemNode);
			if(mLength == 1)
			{
				mCursorNode = mHeadNode = mTailNode = null;
			}
			else//must big than 1
			{
				if(node === mHeadNode)
				{
					mHeadNode = mHeadNode.next;
					mHeadNode.pre = null;
					
					if(mCursorNode === node) mCursorNode = null; 
				}
				else if(node === mTailNode)
				{
					mTailNode = mTailNode.pre;
					mTailNode.next = null;
					
					if(mCursorNode === node) mCursorNode = mTailNode;
				}
				else
				{
					node.pre.next = node.next;
					node.next.pre = node.pre;
					
					if(mCursorNode === node) mCursorNode = node.pre;
				}
			}
			
			recycleNode(node);
			delete mItemsHashMap[item];
			mLength--;
			
			return item;
		}
		
		public function has(item:*):Boolean
		{
			return mItemsHashMap[item] !== undefined;
		}
		
		public function moveFirst():*
		{
			mCursorNode = mHeadNode;
			return mCursorNode ? mCursorNode.value : null;
		}
		
		public function moveNext():*
		{
			mCursorNode = mCursorNode ? mCursorNode.next : mHeadNode;
			return mCursorNode ? mCursorNode.value : null;
		}
		
		public function movePre():*
		{
			mCursorNode = mCursorNode ? mCursorNode.pre : mTailNode;
			return mCursorNode ? mCursorNode.value : null;
		}
		
		public function moveLast():*
		{
			mCursorNode = mTailNode;
			return mCursorNode ? mCursorNode.value : null;
		}
		
		public function indexOf(findItem:*):int
		{
			if(mLength > 0)
			{
				if(!has(findItem)) return -1;
				
				var index:int = -1;
				
				var item:* = null;
				var node:Node = mHeadNode;
				while(node)
				{
					item = node.value;
					index++;
					
					if(item === findItem)
					{
						return index;
					}
					
					node = node.next;
				}
			}
			
			return -1;
		}
		
		public function lastIndexOf(findItem:*):int
		{
			if(mLength > 0)
			{
				if(!has(item)) return -1;
				
				var index:int = -1;
				
				var item:* = null;
				var node:Node = mTailNode;
				while(node)
				{
					item = node.value;
					index++;
					
					if(item === findItem)
					{
						return mLength - index - 1;
					}
					
					node = node.pre;
				}
			}
			
			return -1;
		}
		
		public function sort(compareFunction:Function):void
		{
			if(!compareFunction || mLength <= 1) return;
			
			if(!mNodeSortArray) mNodeSortArray = new Vector.<Node>(); 
			
			var node:Node = mHeadNode;
			while(node)
			{
				mNodeSortArray.push(node);
				node = node.next;
			}
			
			mSortCampareFunction = compareFunction;
			mNodeSortArray.sort(nodeSortCampareFunction);
			mSortCampareFunction = null;
			
			var nextNode:Node = null;
			var n:int = mNodeSortArray.length - 1;
			for(var i:int = 0; i < n; i++)
			{
				node = mNodeSortArray[i];
				nextNode = mNodeSortArray[i + 1];
				
				node.next = nextNode;
				nextNode.pre = node;
			}
			
			mHeadNode = mNodeSortArray[0];
			mTailNode = mNodeSortArray[n];
			
			mHeadNode.pre = null;
			mTailNode.next = null;
			
			mNodeSortArray.length = 0;
		}
		
		private var mSortCampareFunction:Function = null;
		private function nodeSortCampareFunction(a:Node, b:Node):Number
		{
			return mSortCampareFunction(a.value, b.value);
		}
		
		//--
		
		private function getFreeNode():Node
		{
			return mNodesPool.length ? mNodesPool.pop() : new Node();
		}
		
		private function recycleNode(node:Node):void
		{
			node.value = null;
			node.pre = null;
			node.next = null;
			mNodesPool.push(node);
		}
	}
}

internal final class Node
{
	internal var value:* = null;
	internal var pre:Node = null;
	internal var next:Node = null;
}