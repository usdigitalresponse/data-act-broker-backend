""" Adding FABS record_type index, FSRSGrant federal_agency_id

Revision ID: 4c4dd19af4ac
Revises: 6a7dfeb64b27
Create Date: 2019-12-20 16:29:32.890994

"""

# revision identifiers, used by Alembic.
revision = '4c4dd19af4ac'
down_revision = '6a7dfeb64b27'
branch_labels = None
depends_on = None

from alembic import op
from sqlalchemy import text
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

def upgrade(engine_name):
    globals()["upgrade_%s" % engine_name]()


def downgrade(engine_name):
    globals()["downgrade_%s" % engine_name]()





def upgrade_data_broker():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_index(op.f('ix_pafa_record_type'), 'published_award_financial_assistance', ['record_type'], unique=False)
    op.create_index(op.f('ix_fsrs_grant_federal_agency_id_upper'), 'fsrs_grant', [text('UPPER(federal_agency_id)')], unique=False)
    # ### end Alembic commands ###


def downgrade_data_broker():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_index(op.f('ix_pafa_record_type'), table_name='published_award_financial_assistance')
    op.drop_index(op.f('ix_fsrs_grant_federal_agency_id_upper'), table_name='fsrs_grant')
    # ### end Alembic commands ###

