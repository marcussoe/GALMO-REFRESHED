@isTest
public class EmpreendimentoHelperTest {

    @isTest
    static void testValidarCNPJ_ValidCNPJ() {
        String cnpj = '12345678000101';
        Boolean isValid = EmpreendimentoHelper.validarCNPJ(cnpj);
    }

    @isTest
    static void testValidarCNPJ_InvalidCNPJ_Length() {
        String cnpj = '1234567800'; // comprimento menor que 14
        Boolean isValid = EmpreendimentoHelper.validarCNPJ(cnpj);
        System.assertEquals(false, isValid);
    }

    @isTest
    static void testValidarCNPJ_InvalidCNPJ_Digits() {
        String cnpj = '12345678901234'; // CNPJ inválido
        Boolean isValid = EmpreendimentoHelper.validarCNPJ(cnpj);
        System.assertEquals(false, isValid);
    }

    @isTest
    static void testValidarCNPJ_InvalidCNPJ_CheckDigits() {
        String cnpj = '12345678000100'; // CNPJ inválido
        Boolean isValid = EmpreendimentoHelper.validarCNPJ(cnpj);
        System.assertEquals(false, isValid);
    }

    @isTest
    static void testValidarCNPJ_InvalidCNPJ_Null() {
        String cnpj = null;
        Boolean isValid = EmpreendimentoHelper.validarCNPJ(cnpj);
        System.assertEquals(false, isValid);
    }

    @isTest
    static void testValidarCNPJ_InvalidCNPJ_EmptyString() {
        String cnpj = '';
        Boolean isValid = EmpreendimentoHelper.validarCNPJ(cnpj);
        System.assertEquals(false, isValid);
    }
}