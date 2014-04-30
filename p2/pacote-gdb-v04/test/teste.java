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
		if (1==2) {
			x = 1;
			x=3;
			x=4;
		}
		else {
			x = 2;
			x=3;
		}
		return x;
	}
}