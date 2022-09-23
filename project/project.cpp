#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <math.h>
using namespace std;

int stoint(string);
int log2(int);
long long btod(string);

int main(int argc, char *argv[])
{
	ifstream cache(argv[1]/*"cache.org"*/);
	ifstream refer(argv[2]/*"reference.lst"*/);
	ofstream index(argv[3]/*"index.rpt"*/);
	
	if(!cache) cout << "Failed to read cache!" << endl;
	if(!refer) cout << "Failed to read refer!" << endl;
	if(!index) cout << "Failed to open index!" << endl; 
	
	string line;
	int adres, ofscnt, cacset, idxcnt, asoci, idx1st, one, miss = 0;
	
	while(getline(cache, line)){
		if(line[0] == 'A' && line[1] == 'd'){
			index << line.replace(line.find("_"), 1, " ") << '\n';
			adres = stoint(line.substr(14));
		}		
		else if(line[0] == 'B'){
			index << line.replace(line.find("_"), 1, " ") << '\n';
			ofscnt = log2(stoint(line.substr(12)));
		}
		
		else if(line[0] == 'C'){
			index << line.replace(line.find("_"), 1, " ") << '\n';
			cacset = stoint(line.substr(12));
			idxcnt = log2(cacset);
		}
		else{
			index << line << '\n';
			asoci = stoint(line.substr(15));
		}			
	}
	
	idx1st = adres - ofscnt - idxcnt;
	index << "\nOffset bit count: " << ofscnt << '\n';
	index << "Indexing bit count: " << idxcnt << '\n';
	index << "Indexing bits: ";
	
	for(int i = idxcnt; i > 0 ; i--){
		if(i > 1) index << ofscnt + i - 1 << " ";
		else index << ofscnt + i - 1 << "\n\n";	
	}
	
	int **nru = new int*[cacset];
	long long **tag = new long long*[cacset];	
	for(int i = 0; i < cacset; i++){
		nru[i] = new int[asoci];
		tag[i] = new long long[asoci];
	}
	for(int i = 0; i < cacset; i++){
		for(int j = 0; j < asoci; j++){
			nru[i][j] = 1;
			tag[i][j] = -1;
		}
	}

	while(getline(refer, line)){
		index << line;
		if(line[0] == '0' || line[0] == '1'){			
			one = -1;
			for(int i = 0; i < asoci; i++){
				if(nru[btod(line.substr(idx1st, idxcnt))][i] == 1 && one < 0){
					one = i;
				}
				if(tag[btod(line.substr(idx1st, idxcnt))][i] == btod(line.substr(0, idx1st))){
					index << " hit\n";
					nru[btod(line.substr(idx1st, idxcnt))][i] = 0;
					break;
				}				
				else if(i == asoci - 1){
					if(one < 0){
						one = 0;
						for(int j = 0; j < asoci; j++){
							nru[btod(line.substr(idx1st, idxcnt))][j] = 1;
						}
					}
					miss++;
					index << " miss\n";
					tag[btod(line.substr(idx1st, idxcnt))][one] = btod(line.substr(0, idx1st));
					nru[btod(line.substr(idx1st, idxcnt))][one] = 0;
				}				
			}			
		}
		else if(line[0] == '.'){
			index << '\n';
		}
	}
	
	index << "\nTotal cache miss count: " << miss << endl;
	cache.close();
	refer.close();
	index.close();
	
	return 0;
}

int stoint(string str)
{
	stringstream ss;
	int num;
	
	ss << str; 
	ss >> num;
	
	return num;
}

int log2(int n)
{
	return ceil(log(n)/log(2)); 
}

long long btod(string str)
{
	long long decimal = 0;
	long long power = 1;
		
	for(int i = str.length(); i > 0; i--){
		decimal += (str[i-1]-'0') * power;
		power *= 2;
	} 
	 
	return decimal;
}
