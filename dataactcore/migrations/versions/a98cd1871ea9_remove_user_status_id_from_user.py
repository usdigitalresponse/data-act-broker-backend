"""remove user_status_id from user

Revision ID: a98cd1871ea9
Revises: e97127c44797
Create Date: 2016-12-22 11:59:35.173573

"""

# revision identifiers, used by Alembic.
revision = 'a98cd1871ea9'
down_revision = 'e97127c44797'
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
    op.drop_constraint('users_user_status_id_fkey', 'users', type_='foreignkey')
    op.drop_column('users', 'user_status_id')
    ### end Alembic commands ###


def downgrade_data_broker():
    ### commands auto generated by Alembic - please adjust! ###
    op.add_column('users', sa.Column('user_status_id', sa.INTEGER(), autoincrement=False, nullable=True))
    op.create_foreign_key('users_user_status_id_fkey', 'users', 'user_status', ['user_status_id'], ['user_status_id'])
    ### end Alembic commands ###
