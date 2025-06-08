import pandas as pd
from sklearn.linear_model import LinearRegression

# Carregar os dados
df = pd.read_excel(r"C:\Users\victo\Documents\Data Analytics\Repository\Projects\Linear Regression\base_volume_16-05.xlsx")
df['DT_MES'] = pd.to_datetime(df['DT_MES'])

# Criar colunas auxiliares
df['ANO_MES'] = df['DT_MES'].dt.to_period('M')
df_mes = df.groupby('ANO_MES')['VOLUME'].sum().reset_index()
df_mes['ANO_MES'] = df_mes['ANO_MES'].dt.to_timestamp()
df_mes['ANO'] = df_mes['ANO_MES'].dt.year
df_mes['MES'] = df_mes['ANO_MES'].dt.month

# Calcular o volume já realizado em 2025 até abril
volume_real_2025_ate_abril = df_mes[(df_mes['ANO'] == 2025) & (df_mes['MES'] <= 4)]['VOLUME'].sum()

# Calcular a média dos últimos 8 meses de 2024
media_ultimos_8m_2024 = df_mes[(df_mes['ANO'] == 2024) & (df_mes['MES'] >= 5)]['VOLUME'].mean()

# Estimar os próximos 8 meses de 2025 com essa média
volume_estimado_maio_dez_2025 = media_ultimos_8m_2024 * 8

# Soma do volume já realizado + estimativa
volume_total_estimado_2025_ajustado = volume_real_2025_ate_abril + volume_estimado_maio_dez_2025

print(f"Volume previsto ajustado para 2025: {volume_total_estimado_2025_ajustado:,.0f} m³")