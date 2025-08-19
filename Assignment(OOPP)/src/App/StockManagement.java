package App;
import java.util.Scanner;

public class StockManagement {
	private static Scanner input = new Scanner(System.in);

	// 1
	public static int getMaxProduct(Scanner scanner) {
		int maxNum = 0;
		boolean check = false;

		while (!check) {
			System.out.println();
			System.out.print("How many products that you wish to add:");
			try {
				maxNum = scanner.nextInt();
				if (maxNum <= 0) {
					System.out.println();
					System.out.println("[The value MUST be positive or greater than 0, Please try again!]");
				} else {
					check = true;
				}
			} catch (Exception e) {
				System.out.println();
				System.out.println("[Your Input MUST be a NUMBER, Please try again!]");
				scanner.next();
			}
		}
		return maxNum;
	}

	// 2
	public static int displayandgetChoice(Product[] products, Scanner scanner) {
		int option = 0;
		if (products.length == 0) {
			System.out.println("The list is empty, Please add the Products First");
		} else {
			for (int i = 0; i < products.length; i++) {
				System.out.println("--------Product " + (i + 1) + "--------");
				System.out.println("Product's Index Number: [" + i + "]");
				System.out.println("Product's Name: " + products[i].getProductName());
				System.out.println("Product's Stock: " + products[i].getQuantityAvailable());
				System.out.println("Product's Status: " + products[i].getPStatus());
				System.out.println();
			}
			System.out.println("-------------------------");

		}
		do {
			try {
				System.out.print("Enter a index number for your selected product: ");
				option = scanner.nextInt();
				scanner.nextLine();
				if (option >= products.length || option < 0) {
					System.out.println("Please type the proper index!!!");
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println("[Your Input MUST be a NUMBER, Please try again!]");
				scanner.nextLine();
			}

		} while (true);

		return option;
	}

	// 3
	public static int displayMenu(Scanner scanner) {
		int option = 0;
		do {
			try {
				System.out.println("------------------");
				System.out.println("-------Menu-------");
				System.out.println("------------------");
				System.out.println("1. View products");
				System.out.println("2. Add stock");
				System.out.println("3. Deduct stock");
				System.out.println("4. Discontinue product");
				System.out.println("0. Exit");
				System.out.print("Please enter a menu option:");
				option = scanner.nextInt();
				scanner.nextLine();
				if (option < 0 || option > 4) {
					System.out.println("Invalid Input, Please try Again");
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println();
				System.out.println("[Your Input MUST be a NUMBER, Please try again!]");
				scanner.nextLine();
			}

		} while (true);
		return option;
	}

	// 4
	public static void addStock(Product[] product, Scanner scanner) {
		int amount = 0;
		int selection = displayandgetChoice(product, scanner);

		do {
			try {
				System.out.print("How many stock you want to add:");
				amount = scanner.nextInt();
				scanner.nextLine();
				if (amount <= 0) {
					System.out.println("Your input MUST be positive and greater than 0, Please try again!");
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println("Your Input MUST be a NUMBER, Please try again!");
				scanner.nextLine();
			}
		} while (true);

		product[selection].addQuantity(amount);
	}

	// 5
	public static void deductStock(Product[] product, Scanner scanner) {
		int selection = displayandgetChoice(product, scanner);
		int amount = 0;
		do {
			try {
				System.out.print("How many stock you want to deduct:");
				amount = scanner.nextInt();
				scanner.nextLine();
				if (amount < 0 || amount > product[selection].getQuantityAvailable()) {
					System.out.println(
							"Your input MUST be positive and CANNOT exceed the quantity available of the stock, Please try again!");
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println("Your Input MUST be a NUMBER, Please try again!");
				scanner.nextLine();
			}

		} while (true);
		product[selection].deductQuantity(amount);
	}

	// 6
	public static void setPdStatus(Product[] product, Scanner scanner) {
		int selection = displayandgetChoice(product, scanner);
		if (product[selection].getProductStatus() == false) {
			System.out.println("Error Ocuured, Cannot change the Product Status");
		} else {
			product[selection].setProductStatus(false);
			System.out.println();
			System.out.println("[Status set Successfully]");
			System.out.println();
		}
	}

	// 7
	public static void executeMethods(int choice, Product[] product, Scanner scanner) {

		switch (choice) {
		case 1:
			displayProduct(product);
			break;

		case 2:
			addStock(product, scanner);
			break;

		case 3:
			deductStock(product, scanner);
			break;

		case 4:
			setPdStatus(product, scanner);
			break;

		case 0:
			System.out.println("Exiting the program...\nPlease Wait");
			break;
		default:
			System.out.println("Invalid Input, Please try again!");
			break;
		}
	}

	// 8
	public static void addProduct(Product[] products, Scanner scanner) {
		boolean check = false;
		int option = 0;
		do {
			try {
				System.out.println();
				System.out.println("-----Which type of product that you wish to add?-----");
				System.out.println("1. Refrigerator");
				System.out.println("2. TV");
				System.out.println("3. Aircond");
				System.out.print("Your Selection: ");
				option = scanner.nextInt();
				if (option < 1 || option > 3) {
					System.out.println();
					System.out.println("Only number 1, 2, 3 allowed!");
				} else {
					if (option == 1) {
						// Refrigerator
						addRefrigerator(products, scanner);
						System.out.println("[Refrigerator addded successfully]");
						System.out.println();

					} else if (option == 2) {
						// TV
						addTV(products, scanner);
						System.out.println("[TV added successfully]");
						System.out.println();
					} else if (option == 3) {
						addAircond(products, scanner);
						System.out.println("[Aircond added successfully]");
						System.out.println();
					}
					check = true;
				}
			} catch (Exception e) {
				System.out.println();
				System.out.println("Your Input MUST be a INTEGER.");
				scanner.next();
			}

		} while (!check);
	}

	// 9
	public static void addRefrigerator(Product[] products, Scanner scanner) {
		int itemNumber = 0, quantity = 0, capacity = 0;
		double price = 0.0;
		String name = "", doorDesign = "", color = "";

		do {
			try {
				System.out.print("Enter the Item Number (Maximum 7 digits):");
				itemNumber = scanner.nextInt();
				scanner.nextLine();
				if (itemNumber < 0 || itemNumber > 9999999) {
					System.out.println("Maximum 7 digits, Please try again!");
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println("Your input MUST be an INTEGER, Please try again");
				scanner.nextLine();
			}
		} while (true);

		System.out.print("Enter the Product's Name:");
		name = scanner.nextLine();

		do {
			try {
				System.out.print("Enter the quantity available of the product:");
				quantity = scanner.nextInt();
				scanner.nextLine();
				if (quantity < 0) {
					System.out.println();
					System.out.println("Your input MUST be POSITIVE, Please try again");
					System.out.println();
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println();
				System.out.println("Your input MUST be an integer, Please try again");
				System.out.println();
				scanner.nextLine();
			}

		} while (true);

		do {
			try {
				System.out.print("Enter the price of the product:");
				price = scanner.nextDouble();
				scanner.nextLine();
				if (price < 0.0) {
					System.out.println();
					System.out.println("Your input MUST be POSITIVE, Please try again");
					System.out.println();
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println();
				System.out.println("Your input MUST be an NUMBER, Please try again");
				System.out.println();
				scanner.nextLine();
			}
		} while (true);

		System.out.print("Enter the product's door design:");
		doorDesign = scanner.nextLine();

		System.out.print("Enter the product's color:");
		color = scanner.nextLine();

		do {
			try {
				System.out.print("Enter the product's capacity:");
				capacity = scanner.nextInt();
				scanner.nextLine();
				if (capacity < 0) {
					System.out.println();
					System.out.println("Your input MUST be POSITIVE, Please try again");
					System.out.println();
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println();
				System.out.println("Your input MUST be an NUMBER, Please try again");
				System.out.println();
				scanner.nextLine();
			}

		} while (true);
		System.out.println();
		products[Product.getIndex()] = new Refrigerator(itemNumber, name, quantity, price, doorDesign, color, capacity);
		Product.addIndex();
	}

	// 10
	public static void addTV(Product[] products, Scanner scanner) {
		int itemNumber = 0, quantity = 0;
		double price = 0.0, displaySize = 0.0;
		String name = "", screenType = "", resolution = "";

		do {
			try {
				System.out.print("Enter the Item Number (Maximum 7 digits):");
				itemNumber = scanner.nextInt();
				scanner.nextLine();
				if (itemNumber < 0 || itemNumber > 9999999) {
					System.out.println("Maximum 7 digits, Please try again!");
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println("Your input MUST be an INTEGER, Please try again");
				scanner.nextLine();
			}
		} while (true);

		System.out.print("Enter the Product's Name:");
		name = scanner.nextLine();

		do {
			try {
				System.out.print("Enter the quantity available of the product:");
				quantity = scanner.nextInt();
				scanner.nextLine();
				if (quantity < 0) {
					System.out.println();
					System.out.println("Your input MUST be POSITIVE, Please try again");
					System.out.println();
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println();
				System.out.println("Your input MUST be an integer, Please try again");
				System.out.println();
				scanner.nextLine();
			}

		} while (true);

		do {
			try {
				System.out.print("Enter the price of the product:");
				price = scanner.nextDouble();
				scanner.nextLine();
				if (price < 0.0) {
					System.out.println();
					System.out.println("Your input MUST be POSITIVE, Please try again");
					System.out.println();
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println();
				System.out.println("Your input MUST be an NUMBER, Please try again");
				System.out.println();
				scanner.nextLine();
			}
		} while (true);

		System.out.print("Enter the product's screen type:");
		screenType = scanner.nextLine();

		System.out.print("Enter the product's resolution:");
		resolution = scanner.nextLine();

		do {
			try {
				System.out.print("Enter the product's display size (inches):");
				displaySize = scanner.nextDouble();
				scanner.nextLine();
				if (displaySize < 0.0) {
					System.out.println("Your input MUST be POSITIVE, Please try again");
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println("Your input MUST be an NUMBER, Please try again");
				scanner.nextLine();
			}
		} while (true);
		System.out.println();
		products[Product.getIndex()] = new TV(itemNumber, name, quantity, price, screenType, resolution, displaySize);
		Product.addIndex();

	}

	// 11
	public static void displayProduct(Product[] products) {
		if (products.length == 0) {
			System.out.println("The list is empty, Please add the Products First");
		} else {
			for (int i = 0; i < products.length; i++) {
				System.out.println();
				System.out.println("--------Product " + (i + 1) + "--------");
				System.out.println(products[i].toString());
				System.out.println();
			}
		}
	}

	public static void main(String[] args) {
		int option = 0, amount = 0, select = 0;
		boolean check = false;
		System.out.println("--------------------");
		System.out.println("/Welcome to the SMS/");
		System.out.println("--------------------");
		System.out.print("Please enter your full name: ");
		String inputName = input.nextLine();
		UserInfo user1 = new UserInfo(inputName);
		System.out.println();
		
		do {
			try {
				System.out.print("Do you want to add product? (1-Yes, 0-No):");
				option = input.nextInt();
				if (option == 1 || option == 0) {
					check = true;
				} else {
					System.out.println("-----------------------------");
					System.out.println("Your Input MUST be 1 or 0 !!!");
					System.out.println("-----------------------------");
				}

			} catch (Exception e) {
				System.out.println("------------------------------------------------");
				System.out.println("[Your Input MUST be a NUMBER, Please try again!]");
				System.out.println("User ID: " + user1.generateUserId(inputName));
				System.out.println("Full Name: " + user1.getName());
				System.out.println("------------------------------------------------");
				input.nextLine();
			}

		} while (!check);

		if (option == 0) {
			System.out.println("------------------------");
			System.out.println("Exiting the program.....\nPlease Wait");
			System.out.println("User ID: " + user1.generateUserId(inputName));
			System.out.println("Full Name: " + user1.getName());
			System.out.println("------------------------");
			System.exit(0);
			input.close();
		}
		amount = getMaxProduct(input);
		Product[] products = new Product[amount];
		if (option == 1) {

			for (int i = 0; i < amount; i++) {
				addProduct(products, input);
			}
		}

		do {
			select = displayMenu(input);
			executeMethods(select, products, input);

		} while (select != 0);
		System.out.println("User ID: " + user1.generateUserId(inputName));
		System.out.println("Full Name: " + user1.getName());
		System.exit(0);

	}

	public static void addAircond(Product[] products, Scanner scanner) {
		int itemNumber = 0, quantity = 0, coolingCapacity = 0, fanSpeedLevel = 0;
		double price = 0.0;
		String name = "", color = "";

		do {
			try {
				System.out.print("Enter the Item Number (Maximum 7 digits):");
				itemNumber = scanner.nextInt();
				scanner.nextLine();
				if (itemNumber < 0 || itemNumber > 9999999) {
					System.out.println("Maximum 7 digits, Please try again!");
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println("Your input MUST be an INTEGER, Please try again");
				scanner.nextLine();
			}
		} while (true);

		System.out.print("Enter the Product's Name:");
		name = scanner.nextLine();

		do {
			try {
				System.out.print("Enter the quantity available of the product:");
				quantity = scanner.nextInt();
				scanner.nextLine();
				if (quantity < 0) {
					System.out.println();
					System.out.println("Your input MUST be POSITIVE, Please try again");
					System.out.println();
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println();
				System.out.println("Your input MUST be an integer, Please try again");
				System.out.println();
				scanner.nextLine();
			}

		} while (true);

		do {
			try {
				System.out.print("Enter the price of the product:");
				price = scanner.nextDouble();
				scanner.nextLine();
				if (price < 0.0) {
					System.out.println();
					System.out.println("Your input MUST be POSITIVE, Please try again");
					System.out.println();
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println();
				System.out.println("Your input MUST be an NUMBER, Please try again");
				System.out.println();
				scanner.nextLine();
			}
		} while (true);

		do {
			try {
				System.out.print("Enter the product's cooling capacity:");
				coolingCapacity = scanner.nextInt();
				scanner.nextLine();
				if (coolingCapacity < 0) {
					System.out.println();
					System.out.println("Your input MUST be POSITIVE, Please try again");
					System.out.println();
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println();
				System.out.println("Your input MUST be an NUMBER, Please try again");
				System.out.println();
				scanner.nextLine();
			}
		} while (true);

		do {
			try {
				System.out.print("Enter the product's fan speed level:");
				fanSpeedLevel = scanner.nextInt();
				scanner.nextLine();
				if (fanSpeedLevel < 0) {
					System.out.println();
					System.out.println("Your input MUST be POSITIVE, Please try again");
					System.out.println();
					continue;
				}
				break;
			} catch (Exception e) {
				System.out.println();
				System.out.println("Your input MUST be an NUMBER, Please try again");
				System.out.println();
				scanner.nextLine();
			}
		} while (true);

		System.out.print("Enter the product's color:");
		color = scanner.nextLine();

		System.out.println();
		products[Product.getIndex()] = new Aircond(itemNumber, name, quantity, price, coolingCapacity, fanSpeedLevel,
				color);
		Product.addIndex();
	}
}
