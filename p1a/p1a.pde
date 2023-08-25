// Dong Hyuk Park
// Test the matrix transformation commands that you will write
void setup() {
  size (100, 100);
  mat_test();
}

// test the various matrix commands and print out the current transformation matrix
void mat_test() {
  
    println("1. Initialize Matrix Stack");
    gtInitialize();
    print_stack();
    
    println("2. Test Push Matrix");
    gtInitialize();
    gtPushMatrix();
    print_stack();
    
    println("3. Test Stack Underflow");
    gtInitialize();
    gtPopMatrix();
    println("");
    
    println("4. Test updateTopMatrix");
    gtInitialize();
    Matrix test1 = new Matrix();
    for (int i = 0; i < 3; i++) test1.values[i][i] = 2.0;
    updateTopMatrix(test1);
    gtPushMatrix();
    Matrix test2 = new Matrix();
    for (int i = 0; i < 3; i++) test2.values[i][i] = 3.0;
    updateTopMatrix(test2);
    print_stack();

    println("5. Translate");
    gtInitialize();
    gtTranslate(3,2,1.5);
    print_ctm();

    println("6. Translate and Matrix Stack");
    gtInitialize();
    gtTranslate(-1,4,-2);
    println("After First Translation:");
    print_stack();
    gtPushMatrix();
    println("After Push:");
    print_stack();
    gtTranslate(2,-2,5);
    println("After Second Translation:");
    print_stack();
    gtPopMatrix();
    println("After Pop:");
    print_stack();

    println("7. Scale");
    gtInitialize();
    gtScale(2,3,4);
    print_ctm();

    println("8. Rotate X");
    gtInitialize();
    gtRotateX(90);
    print_ctm();

    println("9. Rotate Y");
    gtInitialize();
    gtRotateY(-15);
    print_ctm();

    println("10. Rotate Z and Matrix Stack");
    gtInitialize();
    gtPushMatrix();
    gtRotateZ(45);
    print_ctm();
    gtPopMatrix();
    print_ctm();

    println("11. Rotate and Translate");
    gtInitialize();
    gtRotateZ(90);
    gtTranslate(7,5,3);
    print_ctm();

    println("12. Translate and Rotate");
    gtInitialize();
    gtTranslate(7,5,3);
    gtRotateZ(90);
    print_ctm();

    println("13. Translate and Scale");
    gtInitialize();
    gtTranslate(1.5,2.5,3.5);
    gtScale(2,2,2);
    print_ctm();

    println("14. Scale and Translate");
    gtInitialize();
    gtScale(4,2,0.5);
    gtTranslate(2,-2,10);
    print_ctm();
}

void draw() {
}
