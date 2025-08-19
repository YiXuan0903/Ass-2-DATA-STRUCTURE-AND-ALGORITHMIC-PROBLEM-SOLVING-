#include	<iostream>
#include	<fstream>
#include	<cstdlib>
#include	<cstdio>
#include	<ctime>
#include	"BST.h"
#include    "Student.h"

using namespace std;

bool readFile(char* filename, BST* t1);
int menu();

int main() {
	BST t1;
	char* PtrFile;
	int choice;
	bool loop = true;
	bool fileRead = false; // Flag to check if the file has been read

	do {//continue print the menu until exit
		system("cls");
		choice = menu();//call menu function to return choice
		system("cls");

		switch (choice)
		{
			//Read file
		case 1:
		{
			char filename[12] = "student.txt";
			PtrFile = filename;

			if (readFile(PtrFile, &t1)) //If the file can be read
			{
				cout << "\n" << t1.count << " student records in the file " << PtrFile << " has been successfully read.\n\n";
				fileRead = true;
			}
			else
				cout << "\nThe file " << PtrFile << " is not found!!!" << endl;

			system("pause");
			break;
		}
		//Print deepest nodes
		case 2:
		{
			if (!t1.deepestNodes())
				cout << "Cannot print deepest nodes from an empty tree." << endl;

			system("pause");
			break;
		}
		// Display student records
		case 3:
		{
			if (!fileRead) // Check if file has been read
			{
				cout << "Please read the file first before displaying student records." << endl;
			}
			else
			{
				int order, source;

				// Validate order input
				do {
					cout << "Select display order (1 = Ascending, 2 = Descending): ";
					cin >> order;
					if (order != 1 && order != 2) {
						cout << "Invalid input. Please enter 1 or 2." << endl;
					}
				} while (order != 1 && order != 2);

				// Validate source input
				do {
					cout << "Choose output destination (1 = Screen, 2 = File): ";
					cin >> source;
					if (source != 1 && source != 2) {
						cout << "Invalid input. Please enter 1 or 2." << endl;
					}
				} while (source != 1 && source != 2);

				if (!t1.display(order, source)) {
					cout << "Unable to display student records!" << endl;
				}
				else {
					if (source == 1)
						cout << "Student records have been successfully displayed on the screen in "
						<< (order == 1 ? "ascending" : "descending") << " order." << endl << endl;
					else
						cout << "Student records have been successfully saved to 'student-info.txt' in "
						<< (order == 1 ? "ascending" : "descending") << " order." << endl << endl;
				}
			}

			system("pause");
			break;
		}
		case 4:
		{
			char again;
			type student;
			BST Clone;

			cout << "\nPlease enter a student id:"; //Ask for student id input
			cin >> student.id;
			cout << endl;
			system("cls");

			//Create a clonetree of that student id as root
			if (!Clone.CloneSubtree(t1, student))
			{
				cout << "Cannot clone subtree" << endl;

			}
			system("pause");
			break;
		}
		case 5:
		{
			system("cls");
			if (!t1.empty()) {
				system("cls");
				cout << "Printing level nodes..." << endl;
				t1.printLevelNodes();
			}
			else {
				cout << "The tree is empty. Try reading data to BST first..." << endl;
			}
			system("pause");
			break;
		}
		// Print all external paths in the BST
		case 6: // Option 6 is for printPath
		{
			if (!fileRead) // Check if file has been read
			{
				cout << "Please read the file first before printing paths." << endl;
			}
			else
			{
				// Show message before printing paths
				cout << "Below are all the external paths for the tree:" << endl << endl;

				if (!t1.printPath()) {
					cout << "Tree is empty or an error occurred!" << endl;
				}
				else {
					// Success message after paths are printed
					cout << "\nAll external paths in the BST have been successfully printed." << endl << endl;
				}
			}

			system("pause");
			break;
		}
		case 7: {
			cout << "Exiting the program..." << endl;
			system("pause");
			break;
		}
		}
	} while (loop);//while loop is true
	system("pause");
	return 0;
}

bool readFile(char* filename, BST* t1) {
	ifstream myfile;
	myfile.open(filename);

	if (myfile.fail()) //Return false if unable to open the file
		return false;

	else {
		while (!myfile.eof()) {//While it is not at the end of the file
			char empty;
			Student student;

			//discard 10 characters to get id
			for (int i = 0; i < 10; i++)
				myfile >> empty;
			myfile >> student.id;

			//discard 5 characters to get name
			for (int i = 0; i < 5; i++)
				myfile >> empty;
			myfile.ignore();
			myfile.get(student.name, 30);

			//discard 8 characters to get address
			for (int i = 0; i < 8; i++)
				myfile >> empty;
			myfile.ignore();
			myfile.get(student.address, 100);

			//discard 4 character to get DOB
			for (int i = 0; i < 4; i++)
				myfile >> empty;
			myfile.ignore();
			myfile.get(student.DOB, 20);

			//discard 12 characters to get phone_no
			for (int i = 0; i < 12; i++)
				myfile >> empty;
			myfile.ignore();
			myfile.get(student.phone_no, 10);

			//discard 7 characters to get course
			for (int i = 0; i < 7; i++)
				myfile >> empty;
			myfile.ignore();
			myfile.get(student.course, 5);

			//discard 5 characters to get cgpa
			for (int i = 0; i < 5; i++)
				myfile >> empty;
			myfile >> student.cgpa;

			//Insert the node into tree
			t1->insert(student);
		}
		return true;
	}
}

//display menu
int menu()
{
	int choice;
	cout << "\tMENU" << endl;
	cout << "-------------------------------" << endl;
	cout << "|1. Read data to BST           |" << endl;
	cout << "|2. Print deepest nodes        |" << endl;
	cout << "|3. Display student            |" << endl;
	cout << "|4. Clone Subtree              |" << endl;
	cout << "|5. Print Level Nodes          |" << endl;
	cout << "|6. Print Path                 |" << endl;
	cout << "|7. Exit                       |" << endl;
	cout << "-------------------------------" << endl;
	cout << "Please key in your options: ";
	cin >> choice; //allow user to choose 7 options from the menu
	return choice;
}
