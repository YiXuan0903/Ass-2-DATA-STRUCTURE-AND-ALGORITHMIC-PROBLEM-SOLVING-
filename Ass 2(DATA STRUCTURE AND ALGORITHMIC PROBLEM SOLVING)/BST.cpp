#include <iostream>
#include <fstream>
#include <algorithm>
#include "BST.h"


using namespace std;


BST::BST() {
	root = NULL;
	count = 0;
}


bool BST::empty() {
	if (count == 0) return true;
	return false;
}


int BST::size() {
	return count;
}


void BST::preOrderPrint() {
	if (root == NULL) return;// handle special case
	else preOrderPrint2(root);// do normal process
	cout << endl;
}


void BST::preOrderPrint2(BTNode *cur) {

	if (cur == NULL) return;
	cur->item.print(cout);
	preOrderPrint2(cur->left);
	preOrderPrint2(cur->right);
}


void BST::inOrderPrint() {
	if (root == NULL) return;// handle special case
	else inOrderPrint2(root);// do normal process
	cout << endl;
}


void BST::inOrderPrint2(BTNode *cur) {

	if (cur == NULL) return;

	inOrderPrint2(cur->left);
	cur->item.print(cout);
	inOrderPrint2(cur->right);
}


void BST::postOrderPrint() {
	if (root == NULL) return;// handle special case
	else postOrderPrint2(root);// do normal process
	cout << endl;
}


void BST::postOrderPrint2(BTNode *cur) {
	if (cur == NULL) return;
	postOrderPrint2(cur->left);
	postOrderPrint2(cur->right);
	cur->item.print(cout);
}



int BST::countNode() {
	int	counter = 0;
	if (root == NULL) return 0;
	countNode2(root, counter);
	return counter;
}


void BST::countNode2(BTNode *cur, int &count) {
	if (cur == NULL) return;
	countNode2(cur->left, count);
	countNode2(cur->right, count);
	count++;
}


bool BST::findGrandsons(type grandFather) {
	if (root == NULL) return false;
	return (fGS2(grandFather, root));
}


bool BST::fGS2(type grandFather, BTNode *cur) {
	if (cur == NULL) return false;
	//if (cur->item == grandFather) {
	if (cur->item.compare2(grandFather)){

		fGS3(cur, 0);// do another TT to find grandsons
		return true;
	}
	if (fGS2(grandFather, cur->left)) return true;
	return fGS2(grandFather, cur->right);
}


void BST::fGS3(BTNode *cur, int level) {
	if (cur == NULL) return;
	if (level == 2) {
		cur->item.print(cout);
		return;  // No need to search downward
	}
	fGS3(cur->left, level + 1);
	fGS3(cur->right, level + 1);
}



void BST::topDownLevelTraversal() {
	BTNode			*cur;
	Queue		    q;


	if (empty()) return; 	// special case
	q.enqueue(root);	// Step 1: enqueue the first node
	while (!q.empty()) { 	// Step 2: do 2 operations inside
		q.dequeue(cur);
		if (cur != NULL) {
			cur->item.print(cout);

			if (cur->left != NULL)
				q.enqueue(cur->left);

			if (cur->right != NULL)
				q.enqueue(cur->right);
		}
	}
}

//insert for BST
bool BST::insert(type newItem) {
	BTNode	*cur = new BTNode(newItem);
	if (!cur) return false;		// special case 1
	if (root == NULL) {
		root = cur;
		count++;
		return true; 			// special case 2
	}
	insert2(root, cur);			// normal
	count++;
	return true;
}


void BST::insert2(BTNode *cur, BTNode *newNode) {
	//if (cur->item > newNode->item) {
	if (cur->item.compare1(newNode->item)){
		if (cur->left == NULL)
			cur->left = newNode;
		else
			insert2(cur->left, newNode);
	}
	else {
		if (cur->right == NULL)
			cur->right = newNode;
		else
			insert2(cur->right, newNode);
	}
}



bool BST::remove(type item) {
	if (root == NULL) return false; 		// special case 1: tree is empty
	return remove2(root, root, item); 		// normal case
}

bool BST::remove2(BTNode *pre, BTNode *cur, type item) {

	// Turn back when the search reaches the end of an external path
	if (cur == NULL) return false;

	// normal case: manage to find the item to be removed
	//if (cur->item == item) {
	if (cur->item.compare2(item)){
		if (cur->left == NULL || cur->right == NULL)
			case2(pre, cur);	// case 2 and case 1: cur has less than 2 sons
		else
			case3(cur);		// case 3, cur has 2 sons
		count--;				// update the counter
		return true;
	}

	// Current node does NOT store the current item -> ask left sub-tree to check
	//if (cur->item > item)
	if (cur->item.compare1(item))
		return remove2(cur, cur->left, item);

	// Item is not in the left subtree, try the right sub-tree instead
	return remove2(cur, cur->right, item);
}


