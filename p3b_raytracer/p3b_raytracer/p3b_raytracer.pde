boolean debug_flag = false;
ArrayList<Shape> shapes = new ArrayList<>();
ArrayList<Light> lights = new ArrayList<>();
PVector eyeVec = null;
Material currMaterial = null;
PVector[] uvw = new PVector[3];
float daFOV = 0;
PVector bgColor = null;

PVector v1 = null;
PVector v2 = null;
PVector v3 = null;


void setup() {
  size(500, 500);
  noStroke();
  colorMode(RGB, 1.0);
  background(0, 0, 0);
  frameRate(30);
}

void keyPressed() {
  reset_scene();
  switch(key) {
  case '1':
    interpreter("01_one_sphere.cli");
    break;
  case '2':
    interpreter("02_three_spheres.cli");
    break;
  case '3':
    interpreter("03_shiny_sphere.cli");
    break;
  case '4':
    interpreter("04_many_spheres.cli");
    break;
  case '5':
    interpreter("05_one_triangle.cli");
    break;
  case '6':
    interpreter("06_icosahedron_and_sphere.cli");
    break;
  case '7':
    interpreter("07_colorful_lights.cli");
    break;
  case '8':
    interpreter("08_reflective_sphere.cli");
    break;
  case '9':
    interpreter("09_mirror_spheres.cli");
    break;
  case '0':
    interpreter("10_reflections_in_reflections.cli");
    break;
  case '-':
    interpreter("11_star.cli");
    break;
  case 'q':
    exit();
    break;
  }
}

void interpreter(String filename) {  
  println("");
  println("Parsing '" + filename + "'");
  String str[] = loadStrings(filename);
  if (str == null) println("Error! Failed to read the cli file.");

  for (int i = 0; i < str.length; i++) {

    String[] token = splitTokens(str[i], " ");  // Get a line and parse the tokens

    if (token.length == 0) continue; // Skip blank lines

    if (token[0].equals("fov")) {
      float fov = float(token[1]);
      
      // call routine to save the field of view
      daFOV = fov;
      
      println("FOV: ", fov);
    } 
    else if (token[0].equals("background")) {
      float r = float(token[1]);
      float g = float(token[2]);
      float b = float(token[3]);
      
      // call routine to save the background color
      bgColor = new PVector(r, g, b);
      
      println("Background: ", r, g, b);
    } else if (token[0].equals("eye")) {
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      
      println("Eye : ", x, y, z);
      
      // call routine to save the eye position
      eyeVec = new PVector(x, y, z);
      
    } else if (token[0].equals("uvw")) {
      float ux = float(token[1]);
      float uy = float(token[2]);
      float uz = float(token[3]);
      float vx = float(token[4]);
      float vy = float(token[5]);
      float vz = float(token[6]);
      float wx = float(token[7]);
      float wy = float(token[8]);
      float wz = float(token[9]);
      
      println("UVW: ", ux, uy, uz, vx, vy, vz, wx, wy, wz);
      
      uvw[0] = new PVector(ux, uy, uz);
      uvw[1] = new PVector(vx, vy, vz);
      uvw[2] = new PVector(wx, wy, wz);
      
      // call routine to save the camera's values for u,v,w
    } else if (token[0].equals("light")) {
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      float r = float(token[4]);
      float g = float(token[5]);
      float b = float(token[6]);
      
      println("Light: ", x, y, z, r, g, b);
      
      PVector lightPos = new PVector(x, y, z);
      PVector lightCol = new PVector(r, g, b);
      lights.add(new Light(lightPos, lightCol));
      
      // call routine to save lighting information
    } else if (token[0].equals("surface")) {
      float dr = float(token[1]);
      float dg = float(token[2]);
      float db = float(token[3]);
      float ar = float(token[4]);
      float ag = float(token[5]);
      float ab = float(token[6]);
      float sr = float(token[7]);
      float sg = float(token[8]);
      float sb = float(token[9]);
      float specP = float(token[10]);
      float Krefl = float(token[11]);
      
      println("Surface: ", dr, dg, db, ar, ag, ab, sr, sg, sb, specP, Krefl);
      
      PVector diffuseCol = new PVector(dr, dg, db);
      PVector ambientCol = new PVector(ar, ag, ab);
      PVector specCol = new PVector(sr, sg, sb);
      currMaterial = new Material(diffuseCol, ambientCol, specCol, specP, Krefl);
      
      // call routine to save the surface material properties
    } else if (token[0].equals("sphere")) {
      float radius = float(token[1]);
      float x = float(token[2]);
      float y = float(token[3]);
      float z = float(token[4]);
      println("Sphere: ", radius, x, y, z);
      //call your sphere making routine here
      
      //Store currMaterial as the sphere's material
      shapes.add(new Sphere(radius, new PVector(x, y, z), currMaterial));
      
    } else if (token[0].equals("begin")) {
      //start storing vertices of a triangle
      println("Begin triangle: ");
      v1 = null;
      v2 = null;
      v3 = null;
    } else if (token[0].equals("vertex")) {
      //store single vertex of a triangle
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      println("Vertex: ", x, y, z);

      if (v1 == null)
        v1 = new PVector(x, y, z);
      else if (v2 == null)
        v2 = new PVector(x, y, z);
      else if (v3 == null)
        v3 = new PVector(x, y, z);
      else
        println("Error!");
    } else if (token[0].equals("end")) {
      //stop storing vertices of a triangle
      shapes.add(new Triangle(v1, v2, v3, currMaterial));
      println("Stop triangle");
    } else if (token[0].equals("render")) {
      render_scene();
    } else if (token[0].equals("#")) {
      // comment symbol (ignore this line)
    } else {
      println ("cannot parse this line: " + str[i]);
    }
  }
}

