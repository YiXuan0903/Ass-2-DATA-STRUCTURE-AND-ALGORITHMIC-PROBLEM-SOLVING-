package App;
public class Refrigerator extends Product {
	private String doorDesign;
	private String color;
	private int capacity; // InLitres

	public Refrigerator(int itemNumber, String name, int quantity, double price, String doorDesign, String color,
			int capacity) {
		super(itemNumber, name, quantity, price);
		this.doorDesign = doorDesign;
		this.color = color;
		this.capacity = capacity;
	}

	public String getDoorDesign() {
		return doorDesign;
	}

	public void setDoorDesign(String doorDesign) {
		this.doorDesign = doorDesign;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public int getCapacity() {
		return capacity;
	}

	public void setCapacity(int capacity) {
		this.capacity = capacity;
	}

	// Method calculate the stock of refrigerator
	public double getRefrigeratorStockValue() {
		return getQuantityAvailable() * getPrice();
	}

	@Override
	public String toString() {

		return ("Item Number\t:" + getItemNumber() + "\nProduct name\t:" + getProductName() + "\nDoor design\t:"
				+ getDoorDesign() + "\nColor\t:" + getColor() + "\nCapacity (in Litres) :" + getCapacity()
				+ "\nQuantity available:" + getQuantityAvailable() + "\nPrice \t: RM " + getPrice()
				+ "\nInventory value: RM " + getTotalInventoryValue() + "\nProduct status\t:" + getPStatus());
	}
}