"""Create ValidationLabel table

Revision ID: 3ff0ad501645
Revises: 85858c8aaac5
Create Date: 2018-03-23 10:11:10.496994

"""

# revision identifiers, used by Alembic.
revision = '3ff0ad501645'
down_revision = '85858c8aaac5'
branch_labels = None
depends_on = None

from alembic import op
import sqlalchemy as sa


def upgrade(engine_name):
    globals()["upgrade_%s" % engine_name]()


def downgrade(engine_name):
    globals()["downgrade_%s" % engine_name]()





def upgrade_data_broker():
    ### commands auto generated by Alembic - please adjust! ###
    op.create_table('validation_label',
    sa.Column('created_at', sa.DateTime(), nullable=True),
    sa.Column('updated_at', sa.DateTime(), nullable=True),
    sa.Column('validation_label_id', sa.Integer(), nullable=False),
    sa.Column('label', sa.Text(), nullable=True),
    sa.Column('error_message', sa.Text(), nullable=True),
    sa.Column('file_id', sa.Integer(), nullable=True),
    sa.Column('column_name', sa.Text(), nullable=True),
    sa.Column('label_type', sa.Enum('requirement', 'type', name='label_types'), nullable=True),
    sa.ForeignKeyConstraint(['file_id'], ['file_type.file_type_id'], name='fk_file'),
    sa.PrimaryKeyConstraint('validation_label_id')
    )
    ### end Alembic commands ###


def downgrade_data_broker():
    ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('validation_label')
    op.execute("DROP TYPE label_types")
    ### end Alembic commands ###

