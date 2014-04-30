// testando array length (OK)
class m
{
   public static void main(String[] args)
   {
      System.out.println(new A().l());
   }
}

class A
{
	public int l() {
		int [] x;
		int y;
		y=5;
		x = new int[10];
		x[5]=2;
		return x.length;
	}
}