class A
{
    public static void main(String[] args)
    {
    	System.out.println(new B().soma(1,2));
    }
}
class B
{
	int x;
	int y;
	public int soma(int a, int b)
	{
		int s;
		s = (a+b);
		return s;
	}
}