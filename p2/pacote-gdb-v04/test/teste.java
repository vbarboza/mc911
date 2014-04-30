class A
{
    public static void main(String[] args)
    {
    	System.out.println(new C().soma());
    }
}
class B
{
	int [] x;
	int y;
	public int soma(D test)
	{
		x = new int [10];
		x[0]=20;
		return x[0];
	}
}

class C
{
	B x;
	B h;
	public int soma() {
		D teste;
		x = new B();
		return x.soma(teste);
	}
}

class D
{
	int a;
	public int geta() {
		return a;
	}
	public int seta(int b) {
		a=b;
		return 0;
	}
}