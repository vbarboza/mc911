class A
{
    public static void main(String[] args)
    {
    	System.out.println(new B().soma());
    }
}
class B
{
	public int soma()
	{
		int x;
		if (1==2)
			x = 1;
		else
			x = 2;
		return x;
	}
}