void reset_scene() {
  //reset the global scene variables here
  shapes = new ArrayList<>();
  lights = new ArrayList<>();
}

void render_scene() {
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {

      // maybe turn on a debug flag for a particular pixel (so you can print ray information)
      // if (x == 375 && y == 200)
      if (x == 250 && y == 250)
      {
        Debug.debug = true;
        debug_flag = true;
        println("===== Logging info for (x, y) = (" + x + ", " + y + ") =====");
      }
      else
      {
        Debug.debug = false;
        debug_flag = false;
      }

      // create and cast an eye ray for pixel (x, y) and cast it into the scene
      // First, compute d, U, V. You may want to read TA note before implementing this section.
      float d = (float) (1 / tan(radians(daFOV) / 2));
      float U = ((float)(2 * x) / width) - 1;
      float V = ((float)(2 * (height - y)) / height) - 1;
      
      // Then we want to calculate direction of the eye ray. Don't forget to normalize the direction vector!
      // (tip) Useful functions: PVector.mult, PVector.add: https://processing.org/reference/PVector.html
      PVector dirVec = PVector.mult(uvw[2], -1 * d);
      dirVec = PVector.add(dirVec, PVector.mult(uvw[1], V));
      dirVec = PVector.add(dirVec, PVector.mult(uvw[0], U));
      dirVec.normalize();
      
      // Create a ray using eyeVec and dirVec.
      Ray currRay = new Ray(eyeVec, dirVec);
      if (debug_flag) {
        println("");
        println("uvw vectors: ", uvw);
        println("scalar", U, V);
        println("ray origin: ", eyeVec);
        println("ray direction: ", dirVec);
        println();
      }
      
      //Call function that loops through all the scene objects 
      //and returns the one that is closest to the ray, if applicable
      Hit pixHit = rayIntersectScene(currRay);
      PVector shadeCol = shadeHelper(pixHit, 10);
      
      // if (debug_flag)
      // {
      //   shadeCol = new PVector(1, 0, 0);
      // }

      //set the pixel color
      color pixCol = color(shadeCol.x, shadeCol.y, shadeCol.z); // you should put the pixel color here, converting from [0,1] to [0,255]
      set (x, y, pixCol);   // make a tiny rectangle to fill the pixel
    }
  }
}

/*
 * Loop through all scene objects and see if the ray intersects with any of them
 * If the ray intersects with multiple scene objects, return the closest one
 */
Hit rayIntersectScene(Ray ray) {
  float minT = Float.MAX_VALUE;  // Some large number
  Hit minHit = null;  // return null, if there is no hit.
  
  // Iterate though all the shapes (global variable shapes) and returns the closest hit.
  // Please implement Sphere.intersectRay function and use it.

  for (int i = 0; i < shapes.size(); i++)
  {
    Hit hitInfo = shapes.get(i).intersectRay(ray);
    if (hitInfo != null && hitInfo.t < minT)
    {
      minHit = hitInfo;
      minT = hitInfo.t;
    }
  }

  if (debug_flag)
  {
    println("The hit with the smallest t value is " + minT);
    println();
  }
  return minHit;
}

/*
 * Helper function that implements diffuse shading for a given "Hit" object
 * Uses the material and normal vectors for the "shape" of the Hit object (sphere or triangle)
 */
