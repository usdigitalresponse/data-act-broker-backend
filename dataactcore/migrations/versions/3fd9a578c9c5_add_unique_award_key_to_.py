"""Add unique_award_key to AwardProcurement and AwardFinancialAssistance

Revision ID: 3fd9a578c9c5
Revises: 81969f6e3733
Create Date: 2020-01-23 14:39:59.527010

"""

# revision identifiers, used by Alembic.
revision = '3fd9a578c9c5'
down_revision = '81969f6e3733'
branch_labels = None
depends_on = None

from alembic import op
import sqlalchemy as sa


def upgrade(engine_name):
    globals()["upgrade_%s" % engine_name]()


def downgrade(engine_name):
    globals()["downgrade_%s" % engine_name]()





def upgrade_data_broker():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('award_financial_assistance', sa.Column('unique_award_key', sa.Text(), nullable=True))
    op.add_column('award_procurement', sa.Column('unique_award_key', sa.Text(), nullable=True))
    # ### end Alembic commands ###


def downgrade_data_broker():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('award_procurement', 'unique_award_key')
    op.drop_column('award_financial_assistance', 'unique_award_key')
    # ### end Alembic commands ###

