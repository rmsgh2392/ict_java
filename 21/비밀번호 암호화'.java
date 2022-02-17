
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
		// ��ȣȭ �˰����� ����ϴ�.
        mySecretKey = KeyGenerator.getInstance("AES").generateKey();

        // Ű ���� �ο��� �ڿ��� AES �˰����� �̿��� ��ȣ(Cipher)�� ����ϴ�.
        myCypherOut = Cipher.getInstance("AES");

        // ���� ��ȣ�� �Ʊ� ������ Ű ���� �̿��ؼ� �ʱ�ȭ���ݴϴ�.
        myCypherOut.init(Cipher.ENCRYPT_MODE, mySecretKey);
        
        // ��ȣȭ���� ���� ���ڿ��� ������ ����Ʈ�� ��ȣȭ ���ݴϴ�.
        cipherTextByte = myCypherOut.doFinal(plainText.getBytes());
       
        // ���� �� ����Ʈ�� ���ڿ��� �ٲپ��ݴϴ�. ��, ��ȣ �� ��ü�� ���մϴ�.
        cipherText = new String(cipherTextByte);
        
        //return cipherText;
	}
	
	public void DecryptAES() throws Exception {
		 // ��ȣȭ ������ ���ݴϴ�. AES �˰����� �̿��մϴ�.
        myCypherIn = Cipher.getInstance("AES");

        // �̹��� ���� ��ȣ(Cipher) ��ü�� ��ȣȭ ��带 ����ݴϴ�. �� ó�� ���� Ű ������ ��ȣȭ�� ���ִ� ������.
        myCypherIn.init(Cipher.DECRYPT_MODE, mySecretKey);
       
        // ��ȣȭ ���ڸ� ������ݴϴ�.
        decryptText = new String(myCypherIn.doFinal(cipherTextByte));

        //return decryptText;
	}
	
	public void execute() {
		// ��ȣȭ�� ���ڿ��� �����մϴ�.
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
		// ó�� ����, ��ȣ, �ص� ���ڸ� ����մϴ�.
        System.out.println("PlainText: " + plainText);
        System.out.println("Encrypted Text: " + cipherText);
        System.out.println("Decrypted Text: " + decryptText);
	}

    public static void main(String[] args) throws Exception {
    	AESAlgorithm aes = new AESAlgorithm();
    	
        aes.execute();
    }

}