// Dong Hyuk Park
// Matrix Stack Library

// You should modify the routines below to complete the assignment.
// Feel free to define any classes, global variables, and helper routines that you need.

ArrayList<Matrix> mat_stack; // https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html

class Matrix {
  float[][] values;  // first subscript is row, second subscript is column
  
  // initialize the matrix as the identity
  Matrix() {
    values = new float[4][4];
    for (int i = 0; i < 4; i++)
      for (int j = 0; j < 4; j++)
        if (i == j)
          values[i][j] = 1.0;
        else
          values[i][j] = 0.0;
  }
}

Matrix mat_copy(Matrix m) {
  Matrix mat_new = new Matrix();
  
  for (int i = 0; i < 4; i++)
    for (int j = 0; j < 4; j++)
      mat_new.values[i][j] = m.values[i][j];

  return mat_new;
}

Matrix mat_multiply(Matrix a, Matrix b) {
  Matrix mat_new = new Matrix();
  
  for (int i = 0; i < 4; i++)
    for (int j = 0; j < 4; j++) {
      mat_new.values[i][j] = a.values[i][0] * b.values[0][j] + a.values[i][1] * b.values[1][j] +
                             a.values[i][2] * b.values[2][j] + a.values[i][3] * b.values[3][j];
    }

  return mat_new;
}

void print_ctm() {
  Matrix m = mat_stack.get(mat_stack.size() - 1);
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      print(m.values[i][j] + " ");
    }
    println();
  }
  println();
}

void print_stack() {
  println("==== Top of Stack ====");
  for (int k = mat_stack.size() - 1; k >= 0; k--) {
    Matrix m = mat_stack.get(k);
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        print(m.values[i][j] + " ");
      }
      println();
    }
    if (k > 0) {
      println();    
    }
  }
  println("======================");
  println();
  
}

void gtInitialize() {
  // Initialize mat_stack and add one matrix After this command is called, the only matrix on the stack should be the 4x4 identity matrix.
  // We will treat the last (= at size() - 1) matrix at the current transformation matrix. 
  
  // Initialize mat_stack
  mat_stack = new ArrayList<Matrix>();

  Matrix newMat = new Matrix();
  mat_stack.add(newMat);


}

void gtPushMatrix() {
  // Get the last element from the matrix stack, clone it, and add it to the last position of the stack.
  
  Matrix currentMat = mat_stack.get(mat_stack.size() - 1);
  // cloning last element from matrix stack
  Matrix newMat = mat_copy(currentMat);
  mat_stack.add(newMat);
  
}


void gtPopMatrix() {
  // Remove the last element from the matrix stack. Generate the error message "cannot pop the matrix stack" if there is only one matrix in the stack.


  int c = mat_stack.size();
  // when there is only one stack left
  if (c == 1) {
    System.out.println("cannot pop the matrix stack");
    return;
  } else {
    mat_stack.remove(c - 1);
  }
  
}

void updateTopMatrix(Matrix m) {
  // Update the top matrix in the stack.
  // Let ctm = the last element in the matrix stack. Then this function should do: new_ctm = old_ctm * matrix_m
  // Hint: useful functions: mat_stack.get, mat_stack.set, mat_multiply

  int c = mat_stack.size() - 1;
  Matrix currentMat = mat_stack.get(c);
  Matrix newMat = mat_multiply(currentMat, m);
  mat_stack.remove(c);
  mat_stack.add(newMat);
}

void gtTranslate(float x, float y, float z) {
  // Create a translate matrix and update the ctm.

  Matrix m = new Matrix();
  Matrix a = new Matrix();
  m.values[0][3] = x;
  m.values[1][3] = y;
  m.values[2][3] = z;
  int c = mat_stack.size() - 1;
  Matrix currentMat = mat_stack.get(c);
  a = mat_multiply(currentMat, m);
  mat_stack.add(a);
}

void gtScale(float x, float y, float z) {
  // Create a scale matrix and update the ctm.
    
  Matrix m = new Matrix();
  Matrix a = new Matrix();
  m.values[0][0] = x;
  m.values[1][1] = y;
  m.values[2][2] = z;
  int c = mat_stack.size() - 1;
  Matrix currentMat = mat_stack.get(c);
  a = mat_multiply(currentMat, m);
  mat_stack.add(a);
  
}

void gtRotateX(float theta) {
  // Create a rotateX matrix and update the ctm. Note that theta is given in degree.
  
  // convert theta into rad
  float rad = radians(theta);
  Matrix m = new Matrix();
  Matrix a = new Matrix();
  m.values[1][1] = cos(rad);
  m.values[1][2] = - sin(rad);
  m.values[2][1] = sin(rad);
  m.values[2][2] = cos(rad);
  int c = mat_stack.size() - 1;
  Matrix currentMat = mat_stack.get(c);
  a = mat_multiply(currentMat, m);
  mat_stack.add(a);
}

void gtRotateY(float theta) {
  // Create a rotateY matrix and update the ctm. Note that theta is given in degree.
 
  // convert theta into rad
  float rad = radians(theta);
  Matrix m = new Matrix();
  Matrix a = new Matrix();
  m.values[0][0] = cos(rad);
  m.values[0][2] = sin(rad);
  m.values[2][0] = -sin(rad);
  m.values[2][2] = cos(rad);
  int c = mat_stack.size() - 1;
  Matrix currentMat = mat_stack.get(c);
  a = mat_multiply(currentMat, m);
  mat_stack.add(a);
}

void gtRotateZ(float theta) {
  // Create a rotateZ matrix and update the ctm. Note that theta is given in degree.
   
  // convert theta into rad
  float rad = radians(theta);
  Matrix m = new Matrix();
  Matrix a = new Matrix();
  m.values[0][0] = cos(rad);
  m.values[0][1] = -sin(rad);
  m.values[1][0] = sin(rad);
  m.values[1][2] = cos(rad);
  int c = mat_stack.size() - 1;
  Matrix currentMat = mat_stack.get(c);
  a = mat_multiply(currentMat, m);
  mat_stack.add(a);
}
