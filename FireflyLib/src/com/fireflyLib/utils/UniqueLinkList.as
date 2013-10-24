package com.fireflyLib.utils
{
	import flash.utils.Dictionary;

	public class UniqueLinkList
	{
		private var mLength:uint = 0;
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
		
		public function findItemByFunction(func:Function):*
		{
			if(mLength == 0) return null;
			
			var item:* = null;
			var node:Node = mHeadNode;
			while(node)
			{
				item = node.value;
				if(func(item)) return item;
				
				node = node.next;
			}
			
			return null;
		}
		
		public function findItemsByFunction(func:Function):Array
		{
			if(mLength == 0) return null;
			
			var results:Array = [];
			
			var item:* = null;
			var node:Node = mHeadNode;
			while(node)
			{
				item = node.value;
				if(func(item))
				{
					results.push(item);
				}
				
				node = node.next;
			}
			
			return results;
		}
		
		public function get length():uint
		{
			return mLength;
		}
		
		public function clear():void
		{
			mHeadNode = null;
			mTailNode = null;
			mNodesPool.length = 0;
			mLength = 0;
			mItemsHashMap = new Dictionary();
			mCursorNode = null;
		}
		
		public function add(item:*):*
		{
			if(!item || mItemsHashMap[item] !== undefined) return null;

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
			if(!item || mLength == 0) return null;
			
			var itemNode:* = mItemsHashMap[item];
			if(itemNode === undefined) return null;
			
			var node:Node = Node(itemNode);
			if(mLength == 1)
			{
				mCursorNode = mHeadNode = mTailNode = null;
			}
			else//must big than 1
			{
				if(node === mHeadNode)
				{
					mHeadNode = node.next;
					mHeadNode.pre = null;
					
					if(mCursorNode === node) mCursorNode = null; 
				}
				else if(node === mTailNode)
				{
					mTailNode = node.pre;
					mTailNode.next = null;
					
					if(mCursorNode === node) mCursorNode = mTailNode;
				}
				else
				{
					node.pre.next = node.next;
					node.next.pre = node.pre;
					
					if(mCursorNode == node) mCursorNode = node.pre;
				}
			}
			
			recycleNode(node);
			delete mItemsHashMap[item];
			mLength--;
			
			return item;
		}
		
		public function hasItem(item:*):Boolean
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
			mCursorNode = mCursorNode.next;
			return mCursorNode ? mCursorNode.value : null;
		}
		
		public function sort(compareFunction:Function):void
		{
			if(mLength < 1) return;
			
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