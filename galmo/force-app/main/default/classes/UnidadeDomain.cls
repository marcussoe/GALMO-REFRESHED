public class UnidadeDomain {
    public static Map<String, Product2> obterUnidadesEmpreendimentoPorChaveExterna(Id idEmpreendimento) {
        List<Product2> unidades = UnidadeSelector.obterUnidadesPorIdsEmpreendimentos(new Set<Id>{ idEmpreendimento });

        return obterUnidadesPorChaveExterna(unidades);
    }

    public static Map<String, Product2> obterUnidadesPorChaveExterna(List<Product2> unidades) {
        Map<String, Product2> unidadesPorChaveExterna = new Map<String, Product2>();
        for(Product2 unidade : unidades) {
            unidadesPorChaveExterna.put(unidade.ExternalId, unidade);
        }

        return unidadesPorChaveExterna;
    }
}