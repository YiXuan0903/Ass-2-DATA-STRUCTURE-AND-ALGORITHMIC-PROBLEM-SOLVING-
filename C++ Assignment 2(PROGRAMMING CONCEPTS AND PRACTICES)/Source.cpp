#include <iostream>
#include <iomanip>
#include <fstream>
#include <string>

using namespace std;

#define SIZE 100 //global definition to determine the size of all the array in A2
string currentUser = "Karen Tan Wei Wei"; //global definition with default value to determine the current user

//1. Define the FUNCTION PROTOTYPE for all the listed functions
void menu();
void readItemList(string itemNames[], string itemCodes[], double itemPrices[], double purchaseWeights[], int itemNum[], int& totalItems);
void addItemList(string itemNames[], string itemCodes[], double itemPrices[], double purchaseWeights[], int itemNum[], int& totalItems);
void displayItemList(string itemNames[], string itemCodes[], double itemPrices[], double purchaseWeights[], int itemNum[], int totalItems);
void readTransaction(double& totalAmount, string date[], double amount[], int& num);//readTransaction function prototpye
void transaction(double& totalAmount, string date[], double amount[], int& num);//transaction function prototype
void displayTransactionDetails(double totalAmount, string date[], double amount[], int num);//displayTransaction function prototype

int main() {

	//2. Define and initialise all the necessary variables
	int select, cont = 1;

	//variable for item
	int totalItems = 0, itemNum[SIZE];
	string itemNames[SIZE], itemCodes[SIZE];
	double itemPrices[SIZE], purchaseWeights[SIZE];

	//variable for transaction
	int num = 0;
	double totalAmount = 0, amount[SIZE];
	string date[SIZE];




	//--------------------- Start of Member 2 or Member 3 --------------------------------
	//4. Function call readItemList with the required parameters 
	readItemList(itemNames, itemCodes, itemPrices, purchaseWeights, itemNum, totalItems);
	//5. Function call readTransaction with the required parameters
	readTransaction(totalAmount, date, amount, num);

	do {
		system("cls");

		//6. Indicate username if user able to login
		cout << "Username: " << currentUser << endl;
		menu();
		cout << "Choice: ";
		cin >> select;


		system("cls");
		cin.ignore();

		//7. if...else is implemented to select the function according to the user input
		if (select == 1)
		{
			//Function call displayItemList to display the item from the list
			displayItemList(itemNames, itemCodes, itemPrices, purchaseWeights, itemNum, totalItems);
			cin.ignore();
		}
		else if (select == 2)
		{
			//Function call addItemList to add new items into the list
			addItemList(itemNames, itemCodes, itemPrices, purchaseWeights, itemNum, totalItems);
			cin.ignore();
		}
		else if (select == 3)
		{
			//Function call transaction to modify the details of the items in the list
			transaction(totalAmount, date, amount, num);
			cin.ignore();
		}
		else if (select == 4)
		{
			//Function call displayTransactionDetails to print the invoice of the items in the list
			displayTransactionDetails(totalAmount, date, amount, num);
			cin.ignore();
		}
		else if (select == 5)
			//Break the loop
			break;
		else
			cout << "Not available. Please enter number 1 to 5." << endl;

		continue;

	} while (cont == 1);
	//--------------------- End of Member 2 or Member 3 --------------------------------
	return 0;
}

//Function menu --> To display the selection for the system
void menu() {
	cout << "1. Display Item List" << endl;
	cout << "2. Add Item List" << endl;
	cout << "3. Perform Transaction" << endl;
	cout << "4. Display Transaction History" << endl;
	cout << "5. Logout" << endl;
}



//--------------------- Start of Member 2 --------------------------------

