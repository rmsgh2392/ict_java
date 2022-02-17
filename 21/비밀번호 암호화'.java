
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
import javax.crypto.*;

public class AESAlgorithm {
	String plainText;
	SecretKey mySecretKey;
	Cipher myCypherIn, myCypherOut;
	byte[] cipherTextByte;
	String cipherText;
	String decryptText;
	
	public void EncryptAES() throws Exception {
		// 암호화 알고리즘을 세웁니다.
        mySecretKey = KeyGenerator.getInstance("AES").generateKey();

        // 키 값을 부여한 뒤에는 AES 알고리즘을 이용해 암호(Cipher)를 만듭니다.
        myCypherOut = Cipher.getInstance("AES");

        // 만든 암호를 아까 생성한 키 값을 이용해서 초기화해줍니다.
        myCypherOut.init(Cipher.ENCRYPT_MODE, mySecretKey);
        
        // 암호화되지 않은 문자에서 각각의 바이트를 암호화 해줍니다.
        cipherTextByte = myCypherOut.doFinal(plainText.getBytes());
       
        // 이제 그 바이트를 문자열로 바꾸어줍니다. 즉, 암호 그 자체를 말합니다.
        cipherText = new String(cipherTextByte);
        
        //return cipherText;
	}
	
	public void DecryptAES() throws Exception {
		 // 복호화 세팅을 해줍니다. AES 알고리즘을 이용합니다.
        myCypherIn = Cipher.getInstance("AES");

        // 이번에 만든 암호(Cipher) 객체는 복호화 모드를 잡아줍니다. 또 처음 만든 키 값으로 복호화를 해주는 것이죠.
        myCypherIn.init(Cipher.DECRYPT_MODE, mySecretKey);
       
        // 복호화 문자를 만들어줍니다.
        decryptText = new String(myCypherIn.doFinal(cipherTextByte));

        //return decryptText;
	}
	
	public void execute() {
		// 암호화될 문자열을 설정합니다.
		plainText = "This is AES Encrypt Algorithm.";
		
		try {
			EncryptAES();
			DecryptAES();
			print();
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void print() {
		// 처음 문자, 암호, 해독 문자를 출력합니다.
        System.out.println("PlainText: " + plainText);
        System.out.println("Encrypted Text: " + cipherText);
        System.out.println("Decrypted Text: " + decryptText);
	}

    public static void main(String[] args) throws Exception {
    	AESAlgorithm aes = new AESAlgorithm();
    	
        aes.execute();
    }

}