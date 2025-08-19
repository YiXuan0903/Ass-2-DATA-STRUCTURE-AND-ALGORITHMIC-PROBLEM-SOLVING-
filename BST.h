#ifndef BT_type
#define BT_type

#include	"BTNode.h"
#include	"Queue.h"


struct BST {

		int		count;
		BTNode	*root;

		// print operation for BST (same as BT)					
		void preOrderPrint2(BTNode *);	// recursive function for preOrderPrint()
		void inOrderPrint2(BTNode *);	// recursive function for inOrderPrint()
		void postOrderPrint2(BTNode *);	// recursive function for postOrderPrint()

		// sample operation (extra functions) - same as BT
		void countNode2(BTNode *, int &);		// recursive function for countNode()
		bool fGS2(type, BTNode *);					// recursive function for findGrandsons(): to find the grandfather
		void fGS3(BTNode *, int);				// recursive function for findGrandsons(): to find the grandsons after the grandfather has been found
		
		// basic functions for BST
		void insert2(BTNode *, BTNode *);		// recursive function for insert() of BST
		void case3(BTNode *);					// recursive function for remove()
		void case2(BTNode *, BTNode *);		// recursive function for remove()
		bool remove2(BTNode *, BTNode *, type);	// recursive function for remove()



		// basic functions for BST
		BST();
		bool empty();
		int size();
		bool insert (type);		// insert an item into a BST
		bool remove(type);			// remove an item from a BST
		
		// print operation for BST (same as BT)
		void preOrderPrint();			// print BST node in pre-order manner
		void inOrderPrint();			// print BST node in in-order manner
		void postOrderPrint();			// print BST node in post-order manner
		void topDownLevelTraversal();	// print BST level-by-level

		// sample operation (extra functions) - same as BT
		int countNode();		// count number of tree nodes
		bool findGrandsons(type);	// find the grandsons of an input father item

		//2nd
		//get level for a node
		int getLevel(int); //get the level of a node
		int getLevel2(BTNode*, int, int);//recursive function for getlevel(int)
		//calculate the height of the tree
		int tree_height(BTNode*);
		//Deepest nodes
		bool deepestNodes();//compare and print the deepest level node
		void deepestNodes2(BTNode*, int);//recursive function for deepestNodes()
		
		//3rd
		bool display(int order, int source);
		

		//4th
		BTNode* FindNodeWithValue(BTNode* cur, type item); //Searches for a node with a specific item within a binary tree
		void CloneSubtreeRecursiveWithPrint(BTNode* cur, BST& t2); //Clones a subtree rooted at a given node and inserts it into another BST
		bool CloneSubtree(BST, type);//Finds a specific item in t1 and clones all descendants of that item (subtree) and the item itself into another tree
		bool CloneSubtree2(BTNode*, type);//recursive helper function for CloneSubtree() that checks whether the specified item has been found or not
		void CloneSubtree3(BTNode*);//recursive helper function for CloneSubtree() responsible for cloning the entire subtree rooted at cur node.

		//5th
		bool printLevelNodes();
	
		//6th
		bool printPath();

private:
	void inOrderPrintToFile(BTNode* node, ofstream& outFile);
	void descendingPrint(BTNode* node);
	void descendingPrintToFile(BTNode* node, ofstream& outFile);
	void printAllPaths(BTNode* node, int path[], int pathLen);
	void printArray(int path[], int pathLen);

};




#endif