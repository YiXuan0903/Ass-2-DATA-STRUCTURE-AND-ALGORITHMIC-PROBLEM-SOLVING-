package App;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.scene.text.Font;
import javafx.stage.Stage;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.function.Function;

public class MainUI extends Application {

    private final List<Product> products = new ArrayList<>();
    private final Label userInfoLabel = new Label("User: Guest | ID: Guest");

    private void loadProductsFromCSV() {
        File file = new File("products.csv");
        if (!file.exists()) return;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            br.readLine();
            String line;
            while ((line = br.readLine()) != null) {
                if (line.isBlank()) continue;
                String[] p = line.split(",", -1);
                if (p.length < 9) continue;

                String type    = p[0];
                int    itemNum = Integer.parseInt(p[1]);
                String name    = p[2];
                int    qty     = Integer.parseInt(p[3]);
                double price   = Double.parseDouble(p[4]);
                boolean active = "Active".equalsIgnoreCase(p[5]);
                String e1 = p[6], e2 = p[7], e3 = p[8];

                Product prod;
                if ("Refrigerator".equalsIgnoreCase(type)) {
                    double capD = Double.parseDouble(e3);
                    int capacity = (int) Math.round(capD);
                    prod = new Refrigerator(itemNum, name, qty, price, e1, e2, capacity);

                } else if ("TV".equalsIgnoreCase(type)) {
                    double displaySize = Double.parseDouble(e3);
                    prod = new TV(itemNum, name, qty, price, e1, e2, displaySize);

                } else if ("Aircond".equalsIgnoreCase(type)) {
                    int coolingCap    = Integer.parseInt(e1);
                    int fanSpeedLevel = Integer.parseInt(e2);
                    String color      = e3;
                    prod = new Aircond(itemNum, name, qty, price, coolingCap, fanSpeedLevel, color);

                } else {
                    continue;
                }

                prod.setProductStatus(active);
                if (prod.getQuantityAvailable() == 0) {
                    prod.setProductStatus(false);
                }
                products.add(prod);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    @Override
    public void start(Stage stage) {
 
        loadProductsFromCSV();
    	
        TextInputDialog login = new TextInputDialog();
        login.setTitle("User Login");
        login.setHeaderText("Welcome to SMS");
        login.setContentText("Please enter your full name:");
        String[] nameHolder = {"Guest"}, idHolder = {"Guest"};
        login.showAndWait().ifPresent(s -> {
            String t = s.trim();
            nameHolder[0] = t.isEmpty() ? "Guest" : t;
            if (t.contains(" ")) {
                String[] parts = t.split(" ");
                String init = parts[0].substring(0,1).toUpperCase();
                String last = parts[parts.length-1];
                idHolder[0] = init + last.substring(0,1).toUpperCase() + last.substring(1);
            }
        });

        String loginTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        userInfoLabel.setText("User: " + nameHolder[0] + " | ID: " + idHolder[0] +
                              " | Login at: " + loginTime);

        stage.setTitle("Stock Management System");


        String ts = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        Label header = new Label("Welcome to the SMS | " + ts);
        header.setFont(new Font(20));
        Label members = new Label("Group Members: Lim Boon Chong 1903229, Tan Yi Xuan 2204266, Chee Jin Nan 2207296, Thau Zhe Jun 2206252");
        members.setFont(new Font(14));
        VBox topBox = new VBox(5, header, members);
        topBox.setAlignment(Pos.CENTER);
        topBox.setPadding(new Insets(10));


        Label menuText = new Label(
            "1. View products\n" +
            "2. Add stock\n" +
            "3. Deduct stock\n" +
            "4. Discontinue product\n" +
            "0. Exit\n" +
            "Please enter a menu option:"
        );
        TextField menuInput = new TextField();
        Button submit = new Button("Submit");
        submit.setDefaultButton(true);
        Label resultLabel = new Label();
        resultLabel.setWrapText(true);
        ScrollPane scroll = new ScrollPane(resultLabel);
        scroll.setFitToWidth(true);
        scroll.setPrefHeight(300);
        menuInput.setOnAction(e -> submit.fire());

        Function<String, String> askString = prompt -> {
            TextInputDialog d = new TextInputDialog();
            d.setTitle("Input Required");
            d.setHeaderText(prompt);
            Optional<String> r = d.showAndWait();
            return r.map(String::trim).filter(t -> !t.isEmpty()).orElse(null);
        };
        Function<String, Integer> askInt = prompt -> {
            while (true) {
                TextInputDialog d = new TextInputDialog();
                d.setTitle("Input Number");
                d.setHeaderText(prompt + " (integer > 0)");
                Optional<String> r = d.showAndWait();
                if (r.isEmpty()) return null;
                try {
                    int v = Integer.parseInt(r.get().trim());
                    if (v <= 0) {
                        new Alert(Alert.AlertType.WARNING, "Value must be > 0", ButtonType.OK).showAndWait();
                        continue;
                    }
                    return v;
                } catch (NumberFormatException ex) {
                    new Alert(Alert.AlertType.WARNING, "Invalid integer", ButtonType.OK).showAndWait();
                }
            }
        };
        Function<String, Double> askDouble = prompt -> {
            while (true) {
                TextInputDialog d = new TextInputDialog();
                d.setTitle("Input Number");
                d.setHeaderText(prompt + " (number > 0)");
                Optional<String> r = d.showAndWait();
                if (r.isEmpty()) return null;
                try {
                    double v = Double.parseDouble(r.get().trim());
                    if (v <= 0) {
                        new Alert(Alert.AlertType.WARNING, "Value must be > 0", ButtonType.OK).showAndWait();
                        continue;
                    }
                    return v;
                } catch (NumberFormatException ex) {
                    new Alert(Alert.AlertType.WARNING, "Invalid number", ButtonType.OK).showAndWait();
                }
            }
        };

        submit.setOnAction(ev -> {
            String c = menuInput.getText().trim();
            switch (c) {
            case "1":
                TextInputDialog sub = new TextInputDialog();
                sub.setTitle("View Products");
                sub.setHeaderText(
                    "1. View All\n" +
                    "2. Refrigerator\n" +
                    "3. TV\n" +
                    "4. Aircond"
                );
                sub.setContentText("Please enter 1, 2, 3 or 4:");
                Optional<String> subOpt = sub.showAndWait();
                if (subOpt.isPresent()) {
                    String choice = subOpt.get().trim();
                    String typeKey;
                    switch (choice) {
                        case "1": typeKey = "View All";      break;
                        case "2": typeKey = "Refrigerator";  break;
                        case "3": typeKey = "TV";            break;
                        case "4": typeKey = "Aircond";       break;
                        default:
                            resultLabel.setText("Invalid option. Please enter 1, 2, 3 or 4.");
                            return;
                    }

                    StringBuilder sb = new StringBuilder();
                    switch (typeKey) {
                        case "View All":
                            products.forEach(p -> sb.append(p).append("\n\n"));
                            break;
                        case "Refrigerator":
                            products.stream()
                                    .filter(p -> p instanceof Refrigerator)
                                    .forEach(p -> sb.append(p).append("\n\n"));
                            break;
                        case "TV":
                            products.stream()
                                    .filter(p -> p instanceof TV)
                                    .forEach(p -> sb.append(p).append("\n\n"));
                            break;
                        case "Aircond":
                            products.stream()
                                    .filter(p -> p instanceof Aircond)
                                    .forEach(p -> sb.append(p).append("\n\n"));
                            break;
                    }
                    resultLabel.setText(sb.length() == 0 ? "No matching products." : sb.toString());
                }
                break;


            case "2":
                // —— Add stock ——  
                Integer type = null;
                while (type == null) {
                    TextInputDialog d = new TextInputDialog();
                    d.setTitle("Add Stock");
                    d.setHeaderText("Add Stock >\n1. Refrigerator\n2. TV\n3. Aircond");
                    Optional<String> r = d.showAndWait();
                    if (r.isEmpty()) { resultLabel.setText("Cancelled."); return; }
                    try {
                        int v = Integer.parseInt(r.get().trim());
                        if (v == 1 || v == 2 || v == 3) type = v;
                    } catch (Exception ex) {}
                    if (type == null)
                        new Alert(Alert.AlertType.WARNING, "Only 1, 2 or 3 allowed!", ButtonType.OK).showAndWait();
                }

                Integer exist = null;
                while (exist == null) {
                    TextInputDialog d = new TextInputDialog();
                    d.setTitle("Add Stock");
                    d.setHeaderText("Is the product exist?\n1. Yes\n2. No");
                    Optional<String> r = d.showAndWait();
                    if (r.isEmpty()) { resultLabel.setText("Cancelled."); return; }
                    try {
                        int v = Integer.parseInt(r.get().trim());
                        if (v == 1 || v == 2) exist = v;
                    } catch (Exception ex) {}
                    if (exist == null)
                        new Alert(Alert.AlertType.WARNING, "Only 1 or 2 allowed!", ButtonType.OK).showAndWait();
                }

                if (exist == 1) {
                    List<String> names = new ArrayList<>();
                    for (Product p : products) {
                        if ((type == 1 && p instanceof Refrigerator) ||
                            (type == 2 && p instanceof TV) ||
                            (type == 3 && p instanceof Aircond)) {
                            names.add(p.getProductName());
                        }
                    }
                    if (names.isEmpty()) {
                        resultLabel.setText("No such products exist.");
                    } else {
                        ChoiceDialog<String> pd = new ChoiceDialog<>(names.get(0), names);
                        pd.setTitle("Select Product");
                        pd.setHeaderText("Choose product to add stock:");
                        pd.showAndWait().ifPresent(sel -> {
                            products.stream()
                                .filter(p -> p.getProductName().equals(sel))
                                .findFirst()
                                .ifPresent(p2 -> {
                                    Integer q = askInt.apply("Enter quantity to add:");
                                    if (q == null) {
                                        resultLabel.setText("Cancelled.");
                                    } else {
                                        p2.addQuantity(q);
                                        resultLabel.setText("Added " + q + " to " + sel);
                                    }
                                });
                        });
                    }
                } else {
                    // Add new product
                    if (type == 1) {
                        // Refrigerator
                        String name = askString.apply("Enter Refrigerator brand name:");
                        if (name == null) { resultLabel.setText("Cancelled."); return; }
                        String dd = askString.apply("Enter door design:");
                        if (dd == null) { resultLabel.setText("Cancelled."); return; }
                        String col = askString.apply("Enter color:");
                        if (col == null) { resultLabel.setText("Cancelled."); return; }
                        Integer cap = askInt.apply("Enter capacity (Litres):");
                        if (cap == null) { resultLabel.setText("Cancelled."); return; }
                        Integer qty = askInt.apply("Enter quantity available:");
                        if (qty == null) { resultLabel.setText("Cancelled."); return; }
                        Double pr = askDouble.apply("Enter price (RM):");
                        if (pr == null) { resultLabel.setText("Cancelled."); return; }
                        Integer id = askInt.apply("Enter item number:");
                        if (id == null) { resultLabel.setText("Cancelled."); return; }
                        products.add(new Refrigerator(id, name, qty, pr, dd, col, cap));
                        resultLabel.setText("Refrigerator " + name + " added.");

                    } else if (type == 2) {
                        // TV
                        String name = askString.apply("Enter TV brand name:");
                        if (name == null) { resultLabel.setText("Cancelled."); return; }
                        String st = askString.apply("Enter screen type:");
                        if (st == null) { resultLabel.setText("Cancelled."); return; }
                        String reso = askString.apply("Enter resolution:");
                        if (reso == null) { resultLabel.setText("Cancelled."); return; }
                        Double ds = askDouble.apply("Enter display size (inches):");
                        if (ds == null) { resultLabel.setText("Cancelled."); return; }
                        Integer qty = askInt.apply("Enter quantity available:");
                        if (qty == null) { resultLabel.setText("Cancelled."); return; }
                        Double pr = askDouble.apply("Enter price (RM):");
                        if (pr == null) { resultLabel.setText("Cancelled."); return; }
                        Integer id = askInt.apply("Enter item number:");
                        if (id == null) { resultLabel.setText("Cancelled."); return; }
                        products.add(new TV(id, name, qty, pr, st, reso, ds));
                        resultLabel.setText("TV " + name + " added.");

                    } else {
                        // Aircond
                        String name  = askString.apply("Enter Aircond model:");
                        if (name == null) { resultLabel.setText("Cancelled."); return; }
                        Integer cool = askInt.apply("Enter cooling capacity:");
                        if (cool == null) { resultLabel.setText("Cancelled."); return; }
                        Integer fan  = askInt.apply("Enter fan speed level:");
                        if (fan == null) { resultLabel.setText("Cancelled."); return; }
                        String color = askString.apply("Enter color:");
                        if (color == null) { resultLabel.setText("Cancelled."); return; }
                        Integer qty  = askInt.apply("Enter quantity available:");
                        if (qty == null) { resultLabel.setText("Cancelled."); return; }
                        Double pr    = askDouble.apply("Enter price (RM):");
                        if (pr == null) { resultLabel.setText("Cancelled."); return; }
                        Integer id   = askInt.apply("Enter item number:");
                        if (id == null) { resultLabel.setText("Cancelled."); return; }
                        products.add(new Aircond(id, name, qty, pr, cool, fan, color));
                        resultLabel.setText("Aircond " + name + " added.");
                    }
                }
                break;


            case "3":
                // ——— Deduct stock ———
                Integer dt = null;
                while (dt == null) {
                    TextInputDialog d = new TextInputDialog();
                    d.setTitle("Deduct Stock");
                    d.setHeaderText("Deduct Stock >\n1. Refrigerator\n2. TV\n3. Aircond");
                    Optional<String> r = d.showAndWait();
                    if (r.isEmpty()) { 
                        resultLabel.setText("Cancelled."); 
                        return; 
                    }
                    try {
                        int v = Integer.parseInt(r.get().trim());
                        if (v == 1 || v == 2 || v == 3) dt = v;
                    } catch (Exception ex) {}
                    if (dt == null)
                        new Alert(Alert.AlertType.WARNING, "Only 1, 2 or 3 allowed!", ButtonType.OK).showAndWait();
                }

                List<String> dn = new ArrayList<>();
                for (Product p : products) {
                    if ((dt == 1 && p instanceof Refrigerator) ||
                        (dt == 2 && p instanceof TV) ||
                        (dt == 3 && p instanceof Aircond)) {
                        dn.add(p.getProductName());
                    }
                }
                if (dn.isEmpty()) {
                    resultLabel.setText("No such products.");
                    break;
                }

                ChoiceDialog<String> dd3 = new ChoiceDialog<>(dn.get(0), dn);
                dd3.setTitle("Select Product");
                dd3.setHeaderText("Choose product to deduct:");
                dd3.showAndWait().ifPresent(sel -> {
                    products.stream()
                        .filter(p -> p.getProductName().equals(sel))
                        .findFirst()
                        .ifPresent(p2 -> {
                            Integer dq = askInt.apply("Enter quantity to deduct:");
                            if (dq == null) {
                                resultLabel.setText("Cancelled.");
                            } else if (dq > p2.getQuantityAvailable()) {
                                resultLabel.setText("Cannot exceed available stock.");
                            } else {
                                p2.deductQuantity(dq);
                                if (p2.getQuantityAvailable() == 0) {
                                    p2.setProductStatus(false);
                                }
                                resultLabel.setText("Deducted " + dq + " from " + sel);
                            }
                        });
                });
                break;


            case "4":
                // ——— Discontinue product ———
                Integer dt2 = null;
                while (dt2 == null) {
                    TextInputDialog d = new TextInputDialog();
                    d.setTitle("Discontinue Product");
                    d.setHeaderText("Discontinue >\n1. Refrigerator\n2. TV\n3. Aircond");
                    Optional<String> r = d.showAndWait();
                    if (r.isEmpty()) {
                        resultLabel.setText("Cancelled.");
                        return;
                    }
                    try {
                        int v = Integer.parseInt(r.get().trim());
                        if (v == 1 || v == 2 || v == 3) {
                            dt2 = v;
                        }
                    } catch (Exception ex) {
                        // ignore
                    }
                    if (dt2 == null) {
                        new Alert(Alert.AlertType.WARNING, "Only 1, 2 or 3 allowed!", ButtonType.OK).showAndWait();
                    }
                }

                List<String> dnm = new ArrayList<>();
                for (Product p : products) {
                    if ((dt2 == 1 && p instanceof Refrigerator) ||
                        (dt2 == 2 && p instanceof TV) ||
                        (dt2 == 3 && p instanceof Aircond)) {
                        dnm.add(p.getProductName());
                    }
                }
                if (dnm.isEmpty()) {
                    resultLabel.setText("No such products.");
                    break;
                }

                ChoiceDialog<String> dd4 = new ChoiceDialog<>(dnm.get(0), dnm);
                dd4.setTitle("Select Product");
                dd4.setHeaderText("Choose product to discontinue:");
                dd4.showAndWait().ifPresent(sel -> {
                    products.stream()
                        .filter(p -> p.getProductName().equals(sel))
                        .findFirst()
                        .ifPresent(p3 -> {
                            if (p3.getProductStatus()) {
                                p3.setProductStatus(false);
                                resultLabel.setText("Discontinued " + sel);
                            } else {
                                Alert a = new Alert(Alert.AlertType.CONFIRMATION,
                                    "Already discontinued. Change back to Active?",
                                    ButtonType.YES, ButtonType.NO);
                                a.showAndWait().ifPresent(bt -> {
                                    if (bt == ButtonType.YES) {
                                        p3.setProductStatus(true);
                                        resultLabel.setText("Re-activated " + sel);
                                    } else {
                                        resultLabel.setText("No change.");
                                    }
                                });
                            }
                        });
                });
                break;

                case "0":

                    String savedBy   = nameHolder[0];
                    String savedId   = idHolder[0];
                    String savedTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

   
                    try (FileWriter fw = new FileWriter("products.csv")) {
                        fw.write("Type,ItemNumber,ProductName,Quantity,Price,Status,Extra1,Extra2,Extra3\n");
                        for (Product p : products) {
                            String tn, e1="", e2="", e3="";
                            if (p instanceof Refrigerator) {
                                tn = "Refrigerator";
                                Refrigerator r = (Refrigerator)p;
                                e1 = r.getDoorDesign();
                                e2 = r.getColor();
                                e3 = String.valueOf(r.getCapacity());
                            } else if (p instanceof TV) {
                                tn = "TV";
                                TV tv = (TV)p;
                                e1 = tv.getScreenType();
                                e2 = tv.getResolution();
                                e3 = String.valueOf(tv.getDisplaySize());
                            } else if (p instanceof Aircond) {
                                tn = "Aircond";
                                Aircond a = (Aircond)p;
                                e1 = String.valueOf(a.getCoolingCapacity());
                                e2 = String.valueOf(a.getFanSpeedLevel());
                                e3 = a.getColor();
                            } else {
                                continue;
                            }
                            fw.write(String.join(",",
                                tn,
                                String.valueOf(p.getItemNumber()),
                                p.getProductName(),
                                String.valueOf(p.getQuantityAvailable()),
                                String.valueOf(p.getPrice()),
                                p.getPStatus(),
                                e1, e2, e3
                            ) + "\n");
                        }
                    } catch (IOException ex) {
                        resultLabel.setText("Error saving products.csv: " + ex.getMessage());
                        break;
                    }

 
                    File audit = new File("audit.csv");
                    boolean needHeader = !audit.exists();
                    try (FileWriter aw = new FileWriter(audit, true)) {
                        if (needHeader) {
                            aw.write("SavedTimestamp,LoginTimestamp,SavedByName,SavedByID\n");
                        }
                        aw.write(String.join(",",
                            savedTime,
                            loginTime,
                            "\"" + savedBy.replace("\"", "\"\"") + "\"",
                            savedId
                        ) + "\n");
                    } catch (IOException ex) {
                        resultLabel.setText("Error writing audit.csv: " + ex.getMessage());
                        break;
                    }

                    resultLabel.setText(
                        "Products saved to products.csv\n" +
                        "Log appended to audit.csv\n" +
                        "Saved by: " + savedBy + " (" + savedId + ") at " + savedTime + "\n" +
                        "Login at: " + loginTime
                    );
                    break;



                default:
                    resultLabel.setText("Invalid choice. Enter 0–4.");
            }
        });

        VBox center = new VBox(10, menuText, menuInput, submit, scroll);
        center.setPadding(new Insets(20));
        BorderPane root = new BorderPane();
        root.setTop(topBox);
        root.setCenter(center);
        root.setBottom(userInfoLabel);
        BorderPane.setAlignment(userInfoLabel, Pos.CENTER);
        BorderPane.setMargin(userInfoLabel, new Insets(10));

        stage.setScene(new Scene(root, 900, 600));
        stage.show();
    }

    public static void main(String[] args) {
        launch(args);
    }
}