void BST::case2(BTNode *pre, BTNode *cur) {

	// special case: delete root node
	if (pre == cur) {
		if (cur->left != NULL)	// has left son?
			root = cur->left;
		else
			root = cur->right;

		free(cur);
		return;
	}

	if (pre->right == cur) {		// father is right son of grandfather? 
		if (cur->left == NULL)			// father has no left son?
			pre->right = cur->right;			// connect gfather/gson
		else
			pre->right = cur->left;
	}
	else {						// father is left son of grandfather?
		if (cur->left == NULL)			// father has no left son? 
			pre->left = cur->right;				// connect gfather/gson
		else
			pre->left = cur->left;
	}

	free(cur);					// remove item
}


void BST::case3(BTNode *cur) {
	BTNode		*is, *isFather;

	// get the IS and IS_parent of current node
	is = isFather = cur->right;
	while (is->left != NULL) {
		isFather = is;
		is = is->left;
	}

	// copy IS node into current node
	cur->item = is->item;

	// Point IS_Father (grandfather) to IS_Child (grandson)
	if (is == isFather)
		cur->right = is->right;		// case 1: There is no IS_Father    
	else
		isFather->left = is->right;	// case 2: There is IS_Father

	// remove IS Node
	free(is);
}


//2nd:Print Deepest Level node
//calculate the height of tree
int BST::tree_height(BTNode* cur) {
	//Base case
	if (cur == NULL) return 0;
	else {
		//find the height of left and right subtrees
		int left_height = tree_height(cur->left);
		int right_height = tree_height(cur->right);

		//get the greater value
		if (left_height >= right_height) {
			return left_height + 1;
		}
		else {
			return right_height + 1;
		}

	}
}

//get the level of a node
int BST::getLevel(int data)
{
	//initialization for tree level 
	int level = 1;
	if (root == NULL) return 0;
	return getLevel2(root, data, level);
}
int BST::getLevel2(BTNode* cur, int data, int level) {
	//Base Case
	if (cur == NULL)
		return 0;

	//if point to the correct data
	if (cur->item.id == data)
		return level;

	//continue search left subtree
	int leftlevel = getLevel2(cur->left, data, level + 1);
	if (leftlevel != 0)
		return leftlevel;
	//search right subtree
	leftlevel = getLevel2(cur->right, data, level + 1);
}


bool BST::deepestNodes() {

	if (root == NULL) 
		return false;  //special case

	else {
		int height = tree_height(root);
		cout << "Node(s) at deepest level: ";
		deepestNodes2(root, height); //normal
	}

	cout << endl;
	return true;
}

void BST::deepestNodes2(BTNode* cur, int height) {
	//Base Case
	if (cur == NULL) return;

	deepestNodes2(cur->left, height);

	//compare the height and the level of the node
	//to check whether it is the deepest level node
	if (getLevel(cur->item.id) == height) {
		cout << cur->item.id << " ";
	}

	deepestNodes2(cur->right, height);
}
//End of 2nd

//3rd: Display
bool BST::display(int order, int source) {
	if (root == NULL) return false;

	if (source == 1) {  // Print to screen
		if (order == 1) {
			inOrderPrint();  // Ascending order
		}
		else if (order == 2) {
			descendingPrint(root);  // Descending order
		}
	}
	else if (source == 2) {  // Print to file
		ofstream outFile("student-info.txt");
		if (!outFile.is_open()) return false;

		if (order == 1) {
			inOrderPrintToFile(root, outFile);  // Ascending order
		}
		else if (order == 2) {
			descendingPrintToFile(root, outFile);  // Descending order
		}

		outFile.close();
	}
	return true;
}

void BST::inOrderPrintToFile(BTNode* node, ofstream& outFile) {
	if (node == NULL) return;

	inOrderPrintToFile(node->left, outFile);
	node->item.print(outFile);
	inOrderPrintToFile(node->right, outFile);
}

void BST::descendingPrint(BTNode* node) {
	if (node == NULL) return;

	descendingPrint(node->right);
	node->item.print(cout);
	descendingPrint(node->left);
}

void BST::descendingPrintToFile(BTNode* node, ofstream& outFile) {
	if (node == NULL) return;

	descendingPrintToFile(node->right, outFile);
	node->item.print(outFile);
	descendingPrintToFile(node->left, outFile);
}
//End of 3rd

