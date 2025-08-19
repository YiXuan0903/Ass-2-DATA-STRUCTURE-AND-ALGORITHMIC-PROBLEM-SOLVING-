package App;
public abstract class Product {
	// Data fields
	private int itemNumber;
	private String productName;
	private int quantityAvailable;
	private double price;
	private boolean productStatus = true;
	private static int index = 0;

	// Default constructor
	public Product() {
		// Default values
		this.itemNumber = 0;
		this.productName = "";
		this.quantityAvailable = 0;
		this.price = 0.0;
	}

	// Parameterized constructor
	public Product(int itemNumber, String productName, int quantityAvailable, double price) {
		this.itemNumber = itemNumber;
		this.productName = productName;
		this.quantityAvailable = quantityAvailable;
		this.price = price;
	}

	// Getter and setter methods for each data field
	public int getItemNumber() {
		return itemNumber;
	}

	public void setItemNumber(int itemNumber) {
		this.itemNumber = itemNumber;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public int getQuantityAvailable() {
		return quantityAvailable;
	}

	public void setQuantityAvailable(int quantityAvailable) {
		this.quantityAvailable = quantityAvailable;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public boolean getProductStatus() {
		return productStatus;
	}

	public void setProductStatus(boolean productStatus) {
		this.productStatus = productStatus;
	}

	public String getPStatus() {
		if (getProductStatus()) {
			return "Active";
		} else {
			return "Discontinued";
		}
	}

	// Method to calculate the total inventory value
	public double getTotalInventoryValue() {
		return price * quantityAvailable;
	}

	// Method to add quantity to stock
	public void addQuantity(int quantity) {
		if (productStatus) {
			quantityAvailable += quantity;
			System.out.println();
			System.out.println("[Quantity added successfully]");
			System.out.println();
		} else {
			System.out.println("Cannot add quantity to a discontinued product line.");
		}
	}

	// Method to deduct quantity from stock
	public void deductQuantity(int quantity) {
		if (productStatus) {
			if (quantityAvailable >= quantity) {
				quantityAvailable -= quantity;
				System.out.println();
				System.out.println("[Quantity deducted successfully]");
				System.out.println();
			} else {
				System.out.println("Insufficient quantity available.");
			}
		} else {
			System.out.println("Cannot deduct quantity from a discontinued product line.");
		}
	}

	public static int getIndex() {
		return index;
	}

	public static void addIndex() {
		index++;
	}

	// Override method
	@Override
	public String toString() {
		String productStatusString;
		if (getProductStatus()) {
			productStatusString = "Active";
		} else {
			productStatusString = "Discontinued";
		}

		return "Item number: " + getItemNumber() + "\n" + "Product name: " + getProductName() + "\n"
				+ "Quantity available: " + getQuantityAvailable() + "\n" + "Price (RM): " + getPrice() + "\n"
				+ "Inventory value (RM): " + getTotalInventoryValue() + "\n" + "Product status: " + productStatusString;
	}
}