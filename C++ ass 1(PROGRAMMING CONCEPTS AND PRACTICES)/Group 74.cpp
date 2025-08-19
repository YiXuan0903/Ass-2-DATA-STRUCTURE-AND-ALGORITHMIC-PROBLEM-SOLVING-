# include <iostream>
using namespace std;

int main()
{
	int N, N1, N2, p, P, occurence;
	cout << "N must be greater than 1" << endl;
	cout << "Please enter a number: ";
	cin >> N;
	if (N <= 1)
	{
		cout << "Invalid input";
		return 0;
	}



	N1 = N, N2 = N;

	//for the ascending order

	cout << "---" << endl;
	p = 2;
	while (N1 > 1) 
	{
		if (N1 % p == 0)
		{
			occurence = 0;
			while (N1 % p == 0) 
			{
				N1 /= p;
				occurence++;
			}
			cout << p << " " << occurence << endl;
		}
		else
		{
			p++;
		}
	}


	//for the descending order

	cout << "---" << endl;
	while (N2 > 1)
	{
		p = 2;
		while (N2 % p != 0)
		{
			p++;
		}

		P = p;

		int n = N2;
		while (n > 1)
		{
			if (n % p == 0)
			{
				n /= p;
				if (P < p)
				{
					P = p;
				}
			}
			else
			{
				p++;
			}
		}

		occurence = 0;
		while (N2 % P == 0)
		{
			N2 /= P;
			occurence++;
		}
		cout << P << " " <<  occurence << endl;
	}

	return 0;
}
