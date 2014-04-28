class A
{
    public static void main(String[] args)
    {
    	System.out.println(new B().soma());
    }
}
class B
{
	int x;
	int y;
	C teste;
	public int soma()
	{
		teste = new C();
		x= teste.aoooba();
		return x;
	}
}

class C
{
	int x;
	public int aoooba() {
		x = 10;
		return x;
	}
}