//4th: Clone subtree
BTNode* BST::FindNodeWithValue(BTNode* cur, type item)
{
	if (cur == nullptr)
	{
		return nullptr; //returns a pointer to a BTNode*
	}

	if (cur->item.compare2(item)) // comparing if cur->item == item
	{
		return cur;//when the desired value has been found
	}

	BTNode* leftResult = FindNodeWithValue(cur->left, item);
	if (leftResult) //if leftResult is not null 
	{
		return leftResult;
	}

	BTNode* rightResult = FindNodeWithValue(cur->right, item);//Similarly with leftResult
	return rightResult;
}

void BST::CloneSubtreeRecursiveWithPrint(BTNode* cur, BST& t2) //clone subtree rooted at cur node & insert it into another BST.It appears to use a recursive approach.
{
	if (cur == NULL) return;

	// Recursively clone the subtree rooted at cur & insert into t2
	t2.insert(cur->item);


	// Recursively clone the left & right subtrees
	CloneSubtreeRecursiveWithPrint(cur->left, t2);
	CloneSubtreeRecursiveWithPrint(cur->right, t2);

}

bool BST::CloneSubtree(BST t1, type item)
{
	BST t2;;
	if (t1.empty() || root != NULL) //check if t1 is empty || checks if the cur tree already has a root node
		return false;

	BTNode* foundNode = FindNodeWithValue(t1.root, item);//intended to find a node in t1 with specified item

	if (!foundNode) //if foundNode is null
		return false;

	CloneSubtreeRecursiveWithPrint(foundNode, *this);//for cloning the subtree rooted at foundNode & insert it into the cur tree 
	cout << "\tt1\n";
	cout << "-----------------------------" << endl;
	t1.preOrderPrint(); //Print original tree
	cout << "\n" << endl;

	cout << "\tt2" << endl;
	cout << "-----------------------------" << endl;
	preOrderPrint(); //Print clone tree
	cout << "\n\n";

	return true;
}

bool BST::CloneSubtree2(BTNode* cur, type item)
{
	if (cur == NULL)//checks if the cur node is null pointer
		return false;

	if (cur->item.compare2(item)) //when desired value has been found in the cur node
		return true;

	if (cur->item.compare1(item)) //when compare2 is not true
		return CloneSubtree2(cur->left, item);

	return CloneSubtree2(cur->right, item);//neither of the previous conditions is met, proceeds to search for item in the right subtree.
}

void BST::CloneSubtree3(BTNode* cur)//recursively clone an entire binary tree starting from the given cur node and insert the cloned values into the cur BST
{
	if (cur == NULL)//means the function has reached the end of a branch in the tree without finding any nodes to clone. 
		return;//simply return to break the recursion for this branch.

	//makes two recursive calls to CloneSubtree3
	CloneSubtree3(cur->left);
	CloneSubtree3(cur->right);
	//insert the value stored in the cur node's item into the cur BST. It effectively recreates the entire binary tree structure rooted at cur and inserts it into the cur tree.
	insert(cur->item);
}
//End of 4th

// 5th: Print Level Nodes
bool BST::printLevelNodes()
{
	BTNode* current;
	Queue q;
	int level = 1;
	int levelSize;

	if (empty()) // special case
		return false;
	else {
		q.enqueue(root);  //enqueue root
		while (!q.empty())
		{
			levelSize = q.size();

			cout << "Level " << level << " nodes: "; // Print label for current level

			for (int i = 0; i < levelSize; ++i)
			{
				q.dequeue(current);

				cout << current->item.id << " "; // print student ID

				if (current->left != nullptr) // enqueue for left children
				{
					q.enqueue(current->left);
				}
				if (current->right != nullptr) // enqueue for right children
				{
					q.enqueue(current->right);
				}
			}
			cout << endl;// Move next line after finish a line
			level++; // move to next level
		}
		return true;//successfully printed the tree nodes by level
	}
}
// End of 5th

//6th: Print All Path
bool BST::printPath() {
	if (root == NULL) return false;

	int path[1000];  // Assuming a maximum depth of 1000 for simplicity
	printAllPaths(root, path, 0);
	return true;
}

void BST::printAllPaths(BTNode* node, int path[], int pathLen) {
	if (node == NULL) return;

	// Add the current node's ID to the path array
	path[pathLen] = node->item.id;
	pathLen++;

	// If this is a leaf node, print the path
	if (node->left == NULL && node->right == NULL) {
		printArray(path, pathLen);
	}
	else {
		// Otherwise, recursively go down the left and right children
		printAllPaths(node->left, path, pathLen);
		printAllPaths(node->right, path, pathLen);
	}
}

void BST::printArray(int path[], int pathLen) {
	for (int i = 0; i < pathLen; i++) {
		cout << path[i] << " ";
	}
	cout << endl;
}
//End of 6th
