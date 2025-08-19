package App;

import java.util.Scanner;

public class UserInfo {
    private String name;
    private String userId;


    public UserInfo() {
        this.userId = "Guest";
    }


    public UserInfo(String name) {
        setName(name);
    }

    public String getName() {
        return name;
    }
    public String getUserId() {
        return userId;
    }


    public void setName(String name) {
        this.name = name;
        this.userId = generateUserId(name);
    }


    private boolean isValidName(String name) {
        return name.trim().contains(" ");
    }


    public String generateUserId(String name) {
        if (isValidName(name)) {
            String[] parts = name.trim().split("\\s+");
            String firstInitial = parts[0].substring(0, 1).toUpperCase();
            String lastName = parts[parts.length - 1];
            String capLast = lastName.substring(0, 1).toUpperCase()
                           + lastName.substring(1).toLowerCase();
            return firstInitial + capLast;
        } else {
            return "Guest";
        }
    }


    public static UserInfo createUser() {
        try (Scanner input = new Scanner(System.in)) {
            UserInfo user = null;
            while (user == null) {
                System.out.print("Enter your full name: ");
                String fullName = input.nextLine().trim();
                if (fullName.contains(" ")) {
                    user = new UserInfo(fullName);
                    System.out.println("Your user ID is: " + user.getUserId());
                } else {
                    user = new UserInfo();  // ID 默认为 "Guest"
                    System.out.println("Invalid format. Setting your ID as Guest");
                }
            }
            return user;
        }
    }
}