PVector shadeHelper(Hit sceneHit, int depth) {
  if (sceneHit == null) {
    return bgColor;
  }
  PVector totalCol = new PVector(0, 0, 0);
  // Get the norm vector from sceneHit.
  PVector N = sceneHit.norm;

  // Ambient shading by just adding on the ambient color
  // ===== (TODO) Stage 2a begins =======
  if (Debug.DO_AMBIENT)
  {
    // (TODO) update the total color using the given ambient color: sceneHit.hitShape.mat.ambColor 
    totalCol.add(sceneHit.hitShape.mat.ambColor);
  }
  // ===== (TODO) Stage 2a ends =======

  // This is the origin of the shadow ray. For the given intersection, we move it a little bit toward the normal direction to avoid awkward self-collision. 
  PVector shadow_ray_orig = PVector.mult(N, 1e-6);
  shadow_ray_orig = PVector.add(sceneHit.interPoint, shadow_ray_orig);

  if (Debug.DO_REFLECTION && depth > 0 && sceneHit.hitShape.mat.kRefl > 0)
  {
    // ===== (TODO) Stage 4 begins =======
    
    // Compute the reflection vector R = d + (2 * (N dot (-d))) * N, where d = ray direction. Don't forget to normalize the vector.
    PVector d = sceneHit.ray.direction;
    float N_dot_d = PVector.dot(N, d);
    PVector R = PVector.sub(d, PVector.mult(N, 2 * N_dot_d));
    R.normalize();
    
    // Create a new reflected ray using the shadow_ray_orig and R.
    Ray reflected_ray = new Ray(shadow_ray_orig, R);
    // ===== (TODO) Stage 4 ends =======
    Hit reflect_hit = rayIntersectScene(reflected_ray);
    PVector reflect_color = shadeHelper(reflect_hit, depth - 1);
    PVector reflect_contribution = PVector.mult(reflect_color, sceneHit.hitShape.mat.kRefl);
    totalCol = PVector.add(totalCol, reflect_contribution);
  }

  for (Light currLight: lights) {
    if (Debug.DO_SHADOWS)
    {
      // ===== (TODO) Stage 3 begins =======
      // Compute the direction of the shadow ray. From the intersection point (sceneHit.interpoint), it should toward the light position (currLight.pos).
      PVector shadow_ray_dir = PVector.sub(currLight.pos, sceneHit.interPoint);
      shadow_ray_dir.normalize();
      Ray shadow_ray = new Ray(shadow_ray_orig, shadow_ray_dir); // Create the shawdow ray
      // ===== (TODO) Stage 3 ends =======
      Hit shadow_hit = rayIntersectScene(shadow_ray);

      float dist = PVector.dist(shadow_ray_orig, currLight.pos);
      if (shadow_hit != null && shadow_hit.t < dist)
          continue;
    }


    // Get the diffusion color
    PVector currShapeDifCol = sceneHit.hitShape.mat.difColor;
    // Compute the L vector from lightPosition and sceneHit.interPoint. Normalize it again.
    PVector L = PVector.sub(currLight.pos, sceneHit.interPoint);
    L.normalize();

    // Compute 1) N dot L, 2) compute diffuse color, and add it to the total color.  
    float diffuseFactor = max(0, PVector.dot(L, N));
    PVector diffuseContribution = PVector.mult(
      pairwiseMult(currLight.col, sceneHit.hitShape.mat.difColor),
      diffuseFactor
    );
    
    if (Debug.DO_SPECULAR)
    {
      // ===== (TODO) Stage 2b begins =======
      // Do we have L vector here? Yes!   
      PVector D = PVector.mult(sceneHit.ray.direction, -1); // D is a ray direction vector
      PVector H; 
      H = PVector.add(L, D); // H is the halfway vector that is normalized
      H.normalize();
      float p = sceneHit.hitShape.mat.specPow;  // Adjust the sharpness of the specular
      float specular_coeff = pow(max(0, PVector.dot(H, N)), p); // compute the spectacular coefficient, using H, N, and p
      // ===== (TODO) Stage 2b ends =======
      // If you compute up to here, the rest of the codes should work. 
      PVector specular_contribution = PVector.mult(
          pairwiseMult(currLight.col, sceneHit.hitShape.mat.specColor),
          specular_coeff
      );
      totalCol = PVector.add(totalCol, specular_contribution);
    }

    if (debug_flag)
    {
      println("calculating contribution of the light whose position is: " + currLight.pos);
      println("N: " + N);
      println("L: " + L);
      println("light color: " + currLight.col);
      println("surface's diffuse color: " + sceneHit.hitShape.mat.difColor);
      println("light's contribution (light color * diffuse color * (N dot L)): " + diffuseContribution);
      println();
    }

    totalCol = PVector.add(totalCol, diffuseContribution);
  }
  
  return totalCol;
  
}

PVector pairwiseMult(PVector a, PVector b)
{
  return new PVector(
    a.x * b.x,
    a.y * b.y,
    a.z * b.z
  );
}

void draw() {
}

void mousePressed() {
  println ("Mouse pressed at location: " + mouseX + " " + mouseY);
}
