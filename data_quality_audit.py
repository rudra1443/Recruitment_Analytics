import pandas as pd
import os

# Load all tables
tables = {
    'candidates': 'data/raw/candidates.csv',
    'job_openings': 'data/raw/job_openings.csv',
    'applications': 'data/raw/applications.csv',
    'interviews': 'data/raw/interviews.csv',
    'offers': 'data/raw/offers.csv'
}

base = 'C:/Users/kushw/Desktop/Daily_Project/Recruitment_Analytics/data/raw/'

print('=' * 80)
print('DATA QUALITY AUDIT - RECRUITMENT ANALYTICS')
print('=' * 80)

for name, filepath in tables.items():
    df = pd.read_csv(base + name + '.csv')
    
    print(f'\n{"="*60}')
    print(f'TABLE: {name.upper()}')
    print(f'{"="*60}')
    print(f'Rows: {len(df)} | Columns: {len(df.columns)}')
    print(f'Columns: {list(df.columns)}')
    print(f'\nData Types:')
    print(df.dtypes.to_string())
    print(f'\nMissing Values:')
    missing = df.isnull().sum()
    print(missing[missing > 0].to_string() if (missing > 0).any() else '  None')
    print(f'Duplicate Rows: {df.duplicated().sum()}')
    print(f'Unique Values:')
    for col in df.columns:
        n_unique = df[col].nunique()
        print(f'  {col}: {n_unique}')
    print(f'Null Percentage: {df.isnull().sum().sum() / (len(df) * len(df.columns)) * 100:.2f}%')

print('\n\n' + '=' * 80)
print('DATE CONSISTENCY CHECK')
print('=' * 80)

app = pd.read_csv(base + 'applications.csv')
app['applied_at_dt'] = pd.to_datetime(app['applied_at'], errors='coerce')
app['application_date_dt'] = pd.to_datetime(app['application_date'], errors='coerce')

diff = app['applied_at_dt'] - app['application_date_dt']
print(f'Applied_at vs Application_date:')
print(f'  Mean diff: {diff.mean()}')
print(f'  Median diff: {diff.median()}')
print(f'  Min diff: {diff.min()}')
print(f'  Max diff: {diff.max()}')
print(f'  Rows with large diff (>1 day): {(diff.abs() > pd.Timedelta(days=1)).sum()}')

print('\n\n' + '=' * 80)
print('CANDIDATE RATINGS ANALYSIS')
print('=' * 80)

print(app['candidate_rating'].describe())
print(f'Nulls: {app["candidate_rating"].isnull().sum()}')

print('\n\n' + '=' * 80)
print('INTERVIEW SCORE ANALYSIS')
print('=' * 80)

inter = pd.read_csv(base + 'interviews.csv')
print(inter['score'].describe())
print(f'Nulls: {inter["score"].isnull().sum()}')
print(f'Interviewer Names: {inter["interviewer"].nunique()}')

print('\n\n' + '=' * 80)
print('OFFER STATUS ANALYSIS')
print('=' * 80)

off = pd.read_csv(base + 'offers.csv')
print(off['offer_status'].value_counts())
print(f'Nulls: {off["offered_at"].isnull().sum()}, Salary nulls: {off["salary"].isnull().sum()}')

print('\n\n' + '=' * 80)
print('JOB OPENINGS STATUS')
print('=' * 80)

jo = pd.read_csv(base + 'job_openings.csv')
print(jo['status'].value_counts())