//11. Function readItemList --> read (ifstream) all the items listed in "XX_itemList.txt"  
void readItemList(string itemNames[], string itemCodes[], double itemPrices[], double purchaseWeights[], int itemNum[], int& totalItems)
{
	ifstream itemRfile;
	itemRfile.open(currentUser + "_itemList.txt"); // open file for reading item list

	if (itemRfile.fail()) {
		cout << "\a";
		cout << "File not found !!" << endl;

		return; // exit function if file open fail
	}

	else {
		//read item details from file until the end or array size limit (100) 
		while (getline(itemRfile, itemNames[totalItems]) && totalItems < SIZE)
		{

			getline(itemRfile, itemCodes[totalItems]);

			itemRfile >> itemPrices[totalItems] >> purchaseWeights[totalItems];

			itemNum[totalItems] = totalItems + 1;

			totalItems++;

			itemRfile.ignore(); // ignore newline

		}
	}
	itemRfile.close(); // close file

}
// 12. Function addItemList --> add new items into the existing list 
void addItemList(string itemNames[], string itemCodes[], double itemPrices[], double purchaseWeights[], int itemNum[], int& totalItems)
{
	int addNew = 1;

	ofstream itemAfile;
	itemAfile.open(currentUser + "_itemList.txt", ios::app); // open file for appending item data

	if (itemAfile.fail()) { // file cannot open
		cout << "\a";
		cout << "File not found !!" << endl; // exit function if file open fail

		return;
	}

	else {
		//allow user to add new items until they choose to stop
		do {

			if (addNew == 1) {

				cout << "Add new item? ( 1-YES, 2-NO ): ";
				cin >> addNew;
				cin.ignore();
				// prompt user to input details for a new item
				int j = totalItems, k = 0;
				while (addNew == 1) {
					//increment item count and prompt for adding another item
					system("cls");

					cout << "\033[36m *****************************************\033[0m" << endl; // design and decoration 
					cout << "\033[36m------------------(p>w<q)------------------\033[0m" << endl; // design and decoration
					cout << "\033[36m-------------------------------------------\033[0m" << endl; // design and decoration
					cout << "\033[36m|                ITEM " << ++k << "                   |\033[0m" << endl; // design and decoration
					cout << "\033[36m-------------------------------------------\033[0m" << endl; // design and decoration

					cout << "New item's name:";
					getline(cin, itemNames[j]);

					cout << "New item's code: ";
					getline(cin, itemCodes[j]);

					cout << "Price of new item per KG (RM): ";
					cin >> itemPrices[j];

					cout << "Purchasing Weight (KG): ";
					cin >> purchaseWeights[j];

					cin.ignore();

					itemAfile << itemNames[j] << "\n";
					itemAfile << itemCodes[j] << "\n";
					itemAfile << fixed << setprecision(2) << itemPrices[j] << " " << purchaseWeights[j] << "\n";

					j++;

					cout << endl << "Add new item? ( 1-YES, 2-NO ): ";
					cin >> addNew;
					cin.ignore();

				}
			}

			else if (addNew == 2) {

				break; //exit loop if user choose not to add item
			}

			else {
				cout << "\a";
				cout << "Not Available !!" << endl;
				continue;
			}

			itemAfile.close(); // close file

		} while (addNew != 1);
	}
}

//13. Function displayItemList --> display the details of all the items in the list
void displayItemList(string itemNames[], string itemCodes[], double itemPrices[], double purchaseWeights[], int itemNum[], int totalItems)
{
	char firstCh;

	ifstream itemRfile;
	itemRfile.open(currentUser + "_itemList.txt");

	if (itemRfile.get(firstCh)) {
		//display the list of items if file is not empty
		cout << "\033[35m-----------------------------\033[0m" << endl; // design and decoration
		cout << "\033[35m        (.__________/)             \033[0m" << endl; // design and decoration
		cout << "\033[35m        ( // ^ w ^// )             \033[0m" << endl; // design and decoration
		cout << "\033[35m         > Item List <             \033[0m" << endl; // design and decoration
		cout << "\033[35m-----------------------------\033[0m" << endl; // design and decoration

		int k = 0;
		while (k < totalItems) {
			// display detail for each item
			cout << "\033[33m-----------------------------------\033[0m" << endl; // design and decoration
			cout << "\033[33m|             Item " << itemNum[k] << "              |\033[0m" << endl; // design and decoration
			cout << "\033[33m-----------------------------------\033[0m" << endl; // design and decoration
			cout << "Name: " << itemNames[k] << endl;
			cout << "Code: " << itemCodes[k] << endl;
			cout << fixed << showpoint << setprecision(2);
			cout << "Price per KG: RM" << itemPrices[k] << endl;
			cout << "Purchasing Weight: " << purchaseWeights[k] << "KG" << endl << endl;

			k++;
		}
	}

	else {
		cout << "\a";
		cout << "No item added yet !!" << endl;
	}

	itemRfile.close(); // close file
}

