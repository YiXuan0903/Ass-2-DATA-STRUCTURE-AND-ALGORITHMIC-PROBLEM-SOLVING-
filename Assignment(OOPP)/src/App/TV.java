package App;
public class TV extends Product {
	// Additional instance variables for TV
	private String screenType;
	private String resolution;
	private double displaySize;

	// Parameterized constructor for TV
	public TV(int itemNumber, String productName, int quantityAvailable, double price, String screenType,
			String resolution, double displaySize) {
		super(itemNumber, productName, quantityAvailable, price);
		this.screenType = screenType;
		this.resolution = resolution;
		this.displaySize = displaySize;
	}

	// Getter and setter methods for additional instance variables
	public String getScreenType() {
		return screenType;
	}

	public void setScreenType(String screenType) {
		this.screenType = screenType;
	}

	public String getResolution() {
		return resolution;
	}

	public void setResolution(String resolution) {
		this.resolution = resolution;
	}

	public double getDisplaySize() {
		return displaySize;
	}

	public void setDisplaySize(double displaySize) {
		this.displaySize = displaySize;
	}

	// Method to calculate the value of the TV stock
	public double getTVStockValue() {
		return getPrice() * getQuantityAvailable();
	}

	// Override toString() method to return TV information
	@Override
	public String toString() {

		return ("Item number: " + getItemNumber() + "\n" + "Product name: " + getProductName() + "\n" + "Screen type: "
				+ getScreenType() + "\n" + "Resolution: " + getResolution() + "\n" + "Display size: " + getDisplaySize()
				+ "\n" + "Quantity available: " + getQuantityAvailable() + "\n" + "Price \t: RM " + getPrice() + "\n"
				+ "Inventory value : RM " + getTotalInventoryValue() + "\n" + "Product status: " + getPStatus());
	}
}