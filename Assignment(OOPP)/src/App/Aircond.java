package App;
public class Aircond extends Product {
	private int coolingCapacity, fanSpeedLevel;
	private String color;

	public Aircond(int itemNumber, String name, int quantity, double price, int coolingCapacity, int fanSpeedLevel,
			String color) {
		super(itemNumber, name, quantity, price);
		this.coolingCapacity = coolingCapacity;
		this.fanSpeedLevel = fanSpeedLevel;
		this.color = color;
	}

	public int getCoolingCapacity() {
		return coolingCapacity;
	}

	public void setCoolingCapacity(int coolingCapacity) {
		this.coolingCapacity = coolingCapacity;
	}

	public int getFanSpeedLevel() {
		return fanSpeedLevel;
	}

	public void setFanSpeedLevel(int fanSpeedLevel) {
		this.fanSpeedLevel = fanSpeedLevel;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public double getAircondStockValue() {
		return getQuantityAvailable() * getPrice();
	}
	@Override
	public String toString() {
		return ("Item Number\t:" + getItemNumber() + "\nProduct name\t:" + getProductName() + "\nCooling Capacity\t:"
				+ getCoolingCapacity() + "\nColor\t:" + getColor() + "\nFan Speed Level :" + getFanSpeedLevel()
				+ "\nQuantity available:" + getQuantityAvailable() + "\nPrice \t: RM " + getPrice()
				+ "\nInventory value: RM " + getTotalInventoryValue() + "\nProduct status\t:" + getPStatus());
	}
}