//14. Function readTransaction --> read (ifstream) all the items listed in "XX_transaction.txt" 
void readTransaction(double& totalAmount, string date[], double amount[], int& num)
{
	ifstream transinfile;
	ofstream transoutfile;
	num = 0; //initialize number 0
	string transfilename = currentUser + "_transaction.txt"; //define and create filename
	transinfile.open(transfilename); // open file
	if (transinfile.fail()) //if the file doesn't exist and unable to open
	{
		transoutfile.open(transfilename); //create a new file
		cout << "No Transaction yet!!" << endl;
		transoutfile.close(); //close file
	}
	else if (transinfile.is_open())//if exist and able to open
	{
		transinfile >> totalAmount; //read in transaction total amount
		while (transinfile >> date[num] >> amount[num]) //whenever transactio date and amount read in successfully and store in array index
		{
			num++; //increase transaction number by 1
		}

		transinfile.close();//close the file
	}
}

//15. Function transaction --> allow user to perform transaction with an amount and update in "XX_transaction.txt" 
void transaction(double& totalAmount, string date[], double amount[], int& num)
{
	int choice;
	readTransaction(totalAmount, date, amount, num); //call function and initialize totalAmount and number as totalaAmount and number in this function are reference parameter
	do
	{


		system("cls"); //clear screen
		cout << "..........................................." << endl;
		cout << "||      " << "* ++ ADD TRANSACTION ++ * " << "       || " << endl;
		cout << "..........................................." << endl;
		cout << endl;

		cout << ".............................................." << endl;
		cout << fixed << setprecision(2); //fixed to 2 decimal
		cout << "||    " << "* Available Balance: RM " << totalAmount << " *      ||" << endl; //dispaly total amount
		cout << ".............................................." << endl;
		cout << endl << endl;

		cout << "Amount of transaction : RM ";
		cin >> amount[num]; //read in and store amount in amount array index [number]
		cout << "Date of Transaction (dd/mm/yyy): ";
		cin >> date[num]; //read inand store date in a date array index [number]
		totalAmount += amount[num]; //transaction total amount = transaction total amount + new transaction amount
		num++; //increase transacyion number by 1
		cout << "The transaction has be recorded !" << endl;
		cout << endl;
		cout << "---------------------------------------------------" << endl;

		cout << "Do you want to Continue? (1-yes, 2-no and exit): ";
		cin >> choice;


	} while (choice == 1);



	string transfilename = currentUser + "_transaction.txt"; //define the transaction file name
	ofstream transoutfile(transfilename); //open file, clear old content and write out new content
	if (transoutfile.is_open()) //if file is exist and open
	{
		{
			transoutfile << totalAmount << endl; //write out and save updated tansaction total amount to text file
			for (int i = 0; i < num; i++) //initialize i 0; if i < transaction number, execute the loop until i greater or equal to number
			{
				transoutfile << date[i] << " " << amount[i] << endl; //save new and old tansaction date and transaction amount to text file
			}
			transoutfile.close(); //close file
		}
	}
	else
	{
		cout << "File of transaction is not implemented" << endl; //Cout "transaction() is not implemented" if the function is not implemented
	}
}


//16. Function displayTransactionDetails --> Display the available balance and also the history of related 
void displayTransactionDetails(double totalAmount, string date[], double amount[], int num)
{
	system("cls");
	readTransaction(totalAmount, date, amount, num); //call readTransaction function and initialize totalAmount and number as totalAmount and number in this function are reference parameter
	cout << "............................................" << endl;
	cout << "||    " << "* ++ TRANSACTION DETAILS ++ * " << "      || " << endl;
	cout << "............................................" << endl;
	cout << endl;

	cout << ".............................................." << endl;
	cout << fixed << setprecision(2); //fixed to 2 decimal
	cout << "||    " << "* Available Balance: RM " << totalAmount << " *      ||" << endl;
	cout << ".............................................." << endl;
	cout << endl << endl;
	for (int i = 0; i < num; i++) //initialize i 0; if i < transaction number, execute the loop until i greater or equal to number
	{
		cout << "--------------------------------------------" << endl;
		cout << "|  " << "Transaction " << i + 1 << "                           |" << endl;
		cout << "|  " << "Date: " << date[i] << "                        |" << endl; //cout date stored at date array index i 
		if (amount[i] >= 0) //if transaction amount greater than 0
		{
			cout << "   " << "Top Up Amount: RM " << amount[i] << endl; //execute this statement,  amount stored at amount array index i & decoration
		}
		else if (amount[i] < 0) //if transaction amount
			cout << "   " << "Spent Amount: RM " << amount[i] << endl; //execute this statement, amount stored at amount array index i  & decoration
		cout << endl;
		cout << "--------------------------------------------" << endl;
		cout << endl;
	}
	cout << " Press enter to exit the tansaction detials :) !!!" << endl;
}