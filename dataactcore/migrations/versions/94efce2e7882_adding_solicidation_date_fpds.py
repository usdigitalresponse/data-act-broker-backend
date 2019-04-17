"""adding solicidation date fpds

Revision ID: 94efce2e7882
Revises: ba7e8e488c36
Create Date: 2019-03-15 18:44:14.362923

"""

# revision identifiers, used by Alembic.
revision = '94efce2e7882'
down_revision = 'ba7e8e488c36'
branch_labels = None
depends_on = None

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

def upgrade(engine_name):
    globals()["upgrade_%s" % engine_name]()


def downgrade(engine_name):
    globals()["downgrade_%s" % engine_name]()





def upgrade_data_broker():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('award_procurement', sa.Column('solicitation_date', sa.Text(), nullable=True))
    op.add_column('detached_award_procurement', sa.Column('solicitation_date', sa.Text(), nullable=True))
    # ### end Alembic commands ###


def downgrade_data_broker():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('detached_award_procurement', 'solicitation_date')
    op.drop_column('award_procurement', 'solicitation_date')
    # ### end Alembic commands ###
