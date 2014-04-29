class A
{
    public static void main(String[] args)
    {
    	System.out.println(new B().soma());
    }
}
class B
{
	int [] x;
	int y;
	public int soma()
	{
		x = new int [10];
		x[0]=10;
		return x[0];
	}
}